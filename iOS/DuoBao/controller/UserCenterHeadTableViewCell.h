//
//  UserCenterHeadTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poinrLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonCenterX;
@property (weak, nonatomic) IBOutlet UIButton *czButton;

@property (weak, nonatomic) IBOutlet UIControl *noLoginControl;
@property (weak, nonatomic) IBOutlet UIImageView *noLoginImage;






@end
