//
//  TypeDefine.h
//  DuoBao
//
//  Created by clove on 4/16/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#ifndef TypeDefine_h
#define TypeDefine_h

typedef enum : NSUInteger {
    PrizeTypeNone = 1 << 0,
    PrizeTypeLucky = 1 << 1,
    PrizeTypeAccept = (1 << 2) | PrizeTypeLucky,
} PrizeType;

typedef enum : NSUInteger {
    CoinTypeCrowdfunding,
    CoinTypeThrice,
} CoinType;

typedef enum : NSUInteger {
    BettingTypeCrowdfunding = 1 << 0,
    BettingTypeThrice = 1 << 1,
    BettingTypeThrice0 = 1 << 2 | BettingTypeThrice,
    BettingTypeThrice147 = 1 << 3 | BettingTypeThrice,
    BettingTypeThrice258 = 1 << 4 | BettingTypeThrice,
    BettingTypeThrice369 = 1 << 5 | BettingTypeThrice,
} BettingType;



#endif /* TypeDefine_h */
