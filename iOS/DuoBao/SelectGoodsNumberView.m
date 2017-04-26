//
//  SelectGoodsNumberView.m
//  DuoBao
//
//  Created by clove on 11/21/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "SelectGoodsNumberView.h"
#import "IQKeyboardManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NumberInputField.h"

@interface SelectGoodsNumberView()
@property (weak, nonatomic) IBOutlet NumberInputField *inputTextField;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *titleCancelButton;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIView *selectNumberContainerView;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UITextField *goodsNumber;

@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduceLabel;

@property (weak, nonatomic) IBOutlet UIView *shortcutNumbersContainerView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation SelectGoodsNumberView

- (void)dealloc
{
    // reset by default
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:-1];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    XLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NumberInputField *inputField = [[NumberInputField alloc] initWithFrame:_inputTextField.frame];
    [inputField whiteStyle:_inputTextField.frame];
//    NumberInputField *inputField = _inputTextField;
    inputField.coinType = CoinTypeCrowdfunding;
    inputField.cardinalNumber = 10;
    inputField.bettingType = BettingTypeCrowdfunding;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    inputField.min = 1;
    [inputField setDefaultValue:0 limit:10000000];
    [inputField resetWidth:_inputTextField.width * UIAdapteRate];
    inputField.centerX = ScreenWidth/2;
    _inputTextField = inputField;
    [self addSubview:inputField];

    _shortcutNumbersContainerView.width = inputField.width;
    
