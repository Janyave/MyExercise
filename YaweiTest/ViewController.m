//
//  ViewController.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewDemo.h"
#import "WhiteBoardDemo.h"
#import "CuteViewController.h"
#import "3DTouchDemo.h"
#import "PersistentDemo.h"
#import "VideoPlayerDemoViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemsArray;
//@property (nonatomic, copy) void(^Blcok)();

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"各种练习demo"];
    
    [self initItems];
    [self initTableView];
    
//    [self testBlock];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//- (void)testBlock{//对文件-fno-objc-arc开启MRC
//    int a = 10;
//    void (^block)() = ^{ NSLog(@"I am block %d", a);};//如果不引用外部变量a,ARC和MRC情况下都是__NSGlobalBlock__，引用a时MRC情况下为__NSStackBlock__，ARC情况下为__NSMallocBlock__
//    block();
//    
//    self.Blcok = ^{ NSLog(@"I am block %d", a);};//如果不引用外部变量a,ARC和MRC情况下都是__NSGlobalBlock__，引用a时MRC情况下与OC对象一样为__NSMallocBlock__，ARC情况下为__NSMallocBlock__
//    self.Blcok();
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private func
- (void)initItems{
    self.itemsArray = [[NSMutableArray alloc] init];
    [self.itemsArray addObject:@"PickerViewDemo"];
    [self.itemsArray addObject:@"WhiteBoardDemo"];
    [self.itemsArray addObject:@"MyCuteView"];
    [self.itemsArray addObject:@"3DTouchDemo"];
    [self.itemsArray addObject:@"PersistentDemo"];
    [self.itemsArray addObject:@"VideoPlayerDemo"];
}
- (void)initTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DemoCell"];
    }
    [cell.textLabel setText:[self.itemsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//pickerview demo
        UIViewController *controller = [[PickerViewDemo alloc] initWithNibName:@"PickerViewDemo" bundle:nil];
        [controller.navigationItem setTitle:@"PickerViewDemo"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.row == 1){//whiteBoard demo
        UIViewController *controller = [[WhiteBoardDemo alloc] initWithNibName:@"WhiteBoardDemo" bundle:nil];
        [controller.navigationItem setTitle:@"WhiteBoardDemo"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.row == 2){//cute view
        UIViewController *controller = [[CuteViewController alloc] initWithNibName:@"CuteViewController" bundle:nil];
        [controller.navigationItem setTitle:@"MyCuteView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.row == 3){//3D Touch demo
        UIViewController *controller = [[_DTouchDemo alloc] initWithNibName:@"3DTouchDemo" bundle:nil];
        [controller.navigationItem setTitle:@"3DTouchDemo"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.row == 4){//persistent demo
        UIViewController *controller = [[PersistentDemo alloc] initWithNibName:@"PersistentDemo" bundle:nil];
        [controller.navigationItem setTitle:@"PersistentDemo"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(indexPath.row == 5){
        UIViewController *contorller = [[VideoPlayerDemoViewController alloc] initWithNibName:@"VideoPlayerDemoViewController" bundle:nil];
        [contorller.navigationItem setTitle:@"VideoPlayerDemo"];
        [self.navigationController pushViewController:contorller animated:YES];
    }
    
}

@end
