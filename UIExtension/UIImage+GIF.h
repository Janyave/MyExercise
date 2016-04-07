//
//  UIImage+GIF.h
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/7.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(GIF)
+ (UIImage *)animatedImageWithGifData:(NSData *)gifData;

+ (UIImage *)animatedImageWithGifUrl:(NSURL *)gifUrl;
@end
