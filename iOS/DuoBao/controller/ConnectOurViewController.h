//
//  ConnectOurViewController.h
//  YCSH
//
//  Created by linqsh on 15/12/17.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectOurViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqButtonWidth;
@property (weak, nonatomic) IBOutlet UILabel *kfLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UILabel *phoneWarnLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


- (IBAction)clickPhoneButton:(id)sender;
- (IBAction)clickCommitButton:(id)sender;
@end
