//
//  ShopCartInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ShopCartInfo.h"

@implementation ShopCartInfo

- (int)amountBuy
{
    int number = [_goods_buy_num intValue];
    int amount = number * _good_single_price;
    
    return amount;
}

@end
