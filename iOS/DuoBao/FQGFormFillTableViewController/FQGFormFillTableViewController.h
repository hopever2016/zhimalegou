//
//  FQGFormFillTableViewController.h
//  BoyacxClient
//
//  Created by clove on 7/13/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import "FQGTableViewController.h"
#import "FQGCellModel.h"

@class CustomerInfomationModel;

@interface FQGFormFillTableViewController : FQGTableViewController

@property (nonatomic, strong) NSMutableArray<NSArray *> *modelArray;
@property (nonatomic, strong) CustomerInfomationModel *customerInfomationModel;

@end
