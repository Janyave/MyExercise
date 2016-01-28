//
//  3DTouchDemo.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/1/28.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "3DTouchDemo.h"
#import "OneCell.h"
#import "TwoCell.h"
#import "PeekViewController.h"
#import "PopViewController.h"

@interface _DTouchDemo ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation _DTouchDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createFakeData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self check3DTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private func
- (void)createFakeData{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 100; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"Cell***********%ld", i]];
    }
    _dataArr = tempArr;
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.dataArr count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 1) {
        return 40;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TwoCell"];
        if (cell == nil) {
            cell = [OneCell cellFromNib];
        }
        [cell.textLabel setText:[self.dataArr objectAtIndex:indexPath.row]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"OneCell"];
        if (cell == nil) {
            cell = [TwoCell cellFromNib];
        }
        [cell.textLabel setText:[self.dataArr objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PopViewController *controller = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    controller.data = [self.dataArr objectAtIndex:indexPath.row];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 3DTouch

- (void)check3DTouch{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
        //        self.longPress.enabled = NO;
    }else{
        //        self.longPress.enabled = YES;
    }
}

//UIViewControllerForPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    PeekViewController *controller = [[PeekViewController alloc] initWithNibName:@"PeekViewController" bundle:nil];
    controller.data = [self.dataArr objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    previewingContext.sourceRect = cell.frame;//提醒3dtouch点击的区域
    
    return controller;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}


//- (void)showSecondaryDetailViewController{
//    
//}

@end
