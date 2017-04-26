//
//  FQGTableView.h
//  FQG
//
//  Created by gukong on 15/3/12.
//  Copyright (c) 2015年 robyzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FQGTableViewDelegate <UITableViewDelegate>

@optional
- (UIView *)emptyViewForTableView:(UITableView *)tableView;

@end

@interface FQGTableView : UITableView

@end
