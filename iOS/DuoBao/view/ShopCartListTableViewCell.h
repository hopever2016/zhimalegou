//
//  ShopCartListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextField *joinNumText;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonWidth;



@end
