//
//  PurchaseGoods.h
//  DuoBao
//
//  Created by clove on 11/28/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetailInfo.h"

@interface PurchaseGoods : NSObject

@property (nonatomic, strong) GoodsDetailInfo *goodsInfo;
@property (nonatomic, weak) UIViewController *viewController;

@end
