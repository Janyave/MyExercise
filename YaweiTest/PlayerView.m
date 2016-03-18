//
//  PlayerView.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/3/18.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "PlayerView.h"


@interface PlayerView()

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) AVPlayerLayer *playerLayer;
@property (nonatomic, retain) NSURL *playerURL;
@property (nonatomic, retain) NSMutableArray *urlArray;
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic ,retain) id playbackTimeObserver;
@property (nonatomic, assign) CGFloat totalTime;
@end


@implementation PlayerView

#pragma mark - life cycle

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (void)dealloc
{
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self unmonitoringPlayback:self.player.currentItem];
    
    
    self.delegate = nil;
    [_player release];
    [_playerLayer release];
    [_playerURL release];
    [_urlArray release];
    
    [super dealloc];
}

#pragma mark - Notification Function

#pragma mark - public Function

- (PlayerView *)initPlayerViewWithURl:(NSURL *)aUrl isCircle:(BOOL)isCircle{
    self = [super init];
    if (self) {
        self.totalTime = 0.0;
        self.playerURL = aUrl;
        self.isCircle = isCircle;
        [self setupPlayer];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (PlayerView *)initPlayerViewWithURlArray:(NSArray *)aURlArray{
    self = [super init];
    if (self) {
        
        _urlArray = [[NSMutableArray alloc] init];
        [self.urlArray setArray:aURlArray];
        
    }
    return self;
}


- (void)setNewUrl:(NSURL *)aNewUrl isCircle:(BOOL)isCircle{
    self.isCircle = isCircle;
    
    [self unmonitoringPlayback:self.player.currentItem];
    //    self.playbackTimeObserver = nil;
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    AVPlayerItem *playerItem = [AVPlayerItem  playerItemWithURL:aNewUrl];
    [self addObserverToPlayerItem:playerItem];
    //切换视频
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
    [self monitoringPlayback:self.player.currentItem];
}

- (void)setPlayerVideoGravity:(PlayerResizeMode )aVideoGravity{
    switch (aVideoGravity) {
        case PlayerViedoResizeScaleFill: {
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResize];
            break;
        }
        case PlayerVideoResizeAspectFit: {
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
            break;
        }
        case PlayerVideoResizeAspectFill: {
            [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            break;
        }
    }
    
}


- (void)play{
    [self.player play];
    [self monitoringPlayback:self.player.currentItem];
}

- (void)playFromTime:(CGFloat)aTime{
    if (aTime > self.totalTime || aTime<0) {
        aTime = 0.0f;
    }
    
    CMTime changedTime = CMTimeMakeWithSeconds(aTime, 1);
    [self.player seekToTime:changedTime];
    [self.player play];
    [self monitoringPlayback:self.player.currentItem];
}

- (void)pause{
    [self.player pause];
    [self unmonitoringPlayback:self.player.currentItem];
}

- (void)stop{
    CMTime changedTime = CMTimeMakeWithSeconds(0.0, 1);
    [self.player seekToTime:changedTime];
    [self.player pause];
    [self unmonitoringPlayback:self.player.currentItem];
}

- (void)setPlayerMute:(BOOL)isMute{
    [self.player setMuted:isMute];
}

/*!
 *  获取播放器是否处于静音状态
 *
 *  @return YES：处于静音状态，NO：不处于静音状态
 */
- (BOOL)getPlayerMute{
    return self.player.muted;
}

/*!
 *  设置播放器的音量
 *
 *  @param aVolumeValue 设置范围为0.0--1.0
 */
- (void)setPlayerVolume:(float)aVolumeValue{
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:aVolumeValue atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    [allAudioParams addObject:audioInputParams];
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    [self.player.currentItem setAudioMix:audioMix];
    [self.player setVolume:aVolumeValue];
}

/*!
 *  获取播放器的音量
 *
 *  @return 范围播放器的音量
 */
- (float)getPlayerVolume{
    return self.player.volume;
}

/*!
 *  获取播放器的此时的状态，播放，暂停，停止
 *
 *  @return 返回播放器的状态
 */
- (PlayStatus)getPlayStatus{
    CGFloat status = self.player.rate;
    CGFloat currentSecond = self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale;// 计算当前在第几秒
    if (status==0.0) {
        if (currentSecond==0) {
            return PlayerStop;
        }
        else{
            return PlayerReuse;
        }
    }
    else{
        return PlayerPlay;
    }
}

#pragma mark - private Function

/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification *)aNotification{
    if (self.isCircle) {
        CMTime changedTime = CMTimeMakeWithSeconds(0.0, 1);
        [self.player seekToTime:changedTime];
        [self.player play];
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerFinish)]) {
            [self.delegate onPlayerFinish];
        }
    }
    
}

- (void)playbackStalled:(NSNotification *)aNotification{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onplaybackStalled)]) {
        [self.delegate onplaybackStalled];
    }
}

- (void)unmonitoringPlayback:(AVPlayerItem *)playerItem {
    
    if (self.playbackTimeObserver !=nil) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
        self.playbackTimeObserver = nil;
    }
    
}


- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    if (self.playbackTimeObserver !=nil) {
        [self unmonitoringPlayback:self.player.currentItem];
    }
    
    __block PlayerView *weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time)
                                 {
                                     CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
                                     [weakSelf changeCurrentSecond:currentSecond];
                                 }];
}

- (void)changeCurrentSecond:(CGFloat)currentSecond{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerCurrentSecond:)]) {
        [self.delegate onPlayerCurrentSecond:currentSecond];
    }
}

-(void)setupPlayer{
    if (!_player) {
        AVAsset *asset = [AVAsset assetWithURL:self.playerURL];
        //        AVPlayerItem *playerItem = [AVPlayerItem  playerItemWithURL:self.playerURL];
        AVPlayerItem *playerItem = [AVPlayerItem  playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    self.playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame=self.bounds;
    self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.layer addSublayer:self.playerLayer];
    [self addObserverToPlayerItem:self.player.currentItem];
    
    [self addNotification];
}

-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus newStatus= [[change objectForKey:@"new"] intValue];
        AVPlayerStatus oldStatus= [[change objectForKey:@"old"] intValue];
        if(newStatus==AVPlayerStatusReadyToPlay){
            if (newStatus != oldStatus) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerloadSuccessWithTotalSecond:)]) {
                    CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
                    self.totalTime = totalSecond;
                    [self.delegate onPlayerloadSuccessWithTotalSecond:totalSecond];
                }
                
            }
        }
        else if ([playerItem status] == AVPlayerStatusFailed) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerloadError:)]) {
                [self.delegate onPlayerloadError:-1];
            }
        }
        
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval totalBuffer = [self availableDuration];//缓冲总长度
        if (self.delegate && [self.delegate respondsToSelector:@selector(onPlayerBufferSecond:)]) {
            [self.delegate onPlayerBufferSecond:totalBuffer];
        }
    }
}

/*!
 *  获得缓冲的时长
 *
 *  @return 缓冲的时长
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

@end

