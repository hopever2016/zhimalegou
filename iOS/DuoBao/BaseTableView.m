//
//  LuxyTableView.m
//  Luxy
//
//  Created by gukong on 15/3/12.
//  Copyright (c) 2015年 robyzhou. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()
{
    UIView *emptyContainer;
}
@end

@implementation BaseTableView
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)reloadData {
    [super reloadData];
    [self setupEmptyContainerView];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setupEmptyContainerView];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setupEmptyContainerView];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self setupEmptyContainerView];
}
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super reloadSections:sections withRowAnimation:animation];
    [self setupEmptyContainerView];
}
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super insertSections:sections withRowAnimation:animation];
    [self setupEmptyContainerView];
}
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [super deleteSections:sections withRowAnimation:animation];
    [self setupEmptyContainerView];
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
    [super setTableHeaderView:tableHeaderView];
    [self setupEmptyContainerView];
}

- (void)setupEmptyContainerView {
    id<BaseTableViewDelegate> del = (id<BaseTableViewDelegate>)self.delegate;
    if ([del respondsToSelector:@selector(emptyViewForTableView:)]) {
        [emptyContainer removeFromSuperview];
        emptyContainer = [del emptyViewForTableView:self];
        if (emptyContainer) {
            [emptyContainer setFrame:CGRectMake(0, self.tableHeaderView.height, self.width, emptyContainer.height)];
            [self addSubview:emptyContainer];
        }
    }
}

@end
