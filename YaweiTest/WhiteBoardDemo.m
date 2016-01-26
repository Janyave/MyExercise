//
//  WhiteBoardDemo.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "WhiteBoardDemo.h"

@interface WhiteBoardDemo ()

@end

@implementation WhiteBoardDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.color1.delegate = self;
    self.color2.delegate = self;
    self.color3.delegate = self;
    self.color4.delegate = self;
    self.color5.delegate = self;
    self.color6.delegate = self;
    self.color7.delegate = self;
    self.color8.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - colorPicker delegate
- (void)selectColorPickerColor:(UIColor *)color
{
    self.touchView.drawColor = color;
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
