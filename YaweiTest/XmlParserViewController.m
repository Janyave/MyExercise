//
//  XmlParserViewController.m
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/25.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "XmlParserViewController.h"

@interface XmlParserViewController ()

@end

@implementation XmlParserViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _dataArr = [[NSMutableArray alloc] initWithObjects:@"NSXMLParser", @"libxml2", @"TBXMLParser", nil];
    
}

#pragma mark - tableview datasoure && delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XMLCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XMLCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        
    }else if(indexPath.row == 2){
        
    }
}
@end
