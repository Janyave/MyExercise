//
//  PlayerView.h
//  YaweiTest
//
//  Created by hzzhanyawei on 16/3/18.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/****************************************enum 定义**************************************************/
//播放状态
typedef NS_ENUM(NSUInteger, PlayStatus){
    PlayerPlay = 1,
    PlayerReuse,
    PlayerStop
};
/**
 *  播放区域填充方式
 */
typedef NS_ENUM(NSUInteger, PlayerResizeMode) {
    /**
     *  非均匀模式，两个维度完全填充到整个区域
     */
    PlayerViedoResizeScaleFill = 201,
    /**
     *  保持比例放大，直至有一个维度到达区域边界
     */
    PlayerVideoResizeAspectFit,
    /**
     *  保持比例放大，直至整个区域被填充，只用一个维度会被区域裁剪
     */
    PlayerVideoResizeAspectFill
};

/****************************************播放器委托*************************************************/
@protocol PlayerViewDelegate <NSObject>

@optional
/**
 *  播放器初始化成功，设置新的url时也会调用此函数
 *  
 *  此时才可以调用播放。
 *
 *  @param totalSecond 此时视频总的时间 单位为s
 */
- (void)onPlayerloadSuccessWithTotalSecond:(float)totalSecond;


/**
 *  当指定的视频播放完成是回调此函数
 */
- (void)onPlayerFinish;

/**
 *  当用所给的URL初始化播放器失败的时候调用此回调函数
 *
 *  @param aError 错误码，暂时为-1
 */
- (void)onPlayerloadError:(int)aError;

/**
 *  莫名原因中断，最大的可能就是网络中断
 */
- (void)onplaybackStalled;

/**
 *  实时更新播放的进度
 *
 *  @param aCurrentSecond 播放到的时间，单位为s
 */
- (void)onPlayerCurrentSecond:(float)aCurrentSecond;

/**
 *  播放器已经缓存的大小，实时更新
 *
 *  @param aBufferSecond  缓存的时间，单位为s
 */
- (void)onPlayerBufferSecond:(float)aBufferSecond;
@end


/****************************************播放器接口*************************************************/
@interface PlayerView : UIView

@property (nonatomic, assign) id <PlayerViewDelegate>delegate;

/*!
 *  根据给定的url进行初始化PlayerView
 *
 *  @param aUrl     指定的播放视频的URl，可以是网络的，也可以是本地的
 *  @param isCircle YES：视频进行循环播放，NO，不进行循环播放
 *
 *  @return 返回初始化成功的PlayerView
 */
- (PlayerView *)initPlayerViewWithURl:(NSURL *)aUrl isCircle:(BOOL)isCircle;

/**
 *  用新的URl代替老的url进行播放
 *
 *  @param aNewUrl 指定的播放视频的URl，可以是网络的，也可以是本地的
 *  @param isCircle 视频进行循环播放，NO，不进行循环播放
 */
- (void)setNewUrl:(NSURL *)aNewUrl isCircle:(BOOL)isCircle;;

///**
// *  根据指定的URl数组进行初始化Player
// *
// *  @param aURlArray 内部所包含的所有内容必须是NSURl的类型
// *
// *  @return 返回初始化成功的PlayerView
// */
//- (PlayerView *)initPlayerViewWithURlArray:(NSArray *)aURlArray;

/**
 *  设置播放器视频的展示模式
 *
 *  @param aVideoGravity ：具体含义详见PlayerResizeMode解释
 */
- (void)setPlayerVideoGravity:(PlayerResizeMode )aVideoGravity;

/**
 *  播放视频，当视频已经播放完时，再次点击play，从头开始播放
 */
- (void)play;

/**
 *  从给定的时间点开始播放
 *
 *  @param aTime 给定的播放时间点，如果给的时间点大于总长度，则从0开始播放
 */
- (void)playFromTime:(CGFloat)aTime;

/**
 *  暂停视频播放,再次调用play时会接着已经播放的位置进行播放
 */
- (void)pause;

/**
 *  停止视频播放，当调用此函数后，再次调用play，视频将从头开始播放
 */
- (void)stop;

/**
 *  设置视频是否静音，默认情况下，视频是静音的
 *
 *  @param isMute YES：视频静音; NO:视频不静音
 */
- (void)setPlayerMute:(BOOL)isMute;

/**
 *  获取播放器是否处于静音状态
 *
 *  @return YES：处于静音状态，NO：不处于静音状态
 */
- (BOOL)getPlayerMute;

/**
 *  设置播放器的音量
 *
 *  @param aVolumeValue 设置范围为0.0--1.0
 */
- (void)setPlayerVolume:(float)aVolumeValue;

/**
 *  获取播放器的音量
 *
 *  @return 范围播放器的音量
 */
- (float)getPlayerVolume;

/**
 *  获取播放器的此时的状态，播放，暂停，停止
 *
 *  @return 返回播放器的状态
 */
- (PlayStatus)getPlayStatus;
@end
