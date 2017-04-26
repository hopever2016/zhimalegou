//
//  ZengQianListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/13.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZengQianListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@end
