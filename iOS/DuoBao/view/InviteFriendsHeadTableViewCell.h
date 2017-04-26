//
//  InviteFriendsHeadTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsHeadTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *allFriendsNum;
@property (weak, nonatomic) IBOutlet UILabel *oneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *warn1Label;
@property (weak, nonatomic) IBOutlet UILabel *warn2Label;
@property (weak, nonatomic) IBOutlet UILabel *warn3Label;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@end
