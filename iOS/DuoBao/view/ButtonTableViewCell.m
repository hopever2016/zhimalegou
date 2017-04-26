//
//  ButtonTableViewCell.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _btn.backgroundColor = [UIColor defaultRedButtonColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
