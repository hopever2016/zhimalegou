//
//  CZViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UITextField *sixTextFiled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureButtonTopSpace;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paySelectHeight;   // 购买方式选择界面高度
@property (weak, nonatomic) IBOutlet UIView *moneyShortcutContainer;

@property (weak, nonatomic) IBOutlet UIButton *alipayImage;
@property (weak, nonatomic) IBOutlet UIButton *weiXinImage;
@property (weak, nonatomic) IBOutlet UIControl *weixinView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weixinConstraint;

- (IBAction)clickALiPayButtonAction:(id)sender;
- (IBAction)clickWeiXinButtonAction:(id)sender;
- (IBAction)clickMoneyButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;
@end
