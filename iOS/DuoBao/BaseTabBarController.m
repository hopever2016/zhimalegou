//
//  BaseTabBarController.m
//  DuoBao
//
//  Created by clove on 3/19/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "BaseTabBarController.h"
#import "JieXiaoViewController.h"
#import "HomePageViewController.h"


@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor defaultRedColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = NO;
    
    id vc = [((UINavigationController *)viewController).viewControllers firstObject];
    
    // 揭晓时间刷新
    if ([vc isKindOfClass:[JieXiaoViewController class]]) {
        [(JieXiaoViewController *)vc beginRefreshTop];
    }
    
    // 首页tab点击，若刷新间隔30秒，则自动刷新
    if ([vc isKindOfClass:[HomePageViewController class]]) {
        [(HomePageViewController *)vc autorefresh];
    }
    
}


@end
