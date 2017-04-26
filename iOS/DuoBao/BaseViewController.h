//
//  BaseViewController.h
//  LLLM
//
//  Created by clove on 9/2/15.
//  Copyright (c) 2015 clove. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface BaseViewController : UIViewController


- (void)setRightBarButtonItem:(NSString *)title;
- (void)setLeftBarButtonItemArrow;
- (void)setLeftBarButtonItem:(NSString *)title;
- (void)setRightBarButtonItemMore;
- (void)setRightBarButtonItemEdit;


// MBHUD
- (void)hiddenWithTitle:(NSString *)title;
- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail;
- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail afterDelay:(NSTimeInterval)time;
- (void)hiddenWithCheckMark:(NSString *)title;
- (MBProgressHUD *)showLoading;
- (MBProgressHUD *)showLoadingWithTitle:(NSString *)title;

@end
