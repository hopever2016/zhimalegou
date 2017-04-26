//
//  ExchangeCouponsViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeCouponsViewControllerDelegate <NSObject>
@optional
- (void)exchangeCouponsSuccess;
@end

@interface ExchangeCouponsViewController : UIViewController

@property (nonatomic, assign) id<ExchangeCouponsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextField *couponsText;

- (IBAction)clickSureButtonAction:(id)sender;

@end
