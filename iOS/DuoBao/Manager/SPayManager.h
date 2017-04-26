//
//  SPayManager.h
//  DuoBao
//
//  Created by clove on 3/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPayManager : NSObject <UIApplicationDelegate>

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)payWithOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion;
@end
