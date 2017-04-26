//
//  PaySelectedData.m
//  DuoBao
//
//  Created by clove on 3/12/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySelectedData.h"

@implementation PaySelectedData

- (PaymentType)paymentType
{
    PaymentType type = PaymentTypeNone;
    
    NSString *str = _pay_channer_code;
    if ([str containsString:@"mustpay"]) {
        type = PaymentTypeMustpay;
    } else if ([str containsString:@"zhongxing"]) {
        type = PaymentTypeSpay;
    }
    
    return type;
}

- (NSString *)title
{
    return _pay_channel_name;
}

- (NSString *)imagePath
{
    return _pay_img;
}

- (NSString *)paymentPermissionAtStartPrice:(int)startPrice
{
    NSString *str = @"allow";
    
    int limitPrice = [_pay_limit intValue];
    if (startPrice < limitPrice && limitPrice != 0) {
        str = [NSString stringWithFormat:@"最低充值金额为%d，请见谅～", limitPrice];
    }
    
    return str;
}

- (UIImage *)image
{
    UIImage *image = nil;
    PaymentType type = [self paymentType];
    
    if (type == PaymentTypeMustpay) {
        image = [UIImage imageNamed:@"icon_alipay"];
    }
    
    if (type == PaymentTypeSpay) {
        image = [UIImage imageNamed:@"icon_wechat"];
    }
    
    return image;
}

@end
