//
//  FQGViewController.h
//  BoyacxClient
//
//  Created by clove on 7/5/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface FQGViewController : UIViewController

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
