//
//  XmlParserViewController.h
//  YaweiTest
//
//  Created by hzzhanyawei on 16/4/25.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XmlParserViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *dataArr;

@end
