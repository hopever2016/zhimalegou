//
//  CommonTabBar.h
//  PhoneSMS
//
//  Created by Hcat on 13-10-5.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, CommonTabBarType) {
    CommonTabBarTypeTitleOnly = 0 ,
    CommonTabBarTypeImageOnly,
    CommonTabBarTypeTitleAndImage,
};

@protocol CommonTabBarDelegate;

@interface CommonTabBar : UIView{
    CommonTabBarType _commonTabBarType;
}

@property(weak,nonatomic)id<CommonTabBarDelegate> delegate;

@property (nonatomic, strong) UIImage *backgroundImage; //设置背景图片
@property (nonatomic, strong) UIColor *titleColor; //文字颜色
@property (nonatomic, strong) UIColor *titleSelectColor; //文字选中颜色
@property (nonatomic, strong) UIFont  *titlesFont; //文字大小
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic) BOOL isNeedSelectdImage; //是否需要选中图片

@property (nonatomic, strong) UIImage *selectedItemBackgroundImage; //设置选中的图
@property (nonatomic, strong) UIColor *selectedItemBackgroundColor; //设置选中的的颜色
@property (nonatomic, strong) UIColor *selectedItemTopBackgroundColor; //选中上面的背景颜色
@property (nonatomic) CGFloat selectedItemTopBackroundColorHeight;  //上面背景的宽度


-(id)initWithFrame:(CGRect)frame buttonItems:(NSArray *)t_itemArray
  CommonTabBarType:(CommonTabBarType)CommonTabBarType
       isAnimation:(BOOL) t_isAnimation;

-(void)drawItems;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

- (void)showTabBadgeWithIndex:(NSInteger)tabIndex;

- (void)hideTabBadgeWithIndex:(NSInteger)tabIndex;

- (BOOL)getTabBadgeStatueWithIndex:(NSInteger)tabIndex;

@end



@protocol CommonTabBarDelegate<NSObject>

@required

-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index;

@optional

- (CGFloat)CommonTabBarDisplayAnimatioSpeed:(CommonTabBar *)tabBar;

- (CGFloat)CommonTabBarSelectionAnimationSpeed:(CommonTabBar *)tabBar;

- (void)CommonTabBarSelectionAnimationDidBegin:(CommonTabBar *)tabBar;

- (void)CommonTabBarSelectionAnimationDidEnd:(CommonTabBar *)tabBar;

@end

