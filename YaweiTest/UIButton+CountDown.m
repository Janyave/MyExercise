//
//  UIButton+CountDown.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/21.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton(CountDown)


- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTile:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color{
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }
        else{
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr, subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}
@end
