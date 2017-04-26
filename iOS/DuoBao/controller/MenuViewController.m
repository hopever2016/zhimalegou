//
//  MenuViewController.m
//  BusinessCloud
//
//  Created by Hcat on 13-10-12.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import "MenuViewController.h"

#define kTabBarHeight 49.0f
#define MAIN_WIDTH [[UIScreen mainScreen] bounds].size.width

static MenuViewController *menuViewController;

@implementation UIViewController (MenuViewControllerSupport)

- (MenuViewController *)menuViewController
{
    return menuViewController;
}

@end


@interface MenuViewController (){
    UIView *_containerView;
    UIView *_transitionView;
    UIView *maskView;
}

@property (nonatomic,strong,readwrite) CommonTabBar *tabBar;

- (void)displayViewAtIndex:(NSUInteger)index;

@end


@implementation MenuViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popCurrentViewController" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _tabBar = nil;
    _tabBar.delegate = nil;
    _viewControllers = nil;
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
    self = [super init];
    if (self != nil)
    {
        CGRect containerViewFrame = [[UIScreen mainScreen] bounds];
        
        if (IOS7_OR_LATER) {
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(containerViewFrame.origin.x,
                                                                      containerViewFrame.origin.y,
                                                                      containerViewFrame.size.width,
                                                                      containerViewFrame.size.height)];
        }else{
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(containerViewFrame.origin.x,
                                                                      containerViewFrame.origin.y,
                                                                      containerViewFrame.size.width,
                                                                      containerViewFrame.size.height - 20)];
        }
        
        _containerView.backgroundColor = [UIColor clearColor];
        
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, _containerView.frame.size.height - kTabBarHeight)];
        _transitionView.backgroundColor = [UIColor clearColor];
        
        maskView = [[UIView alloc] initWithFrame:containerViewFrame];
        maskView.backgroundColor = [UIColor whiteColor];
        
        
        _viewControllers = vcs;
        
        self.tabBar = [[CommonTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, MAIN_WIDTH, kTabBarHeight)
                                              buttonItems:arr
                                         CommonTabBarType:CommonTabBarTypeTitleAndImage
                                              isAnimation:YES];
        
        self.tabBar.delegate = (id<CommonTabBarDelegate>)self;
        self.tabBar.titlesFont = [UIFont systemFontOfSize:10];
        self.tabBar.titleColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        self.tabBar.titleSelectColor = [UIColor colorWithRed:230.0/255.0 green:47.0/255.0 blue:48.0/255.0 alpha:1];;
        self.tabBar.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        
        [self.tabBar setSelectedItemTopBackgroundColor:[UIColor clearColor]];
        
        [self.tabBar drawItems];
        //设置autoresizing 属性
        [self.tabBar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        menuViewController = self;
        
        self.animateDriect = 0;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [_containerView addSubview:_transitionView];
    [_containerView addSubview:_tabBar];
    self.view = _containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTabBarTransparent:(BOOL)yesOrNo {
    if (yesOrNo == YES) {
        _transitionView.frame = _containerView.bounds;
    }else {
        _transitionView.frame = CGRectMake(0, 0, MAIN_WIDTH, _containerView.frame.size.height - kTabBarHeight);
    }
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
    if (yesOrNO == YES && self.tabBar.frame.origin.y == self.view.frame.size.height)
    {
        return;
    }
    else if (yesOrNO == NO && self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
    {
        return;
    }
    
    if (animated == YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        
        if (yesOrNO == YES) {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y + kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }else {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y - kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }
        [UIView commitAnimations];
        
    } else {
        if (yesOrNO == YES) {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y + kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        } else {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y - kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }
    }
}

- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [self.tabBar setSelectedIndex:index];
}

- (void)displayViewAtIndex:(NSUInteger)index
{
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)] &&
        ![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
        
        return;
    }
    
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) {
        return;
    }
    
    _selectedIndex = index;
    UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
    selectedVC.view.frame = _transitionView.frame;
    
    if ([maskView isDescendantOfView:_transitionView]) {
        [_transitionView addSubview:maskView];
    }
    
    [_transitionView addSubview:maskView];
    
    if ([selectedVC.view isDescendantOfView:_transitionView])
    {
        [_transitionView bringSubviewToFront:maskView];
        [_transitionView bringSubviewToFront:selectedVC.view];
    }
    else
    {
        [_transitionView addSubview:selectedVC.view];
    }
    
    
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }
}

#pragma mark - commonTabBarDelegate

- (void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if (self.selectedIndex != index) {
        
        NSArray *array = @[kGAAction_tabbar_tap_home,
                           kGAAction_tabbar_tap_running_lottery,
                           kGAAction_tabbar_tap_finder,
                           kGAAction_tabbar_tap_profile];
        if (index < array.count) {
            [GA reportEventWithCategory:kGACategoryTabbarTap
                                 action:array[index]
                                  label:nil
                                  value:nil];
        }
        
        [self displayViewAtIndex:index];
    }
}

@end
