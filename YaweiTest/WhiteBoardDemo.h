//
//  WhiteBoardDemo.h
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPicker.h"
#import "TouchDrawView.h"

@interface WhiteBoardDemo : UIViewController<ColorPickerDelegate>
@property (strong, nonatomic) IBOutlet ColorPicker *color1;
@property (strong, nonatomic) IBOutlet ColorPicker *color2;
@property (strong, nonatomic) IBOutlet ColorPicker *color3;
@property (strong, nonatomic) IBOutlet ColorPicker *color4;
@property (strong, nonatomic) IBOutlet ColorPicker *color5;
@property (strong, nonatomic) IBOutlet ColorPicker *color6;
@property (strong, nonatomic) IBOutlet ColorPicker *color7;
@property (strong, nonatomic) IBOutlet ColorPicker *color8;
@property (strong, nonatomic) IBOutlet TouchDrawView *touchView;

@end
