//
//  GifView.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/6.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "GifView.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@implementation GifView

- (id)initWithFrame:(CGRect)frame andFilePath:(NSString *)path{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
        CGImageSourceRef gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], (CFDictionaryRef)gifProperties);
        _frames = [NSMutableArray array];
        _frameDuriTimes = [NSMutableArray array];
        _totalTime = [self getFrameTotalTimeWithSource:gif frames:_frames delayTimes:_frameDuriTimes];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andData:(NSData *)data{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                                  forKey:(NSString *)kCGImagePropertyGIFDictionary];
        CGImageSourceRef gif = CGImageSourceCreateWithData((CFDataRef)data, (CFDictionaryRef)gifProperties);;
        _frames = [NSMutableArray array];
        _frameDuriTimes = [NSMutableArray array];
        _totalTime = [self getFrameTotalTimeWithSource:gif frames:_frames delayTimes:_frameDuriTimes];
    }
    return self;
}

- (CGFloat)getFrameTotalTimeWithSource:(CGImageSourceRef)gifSource frames:(NSMutableArray *)frames delayTimes:(NSMutableArray *)delayTimes
{
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    CGFloat totalTime = 0.0;
    for (size_t i = 0; i < frameCount; ++i) {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        if (frame) {
            [frames addObject:(__bridge id)frame];
            CGImageRelease(frame);
            
            // get gif info with each frame
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
            NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime];
            if (delayTime == nil || [delayTime doubleValue] == 0) {
                delayTime = [gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime];
            }
            [delayTimes addObject:delayTime];
            totalTime += [delayTime floatValue];
        }
        
    }
    return totalTime;
}

- (void)start{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    NSUInteger totalCount = _frameDuriTimes.count;
    for (NSUInteger i = 0; i < totalCount; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDuriTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (NSUInteger i = 0; i < totalCount; ++i) {
        [images addObject:[_frames objectAtIndex:i]];
    }
    
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
    animation.repeatCount = HUGE_VALF;
    
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
}
@end
