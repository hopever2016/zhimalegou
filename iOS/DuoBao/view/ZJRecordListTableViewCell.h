//
//  ZJRecordListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRecordListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderStatue;

@property (weak, nonatomic) IBOutlet UILabel *wlgsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wlgsLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *wlgsValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wlgsValueLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *wlddLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wlddHeight;
@property (weak, nonatomic) IBOutlet UILabel *wlddValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wlddValueHeight;

@property (weak, nonatomic) IBOutlet UILabel *xyhmLabel;

@property (weak, nonatomic) IBOutlet UILabel *allNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sdButton;

@property (weak, nonatomic) IBOutlet UIButton *congratulationButton;
@property (nonatomic, copy) NSString *periodStr;
@property (nonatomic, copy) NSString *goodsNameStr;

@end
