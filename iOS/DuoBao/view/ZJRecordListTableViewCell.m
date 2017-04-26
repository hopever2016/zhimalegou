//
//  ZJRecordListTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZJRecordListTableViewCell.h"

@implementation ZJRecordListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonAction:(id)sender {
    
    NSString *text = _titleLabel.text;
    
    NSDictionary *data = @{@"status": @"待发货",
                           @"good_period": _periodStr?:@"",
                           @"good_name": _goodsNameStr?:@""};
    
    [Tool showWinLottery:data];
}

@end
