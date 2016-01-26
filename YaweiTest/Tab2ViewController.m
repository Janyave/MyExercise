//
//  Tab2ViewController.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "Tab2ViewController.h"

@interface Tab2ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *contentButton;

@end

@implementation Tab2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(id)sender {
    
    [self.contentButton startWithTime:5 title:@"获取验证码" countDownTile:@"s" mainColor:[UIColor greenColor] countColor:[UIColor lightGrayColor]];
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
