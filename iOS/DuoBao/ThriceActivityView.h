//
//  ThriceActivityView.h
//  DuoBao
//
//  Created by clove on 4/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"

@interface ThriceActivityView : UIView
@property (weak, nonatomic) IBOutlet UIView *goodsContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIView *progressContainerView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *amountLable;
@property (weak, nonatomic) IBOutlet UILabel *remainderLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookupRuleButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *ruleTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)reloadWithData:(NSDictionary *)data;
- (void)UIAdapte;

@end
