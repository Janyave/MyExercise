//
//  TouchDrawView.h
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/24.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"

@interface TouchDrawView : UIView
@property (nonatomic, strong) Line *currentLine;
@property (nonatomic, strong) NSMutableArray *linesCompleted;
@property (nonatomic, strong) UIColor *drawColor;
@end
