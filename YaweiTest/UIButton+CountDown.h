//
//  UIButton+CountDown.h
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/21.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton(CountDown)
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTile:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
@end