//    UIColor *grayColor = [UIColor colorWithWhite:0.8157 alpha:1.0f];
    UIColor *darkTextColor = [UIColor colorWithWhite:0.53 alpha:1.0f];
    CGFloat radius = 0.07f;
    
    _titleLable.textColor = [UIColor colorWithWhite:0.5569 alpha:1.0f];
    _subtitleLabel.textColor = [UIColor colorWithWhite:0.37 alpha:1.0f];
    _goodsNumber.textColor = [UIColor defaultRedColor];
    _goodsIntroduceLabel.textColor = _goodsNumber.textColor;
    _resultLabel.textColor = darkTextColor;
    
    
    [_increaseButton addTarget:self action:@selector(purchaseCountButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [_decreaseButton addTarget:self action:@selector(purchaseCountButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [_titleCancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];

    // button from view tags
    UIColor *normalColor = [UIColor colorFromHexString:@"373737"];
    UIColor *disableColor = [UIColor colorFromHexString:@"aeaeae"];
    
    for (int i=100; i<104; i++) {
        UIButton *button = [_shortcutNumbersContainerView viewWithTag:i];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:disableColor forState:UIControlStateDisabled];
        [button setBorder:disableColor width:0.5];
        button.radius = button.height * radius;
        [button addTarget:self action:@selector(recommendedPurchaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *button = _sureButton;
    button.radius = button.height * radius;
    button.backgroundColor = [UIColor defaultRedColor];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"共 "];
    NSAttributedString *colorString = [[NSAttributedString alloc] initWithString:@"10元" attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [attString appendAttributedString:colorString];
    _resultLabel.attributedText = attString;
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:self.height - _goodsNumber.bottom];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setEnable:YES];

//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
//    [self textFieldValueDidChange];
    
    _resultLabel.hidden = YES;
    _goodsIntroduceLabel.hidden = YES;
    _goodsNumber.hidden = YES;
}

- (void)layoutSubviews
{
    float width = 60.0f;
    if (FullScreen.size.width < 374.0f)
    {
        width = 50;
    }
    
    _shortcutNumbersContainerView.width = _inputTextField.width;
    _shortcutNumbersContainerView.centerX = _inputTextField.centerX;
    
    float space = (_shortcutNumbersContainerView.width - width*4) / 3.0;
    
    // button from view tags
    for (int i=100; i<104; i++) {
        UIButton *button = [_shortcutNumbersContainerView viewWithTag:i];
        button.width = width;
        button.x = (button.width + space) * (i-100);
    }
}

- (void)setDetailInfo:(GoodsDetailInfo *)detailInfo
{
    _resultLabel.hidden = NO;
    _goodsIntroduceLabel.hidden = NO;
    _goodsNumber.hidden = NO;

    _detailInfo = detailInfo;
    
    NSArray *recommendedPurchaseOptions = [_detailInfo recommendedPurchaseOptions];
    int maxCount = [_detailInfo maxCount];
    
    if (maxCount == 0) {
        [Tool showPromptContent:@"剩余次数不足，请刷新参与下一期！"];
    }
    
    // button from view tags
    for (int i=100; i<104; i++) {
        
        UIButton *button = [_shortcutNumbersContainerView viewWithTag:i];

        NSString *recommendedPurchaseCountStr = [recommendedPurchaseOptions objectAtIndex:i-100];
        [button setTitle:recommendedPurchaseCountStr forState:UIControlStateNormal];
        
        // 推荐购买数量大于 剩余可购买数量
        int recommendedPurchaseCount = [recommendedPurchaseCountStr intValue];
        if (recommendedPurchaseCount > maxCount) {
            button.enabled = NO;
        } else {
            button.enabled = YES;
        }
    }
    
    _purchaseCount = [_detailInfo defaultPurchaseCount];
    
    int multiple = [_detailInfo.good_single_price intValue];
    _goodsIntroduceLabel.text = [NSString stringWithFormat:@"%d元/人次", multiple];
    
    if (multiple == 1) {
        _goodsIntroduceLabel.hidden = YES;
    }
    
    
    int defaultValue = [_detailInfo defaultPurchaseCount];
    NumberInputField *inputField = _inputTextField;
    inputField.cardinalNumber = 10;
    inputField.exchangeRate = 1;
    inputField.min = 1;
    
    if (inputField.number != defaultValue && inputField.max != maxCount) {
        [inputField setDefaultValue:defaultValue limit:maxCount];
    }

    [self updateInterface];
}

- (void)updateInterface
{
    XLog(@"%@", NSStringFromSelector(_cmd));
    
    NumberInputField *inputField = _inputTextField;

    int multiple = [_detailInfo.good_single_price intValue];
    int amountPurchaseCount = inputField.number * multiple;
    int purchaseCount = inputField.number;
    int maxPurchaseCount = [_detailInfo maxCount];

    _goodsNumber.text = [NSString stringWithFormat:@"%d", purchaseCount];
    
    NSString *amountPurchaseCountString = [NSString stringWithFormat:@"%d元", amountPurchaseCount];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"共 "];
    NSAttributedString *colorString = [[NSAttributedString alloc] initWithString:amountPurchaseCountString attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [attString appendAttributedString:colorString];
    _resultLabel.attributedText = attString;
    
    if (purchaseCount == 1){
        _decreaseButton.enabled = NO;
    }
    
    if (purchaseCount >= maxPurchaseCount) {
        _increaseButton.enabled = NO;
    }
}

- (void)recommendedPurchaseButtonAction:(UIButton *)sender
{
    NSArray *recommendedPurchaseOptions = [_detailInfo recommendedPurchaseOptions];
    NSString *recommendedPurchaseCount = [recommendedPurchaseOptions objectAtIndex:sender.tag-100];
//    _purchaseCount = [recommendedPurchaseCount intValue];
    
    NumberInputField *inputField = _inputTextField;
    int maxPurchaseCount = [_detailInfo maxCount];
    [inputField setDefaultValue:[recommendedPurchaseCount intValue] limit:maxPurchaseCount];

    
    [self updateInterface];
}

- (void)purchaseCountButtonActions:(UIButton *)button
{
    NSInteger tag = button.tag;
    
    // decrease button
    if (tag == 100) {
        _purchaseCount--;
    // increase button
    } else if (tag == 101) {
        _purchaseCount++;
    }
    
    int minPurchaseCount = [_detailInfo minCount];
    int maxPurchaseCount = [_detailInfo maxCount];
    int purchaseCount = _purchaseCount;
    
    purchaseCount = purchaseCount <= minPurchaseCount ? minPurchaseCount : purchaseCount;
    purchaseCount = purchaseCount >= maxPurchaseCount ? maxPurchaseCount : purchaseCount;
    _purchaseCount = purchaseCount;
    
    [self updateInterface];
}

- (void)cancelButtonAction
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelPurchase)]) {
        [_delegate cancelPurchase];
    }
}

- (IBAction)confirmButtonAction:(id)sender {
    
    NumberInputField *inputField = _inputTextField;
    
    int multiple = [_detailInfo.good_single_price intValue];
    int amountPurchaseCount = inputField.number;    // 传递参数不需要乘以倍数 multiple
    int purchaseCount = inputField.number;
    
    int minPurchaseCount = [_detailInfo minCount];
    int maxPurchaseCount = [_detailInfo maxCount];
//    int purchaseCount = _purchaseCount;
    if (purchaseCount > maxPurchaseCount) {
        NSString *str = [NSString stringWithFormat:@"不能大于剩余可购买次数 %d", maxPurchaseCount];
        [Tool showPromptContent:str];
        return;
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectPurchaseNumber:)]) {
        [_delegate didSelectPurchaseNumber:amountPurchaseCount];
    }
}

- (void)dismissAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.bottom += self.height;
    }];
}

#pragma mark - NumberInputFieldDelegate

- (void)numberInputFieldChanged:(NumberInputField *)numberInputField currentValue:(int)money
{
    [self updateInterface];
}


@end
