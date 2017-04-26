//
//  BaseNavigationController.m
//  DuoBao
//
//  Created by clove on 11/30/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Color.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+ (void)load
{
    [super load];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor defaultRedColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    UIImage *image = [UIImage imageFromContextWithColor:[UIColor colorWithRed:0.7608 green:0.0 blue:0.0392 alpha:1.0f] size:CGSizeMake(3, 3)];
//    [[UINavigationBar appearance]  setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.topViewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated // Returns the popped controller.
{
    self.viewControllers.firstObject.hidesBottomBarWhenPushed = NO;

    UIViewController *vc = [super popViewControllerAnimated:animated];
    vc.hidesBottomBarWhenPushed = NO;
    
    return vc;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
{
    self.viewControllers.firstObject.hidesBottomBarWhenPushed = NO;
    
    NSArray *array = [super popToRootViewControllerAnimated:animated];
    for (UIViewController *vc in array) {
        vc.hidesBottomBarWhenPushed = NO;
    }
    
    return array;
}

@end
