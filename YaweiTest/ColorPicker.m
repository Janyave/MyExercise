//
//  ColorPicker.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "ColorPicker.h"

@implementation ColorPicker

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectColorPickerColor:)]) {
        [self.delegate selectColorPickerColor:self.backgroundColor];
    }
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = [[UIColor redColor] CGColor];
    
}

@end
