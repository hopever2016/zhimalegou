//
//  CouponsListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponsListInfo;

@interface CouponsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIView *thriceBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *thriceCouponCountLabel;


- (void)relaodWithData:(CouponsListInfo *)data;

@end
