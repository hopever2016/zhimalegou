//
//  FriendsInfoTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hyIdStr;
@property (weak, nonatomic) IBOutlet UILabel *dbrcLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
