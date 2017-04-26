//
//  BuyResultListTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyResultListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (weak, nonatomic) IBOutlet UILabel *buyNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyNumLabelWidth;

@end
