//
//  TwoCell.m
//  3DTouchTest
//
//  Created by hzzhanyawei on 16/1/27.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell

+ (id)cellFromNib{
    return [[[NSBundle mainBundle]loadNibNamed:@"TwoCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
