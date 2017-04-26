//
//  BaseTableViewController.h
//  testxx
//
//  Created by Tulip on 5/22/14.
//  Copyright (c) 2014 Tulip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQGViewController.h"
#import "FQGTableView.h"

@class FQGPickerView;

@interface FQGTableViewController : FQGViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) FQGTableView *tableView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *footerViewButton;
@property (nonatomic, strong) UIButton *footerViewButtonLeft;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *strongSearchControler;

//@property (strong, nonatomic) BottomLoadingView *bottomLoadingView;
@property (nonatomic) BOOL enableTopRefreshControl;
//@property (nonatomic) BOOL enableBottomRefreshControl;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;
- (instancetype)initWithoutFooterButtons;
- (instancetype)initWithoutNextButton;

- (void)startAnimatingTop;
- (void)stopAnimatingTop;
- (void)startAnimatingBottom;
- (void)stopAnimatingBottom;
- (void)setBottomRefreshControlExtinct:(BOOL)extinct;
- (void)setTopRefreshControlExtinct:(BOOL)extinct;

- (void)addFooterNextButton:(NSString *)title;
- (void)addFooterButton:(NSString *)title;
- (void)addFooterButton:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
- (void)setFooterViewBottom;
- (void)setFooterViewInTableFooterView;
- (void)footerButtonAction:(id)sender;
- (void)footerButtonLeftAction:(id)sender;
- (void)setEmptyFooterView;
- (void)setfooterSeparationLine;
- (void)setfooterWithoutSeparationLine;
- (UIView *)footerSeparationLine;

- (UIView *)sectionFooterViewWithTitle:(NSString *)title;

- (void)supportSearchBar;
- (void)clearSearchBarSeparateLineAfterViewDidLoad;
- (void)searchBarInNavigationBar;

- (void)showPickerView:(FQGPickerView *)pickerView;
- (void)hidePickerView;

@end
