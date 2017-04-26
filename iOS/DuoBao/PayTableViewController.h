//
//  PayTableViewController.h
//  DuoBao
//
//  Created by clove on 4/9/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PayTableViewController : UITableViewController
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) NSString *is_shop_cart;

+ (PayTableViewController *)createWithData:(NSDictionary *)data;

@end
