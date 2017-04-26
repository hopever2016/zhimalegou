//
//  CouponsViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponsListInfo;

@protocol CouponsViewControllerDelegate <NSObject>
@optional
- (void)didSelectCoupon:(CouponsListInfo *)coupon;
@end


@interface CouponsViewController : UIViewController
@property (nonatomic, weak) id delegate;

@property (weak, nonatomic) IBOutlet UIButton *ksyButton;
@property (weak, nonatomic) IBOutlet UIButton *dieButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *ksyLine;

@property (weak, nonatomic) IBOutlet UILabel *dieLine;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic) int conditionMax;    //不满足使用条件的红包不显示

- (IBAction)clickKSYButtonAction:(id)sender;
- (IBAction)clickDieButtonAction:(id)sender;
@end
