//
//  ColorPicker.h
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColorPickerDelegate <NSObject>

- (void)selectColorPickerColor:(UIColor *)color;
@end
@interface ColorPicker : UIView
@property (nonatomic, weak)id <ColorPickerDelegate>delegate;
@end
