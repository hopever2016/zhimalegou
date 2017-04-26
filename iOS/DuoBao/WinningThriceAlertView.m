//
//  WinningThriceAlertView.m
//  DuoBao
//
//  Created by clove on 4/19/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "WinningThriceAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+JMJParametricAnimation.h"
#import "CollectPrizeViewController.h"
#import "ProfileTableViewController.h"
#import "UIImage+Crop.h"
#import "ZJRecordViewController.h"

@interface WinningThriceAlertView()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *containverView;
@property (weak, nonatomic) IBOutlet UIView *leftStarView;
@property (weak, nonatomic) IBOutlet UIView *rightStarView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIView *coinContainerView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (nonatomic, copy) NSDictionary *data;

@end


@implementation WinningThriceAlertView


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    self.data = dict;
    
    NSString *lotteryNumber = [dict objectForKey:@"good_period"];
    NSString *goodsTitle = [dict objectForKey:@"good_name"];
    
//    _lotteryNumberLabel.text = [NSString stringWithFormat:@"第%@期", lotteryNumber];
//    _goodsTitleLabel.text = goodsTitle;
    
    
    return self;
}


- (void)setData:(NSDictionary *)dictionary
{
//    CGRect rect = _containverView.frame;
//    CGRect  rect2 = _coinContainerView.frame;
//    CGRect rect3 = _backgroundImageView.frame;
    
    self.height = ScreenHeight;
    self.width = ScreenWidth;
    _containverView.centerX = self.width/2;
    _coinContainerView.centerX = self.width/2;
    _backgroundImageView.centerX = self.width/2;
    _button.centerX = self.width/2;
    
    
    [self UIAdapte];
    
    _containverView.centerX = self.width/2;
    _coinContainerView.centerX = self.width/2;
    _backgroundImageView.centerX = self.width/2;
    _button.centerX = self.width/2;

    [self whenTapped:^{
        [self hideView];
    }];
    
    
    _data = dictionary;
    
    NSDictionary *dict = dictionary;
    NSString *lotteryNumber = [dict objectForKey:@"sanpei_win_fina"];
    NSString *coin = [dict objectForKey:@"get_beans"];
    
    UILabel *label = _firstLabel;
    label.text = [NSString stringWithFormat:@"猜中尾号%@", lotteryNumber];
    label.font = [UIFont systemFontOfSize:15 * UIAdapteRate];
    
    label = _secondLabel;
    label.font = [UIFont systemFontOfSize:15 * UIAdapteRate];
    
    UIColor *color = [UIColor colorFromHexString:@"fffece"];
    UIView *view = [Tool thriceCoinViewWithStr:coin fontSize:26 * UIAdapteRate textColor:color];
    view.centerX = _coinContainerView.width/2;
    view.centerY = _coinContainerView.height / 2;
    [_coinContainerView addSubview:view];

    
    UIButton *button = _button;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    button.backgroundColor = [UIColor colorFromHexString:@"ffc000"];
    UIImage *image = [UIImage imageFromContextWithColor:[UIColor colorFromHexString:@"ffc000"] size:button.size];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"去领豆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"78230e"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
}

- (void)buttonAction
{
    UITabBarController *rootViewController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *tempNV = (UINavigationController *)rootViewController.selectedViewController;
    UIViewController *topVC = tempNV.topViewController;
    if ([topVC isMemberOfClass:[ZJRecordViewController class]]) {
        
        [self hideView];
        return;
    }
    
    [rootViewController.navigationController popToRootViewControllerAnimated:NO];
    [rootViewController setSelectedIndex:3];
    
    for (UINavigationController *nv in rootViewController.viewControllers) {
        [nv popToRootViewControllerAnimated:NO];
    }
    
    UINavigationController *nv = (UINavigationController *)rootViewController.selectedViewController;
    ProfileTableViewController *vc = (ProfileTableViewController *)nv.viewControllers.firstObject;
    if ([vc isMemberOfClass:[ProfileTableViewController class]]) {
        [vc.navigationController popToRootViewControllerAnimated:NO];
        [vc pushWinLotteryViewController];
    }
    
    [self hideView];
}

- (void)UIAdapte
{
    float rate = UIAdapteRate;
    
    for (UIView *view in self.subviews) {
        view.width *= rate;
        view.height *= rate;
        view.left *= rate;
        view.top *= rate;
        
//        UIView *containerView = view;
//        for (UIView *view in containerView.subviews) {
//            view.width *= rate;
//            view.height *= rate;
//            view.left *= rate;
//            view.top *= rate;
//            
//            UIView *containerView = view;
//            for (UIView *view in containerView.subviews) {
//                
//                view.width *= rate;
//                view.height *= rate;
//                view.left *= rate;
//                view.top *= rate;
//            }
//        }
    }
}

@end
