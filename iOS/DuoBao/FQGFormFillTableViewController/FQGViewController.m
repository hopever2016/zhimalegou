//
//  BaseViewController.m
//  LLLM
//
//  Created by clove on 9/2/15.
//  Copyright (c) 2015 clove. All rights reserved.
//

#import "FQGViewController.h"
#import "MBProgressHUD.h"

@interface FQGViewController ()

@end

@implementation FQGViewController

- (void)dealloc
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)setLeftBarButtonItem:(NSString *)title
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)setRightBarButtonItemMore
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_icon_more"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(rightBarButtonItemAction:)];
    
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)setRightBarButtonItemEdit
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pdi_bottom_edit"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(rightBarButtonItemAction:)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pdi_bottom_edit_pressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)setLeftBarButtonItemArrow
{
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil style:UIButtonTypeCustom target:self action:@selector(popNavigationItemAnimated:)];
    self.navigationItem.backBarButtonItem = item;
    
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-arrow-left-gray"]
    //                                                                   style:UIBarButtonItemStyleBordered
    //                                                                  target:self
    //                                                                  action:@selector(leftBarButtonItemAction:)];
    //
    //    self.navigationItem.leftBarButtonItem = backButton;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)leftBarButtonItemAction:(id)sender
{
    
}

- (void)rightBarButtonItemAction:(id)sender
{
    
}

- (void)hiddenWithTitle:(NSString *)title
{
    [self hiddenWithTitle:title detail:nil];
}

- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail
{
    [self hiddenWithTitle:title detail:detail afterDelay:2.0];
}

- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail afterDelay:(NSTimeInterval)time
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    
    HUD.labelText = title;
    HUD.detailsLabelText = detail;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:time];
}

- (void)hiddenWithCheckMark:(NSString *)title
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = title;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

- (MBProgressHUD *)showLoading
{
    return [self showLoadingWithTitle:@"加载"];
}

- (MBProgressHUD *)showLoadingWithTitle:(NSString *)title
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = title;
    [HUD show:YES];
    return HUD;
}


@end
