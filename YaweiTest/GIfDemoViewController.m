//
//  GIfDemoViewController.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/6.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "GIfDemoViewController.h"
#import "GifView.h"
#import "UIImage+GIF.h"

@interface GIfDemoViewController ()

@end

@implementation GIfDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self useCustomGifView];
    [self useImageExtension];
    [self useWebView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)useCustomGifView{
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 150);
    
    GifView *gifView = [[GifView alloc] initWithFrame:frame andFilePath:[NSString stringWithFormat:@"%@/testGif.jpg",[[NSBundle mainBundle] bundlePath]]];
    [self.view addSubview:gifView];
    [gifView start];
}
- (void)useImageExtension{
    CGRect frame = CGRectMake(0, 214, [UIScreen mainScreen].bounds.size.width, 150);
    NSData *gifData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/testGif.jpg",[[NSBundle mainBundle] bundlePath]]];
    UIImage *image = [UIImage animatedImageWithGifData:gifData];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:frame];
    gifImageView.image = image;
    [self.view addSubview:gifImageView];
    
}

- (void)useWebView{
    CGRect rect =CGRectMake(0,364,[UIScreen mainScreen].bounds.size.width, 150);
//    rect.size = [UIImageimageNamed:@"jiafei.gif"].size;
    
    UIWebView *gifWebView = [[UIWebView alloc]initWithFrame:rect];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testGif"ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:path];

    [gifWebView loadData:imgData MIMEType:@"image/gif" textEncodingName:@"utf-8" baseURL:[NSURL fileURLWithPath:path]];
    gifWebView.userInteractionEnabled =NO;//用不不可交互
    gifWebView.backgroundColor = [UIColor clearColor];
    gifWebView.opaque =NO;
    [self.view addSubview:gifWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
