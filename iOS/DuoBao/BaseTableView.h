//
//  LuxyTableView.h
//  Luxy
//
//  Created by gukong on 15/3/12.
//  Copyright (c) 2015年 robyzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate <UITableViewDelegate>

@optional
- (UIView *)emptyViewForTableView:(UITableView *)tableView;

@end

@interface BaseTableView : UITableView

@end
