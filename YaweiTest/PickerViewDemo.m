//
//  PickerViewDemo.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "PickerViewDemo.h"
@interface PickerViewDemo ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSString *selectFirstComponent;
@end

@implementation PickerViewDemo

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createFakeData];
    self.selectFirstComponent = [[self.dataDict allKeys] firstObject];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
}


#pragma mark - private func
- (void)createFakeData{
    self.dataDict = @{@"河南":@[@"郑州", @"洛阳", @"开封", @"驻马店", @"信阳"], @"陕西":@[@"西安", @"咸阳", @"宝鸡", @"杨凌"], @"湖北":@[@"武汉", @"武昌", @"汉口", @"汉阳", @"孝感"]};
}


#pragma mark - picker view datasource & delegate
//返回列的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){//第一列
        return [[self.dataDict allKeys] count];
    }
    else{//第二列
        return [self.dataDict[self.selectFirstComponent] count];
    }
}

//delegate
//指定行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0){
        return 80;
    }
    else
    {
        return 120;
    }
}
//指定某一列某一行具体文本标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [[self.dataDict allKeys] objectAtIndex:row];
    }
    else{//第二列
        return [self.dataDict[self.selectFirstComponent] objectAtIndex:row];
    }
}
//指定某一列某一行具体的view
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//}
//单击某一指定的列表项时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {//第一列，切换对应的第二列
        self.selectFirstComponent = [[self.dataDict allKeys] objectAtIndex:row];
        [self.pickerView reloadComponent:1];//第二列刷新。
        [self.pickerView selectRow:0 inComponent:1 animated:YES];//设定第二列第一个
    }
    else{
        NSString *firstString = self.selectFirstComponent;
        NSString *secondString = [self.dataDict[self.selectFirstComponent] objectAtIndex:row];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"你选中了：%@省%@市",firstString , secondString]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //        [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
@end
