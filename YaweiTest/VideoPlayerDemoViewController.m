//
//  VideoPlayerDemoViewController.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/3/18.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "VideoPlayerDemoViewController.h"
#import "PlayerView.h"

@interface VideoPlayerDemoViewController ()<PlayerViewDelegate>

@property (nonatomic, strong)PlayerView *videoView;

@end

@implementation VideoPlayerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *aurl = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];//测试视频连接。//http要设置xcode
    _videoView = [[PlayerView alloc] initPlayerViewWithURl:aurl isCircle:YES];
    _videoView.frame = CGRectMake(10, 100, 300, 180);
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PlayerViewDelegate

- (void)onPlayerloadSuccessWithTotalSecond:(float)totalSecond{
    [self.videoView play];
}

- (void)onPlayerloadError:(int)aError{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
