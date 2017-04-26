//
//  PayResultViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayResultViewControllerDelegate <NSObject>
@optional
- (void)clickBackButton;
@end

@interface PayResultViewController : UIViewController

@property (nonatomic, assign) id<PayResultViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *goodsListArray;

@property (assign, nonatomic) double allMoney;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)clickDuoBaoRecordButtonAction:(id)sender;

- (IBAction)clickJXDBButtonAction:(id)sender;
@end
