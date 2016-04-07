//
//  GifView.h
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/6.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifView : UIView
@property (nonatomic, assign)CGFloat totalTime;
@property (nonatomic, retain)NSMutableArray *frames;
@property (nonatomic, retain)NSMutableArray *frameDuriTimes;

//初始化
- (id)initWithFrame:(CGRect)frame andFilePath:(NSString *)path;
- (id)initWithFrame:(CGRect)frame andData:(NSData *)data;
//播放
- (void)start;

@end
