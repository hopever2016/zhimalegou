//
//  PaySelectedController.h
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaySelectedData.h"

@interface PaySelectedController : UITableViewController


- (instancetype)initWithPurchaseGoods;

- (CGFloat)height;

- (void)payMoney:(int)moneyByYuan
 goods_fight_ids:(NSString *)goods_fight_ids
  goods_buy_nums:(NSString *)goods_buy_nums
      completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)rechargeMoney:(int)moneyByYuan
           completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion;


- (PaymentType)selectedPaymentType;

// 最低充值金额。 微信支付宝不支持一元夺宝，为了规避微信支付宝检查，不得不禁止用户充值一块钱购买订单
// @"allow" 表示允许购买
- (NSString *)paymentPermission:(int)startPrice;


- (void)payWithGoods:(NSString *)goods_fight_ids
           orderType:(NSString *)order_type            // 订单/充值/欢乐豆
               count:(int)goodsCount
      thricePurchase:(NSArray *)thricePurchaseArray
              coupon:(NSString *)ticket_send_id
    costedThriceCoin:(int)costedThriceCoin
          totalPrice:(int)totalPrice
            cutPrice:(int)cutPrice
     payCrowdfunding:(int)payCrowdfunding
          completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)rechargeThriceCoin:(int)payCNY
                completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)rechargeCrowdfundingCoin:(int)payCNY
                      completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

@end
