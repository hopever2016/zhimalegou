//
//  JFTitleIconTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTitleIconTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleThreeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@end
