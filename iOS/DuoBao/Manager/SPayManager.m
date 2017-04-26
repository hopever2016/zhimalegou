//
//  SPayManager.m
//  DuoBao
//
//  Created by clove on 3/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "SPayManager.h"
#import "SPayClient.h"

@interface SPayManager()

@property (nonatomic, strong) void (^completionBlock)(BOOL result, NSString *description,  NSDictionary *dict);
@property (nonatomic) int money;
@property (nonatomic, strong) UIViewController *payInViewController;

@end

@implementation SPayManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _payInViewController = viewController;
    }
    
    return self;
}

- (void)payMoney:(int)money
         orderNo:(NSString *)orderNo
      completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self payWithOrderNo:orderNo
              order_type:@"订单"
                   money:money
              completion:completion];
}

- (void)rechargeCrowdfundingCoin:(int)money
                         orderNo:(NSString *)orderNo
                      completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    [self payWithOrderNo:orderNo
              order_type:@"充值"
                   money:money
              completion:completion];
}

- (void)rechargeThriceCoin:(int)money
                   orderNo:(NSString *)orderNo
                completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    [self payWithOrderNo:orderNo
              order_type:@"欢乐豆"
                   money:money
              completion:completion];
}

- (void)payWithOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    __block typeof(self) wself = self;
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getSpayInfoWithOrderNo:orderNo
                         total_fee:allPriceStr
                  spbill_create_ip:@"127.0.0.1"
                              body:order_type
                            detail:@"充值支付"
                           success:^(NSDictionary *resultDic){
                               
                               NSString *description = [resultDic objectForKey:@"desc"];
                               NSString *status = [resultDic objectForKey:@"status"];
                               NSDictionary *data = [resultDic objectForKey:@"data"];
                               NSString *transaction_id = [data objectForKey:@"token_id"];
                               BOOL result = [status isEqualToString:@"0"];
                               
                               if (result) {
                                   [wself spayOrderNo:transaction_id priceStr:allPriceStr];
                               }
                               
                           }fail:^(NSString * description){
                               completion(NO, description, nil);
                           }];
}

- (void)spayOrderNo:(NSString *)orderNo priceStr:(NSString *)priceStr
{
    NSNumber *amount = [NSNumber numberWithInt:[priceStr intValue]];

    [[SPayClient sharedInstance] pay:_payInViewController
                              amount:amount
                   spayTokenIDString:orderNo
                   payServicesString:@"pay.weixin.app"
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                          if (_completionBlock) {
                                              _completionBlock(YES, @"支付成功", nil);
                                          }
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      
                                      if (_completionBlock) {
                                          _completionBlock(NO, @"支付失败", nil);
                                      }

                                      NSLog(@"支付失败，错误号:%d = %@",payStateModel.payState, payStateModel.messageString);
                                  }
                              }];
}

@end
