//
//  ZJRecordListCardTableViewCell.m
//  DuoBao
//
//  Created by clove on 11/1/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "ZJRecordListCardTableViewCell.h"

@implementation ZJRecordListCardTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)reuseIdentifier
{
    return NSStringFromClass(self.class);
}


- (void)setLogisticalHidden:(BOOL)yesNo
{
    
}

@end
