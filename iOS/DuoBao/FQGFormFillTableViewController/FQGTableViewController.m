//
//  BaseTableViewController.m
//  testxx
//
//  Created by Tulip on 5/22/14.
//  Copyright (c) 2014 Tulip. All rights reserved.
//

#import "FQGTableViewController.h"
#import "FQGPickerView.h"

#define UIColorStandardRed  [UIColor defaultRedColor]

@interface FQGTableViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>
{
    BOOL flag;
}
@property (nonatomic) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) FQGPickerView *pickerView;

@property (nonatomic) BOOL shouldEnableNextButton;
@property (nonatomic) BOOL shouldEnableBottomButtons;

@end

@implementation FQGTableViewController

- (void)dealloc
{
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style
{
    self = [super init];
    
    if (self) {
        _shouldEnableBottomButtons = YES;
        _shouldEnableNextButton = YES;
        _tableViewStyle = style;
    }
    
    return self;
}

- (instancetype)initWithoutNextButton
{
    self = [super init];
    
    if (self) {
        _shouldEnableNextButton = NO;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (instancetype)initWithoutFooterButtons
{
    self = [super init];
    
    if (self) {
        _shouldEnableBottomButtons = NO;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.tableView = [[FQGTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
    
    if (_shouldEnableBottomButtons) {
        [self initFooterView];
    }
    
    
    //    UINavigationController *nav1 = self.navigationController;
    //    UINavigationController *nav2 = self.tabBarController.navigationController;
    //    if ((nav1.navigationBarHidden == NO && nav1 != nil) || (nav2.navigationBarHidden == NO && nav2 != nil)) {
    //        self.tableView.top = 64;
    //        self.tableView.height -= self.tableView.top;
    //    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.userInteractionEnabled = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView      // called when scrolling animation finished. may be called immediately if already at top
{
//    // 滑动触及底部，开始刷新
//    if (_bottomLoadingView.isAnimating == NO) {
//        if (fabs((self.tableView.contentOffset.y+ self.tableView.frame.size.height) - self.tableView.contentSize.height) < 0.5){
//            [_bottomLoadingView startAnimating];
//        }
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //flag = self.refreshControl.refreshing;
    [self hidePickerView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    if (self.refreshControl.refreshing == YES && flag == NO){
    //        if (self.tableView.contentOffset.y < 0){
    //            [self startAnimatingTop];
    //        }
    //    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 24;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
        {
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

#pragma mark - KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqual:@"refreshing"]) {
//
//
//        [self stopAnimatingTop];
//    }
//}

#pragma mark -

- (UIRefreshControl *)createRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    return refreshControl;
}

#pragma mark - Public Method
- (void)startAnimatingTop
{
    NSLog(@"sdfs");
}

- (void)stopAnimatingTop
{
    //[self.refreshControl endRefreshing];
}

- (void)setTopRefreshControlExtinct:(BOOL)extinct
{
    if (extinct){
        //self.refreshControl = nil;
    }else{
        //self.refreshControl = [self createRefreshControl];
    }
}

- (void)setEnableTopRefreshControl:(BOOL)enabled
{
    [self setTopRefreshControlExtinct:!enabled];
}

#pragma mark -

- (void)initFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    self.footerView = view;
}

- (void)addFooterNextButton:(NSString *)title
{
    if (_shouldEnableNextButton == NO) {
        return;
    }
    
    UIView *view = _footerView;
    
    _footerView.height = 30 + 40 + 30;
    float top = 30;
    float buttonWidth = view.width - MARGIN*2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = UIColorStandardRed;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.height = 40;
    button.width = buttonWidth;
    button.top = top;
    button.left = MARGIN;
    
    button.layer.cornerRadius = button.height*0.15;
    [view addSubview:button];
    
    _footerViewButton = button;
    
    [self setFooterViewInTableFooterView];
}

- (void)addFooterButton:(NSString *)title
{
    UIView *view = _footerView;

    _footerView.height = 30 + 40 + 30;
    float top = 30;
    float buttonWidth = view.width - MARGIN*2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = UIColorStandardRed;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.height = 40;
    button.width = buttonWidth;
    button.top = top;
    button.left = MARGIN;

    button.layer.cornerRadius = button.height*0.15;
    [view addSubview:button];
    
    _footerViewButton = button;
    
    [self setFooterViewInTableFooterView];
}

- (void)addLeftFooterButton:(NSString *)title
{
    UIView *view = _footerView;
    
    _footerView.height = 30 + 40 + 30;
    float top = 30;
    float buttonWidth = view.width - MARGIN*2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = UIColorStandardRed;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.height = 40;
    button.width = buttonWidth;
    button.top = top;
    button.left = MARGIN;
    
    button.layer.cornerRadius = button.height*0.15;
    [view addSubview:button];
    
    _footerViewButton = button;
    
    [self setFooterViewInTableFooterView];
}

- (void)addFooterButton:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    if (_shouldEnableNextButton == NO) {
        [self addLeftFooterButton:leftTitle];
        return;
    }
    
    UIView *view = _footerView;

    _footerView.height = 30 + 40 + 30;
    float top = 30;
    float buttonMargin = 25;
    float buttonWidth = (view.width - MARGIN*2 - buttonMargin) / 2;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = UIColorStandardRed;
    [button setTitle:leftTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    button.height = 40;
    button.width = buttonWidth;
    button.top = top;
    button.left = MARGIN;
    button.layer.cornerRadius = button.height*0.15;
    [view addSubview:button];
    
    _footerViewButtonLeft = button;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor whiteColor];;
    [button setTitle:rightTitle forState:UIControlStateNormal];
    [button setTitleColor:UIColorStandardRed forState:UIControlStateNormal];
    [button addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = _footerViewButtonLeft.frame;
    button.left = _footerViewButtonLeft.right + buttonMargin;
    button.layer.cornerRadius = button.height*0.15;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = UIColorStandardRed.CGColor;
    button.layer.borderWidth = 1.0;
    [view addSubview:button];
    
    _footerViewButton = button;
    
    [self setFooterViewInTableFooterView];
}

- (UIView *)sectionFooterViewWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.width = self.tableView.width;
    label.height = 30;
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont systemFontOfSize:13];
    
    UIView *view = [[UIView alloc] initWithFrame:label.bounds];
    [view addSubview:label];
    return view;
}

- (void)setFooterViewBottom
{
    _footerView.top = self.tableView.bounds.size.height - _footerView.height - 64 - MARGIN;
    [self.tableView addSubview:_footerView];
}

- (void)setFooterViewInTableFooterView
{
    self.tableView.tableFooterView = _footerView;
}


- (void)footerButtonAction:(id)sender
{
    
}

- (void)footerButtonLeftAction:(id)sender
{
    
}

- (void)setEmptyFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
    self.tableView.tableFooterView = view;
}

- (void)setfooterSeparationLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
   // view.backgroundColor = [UIColor separatorColor];
    self.tableView.tableFooterView = view;
}

- (void)setfooterWithoutSeparationLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
}

- (UIView *)footerSeparationLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
   // view.backgroundColor = [UIColor separatorColor];
    return view;
}


#pragma mark -

- (void)supportSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.bounds];
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    searchBar.delegate = self;
    [searchBar sizeToFit];
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    
    
    self.tableView.tableHeaderView = searchBar;
    self.strongSearchControler = searchDisplayController;
    self.searchBar = searchBar;    
}

- (void)clearSearchBarSeparateLineAfterViewDidLoad
{
    CGRect rect = self.searchBar.frame;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-1,rect.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.tag = 102;
    [self.searchBar addSubview:lineView];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,rect.size.width, 1)];
    lineView.backgroundColor = self.searchBar.barTintColor;
    lineView.tag = 101;
    [self.searchBar addSubview:lineView];
}

- (void)searchBarInNavigationBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.showsCancelButton = YES;
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *barWrapper = [[UIView alloc] initWithFrame:searchBar.bounds];
    [barWrapper addSubview:searchBar];
    self.navigationItem.titleView = barWrapper;
    
    self.searchBar = searchBar;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                    // called when keyboard search button pressed
{
    
}

#pragma mark - PickerView

- (void)showPickerView:(FQGPickerView *)pickerView
{
    [_pickerView removeFromSuperview];
    
    pickerView.top = self.tableView.height;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        pickerView.top = self.tableView.height - pickerView.height;
    } completion:nil];
    
    _pickerView = pickerView;
    
    [self.tableView addSubview:pickerView];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _pickerView.top = self.tableView.height;
    } completion:^(BOOL finished) {
        [_pickerView removeFromSuperview];
    }];
}


@end
