//
//  GA.h
//  Luxy
//
//  Created by robyzhou on 14/11/21.
//  Copyright (c) 2014年 robyzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define kGACategoryLogin     @"kGACategoryLogin"
#define kGAAction_weixin     @"weixin"
#define kGAAction_QQ     @"QQ"
#define kGAAction_telephone     @"telephone"

#define kGACategoryRegister     @"kGACategoryRegister"
#define kGAAction_enter_register     @"enter_register"
#define kGAAction_register_tap     @"register_tap"
#define kGAAction_register_success     @"register_success"

#define kGACategoryPayGoods     @"kGACategoryPayGoods"
//#define kGAAction_goods_name     @"goods_name"

#define kGACategoryRecharge     @"kGACategoryRecharge"
#define kGALabel_recharge     @"recharge"
#define kGALabel_recharge_goods     @"recharge_goods"

#define kGACategoryInviteSuccess     @"kGACategoryInviteSuccess"
#define kGAAction_invite_success     @"invite_success"

#define kGACategoryActions     @"kGACategoryActions"
#define kGAAction_banner_free     @"banner_free"
#define kGAAction_banner_rule     @"banner_rule"
#define kGAAction_banner_invite     @"banner_invite"
#define kGAAction_banner_iPhone     @"banner_iPhone"

#define kGAAction_invite_tap_in_home     @"invite_tap_in_home"
#define kGAAction_invite_tap_in_profile     @"invite_tap_in_profile"
#define kGAAction_invite_tap_look_up_rule     @"invite_tap_look_up_rule"
#define kGAAction_invite_tap_invite_button     @"invite_tap_invite_button"



#define kGAAction_finder_tap_free     @"finder_tap_free"
#define kGAAction_finder_tap_review     @"finder_tap_review"
#define kGAAction_finder_tap_coupon     @"finder_tap_coupon"
#define kGAAction_finder_tap_FAQ     @"finder_tap_FAQ"

#define kGAAction_home_tap_category     @"home_tap_category"
#define kGAAction_home_tap_second_button     @"home_tap_second_button"
#define kGAAction_home_tap_review     @"home_tap_review"
#define kGAAction_home_tap_invite     @"home_tap_invite"

#define kGAAction_profile_record     @"profile_record"
#define kGAAction_profile_win_record     @"profile_win_record"
#define kGAAction_profile_review     @"profile_review"
#define kGAAction_profile_invite     @"profile_invite"
#define kGAAction_profile_coupon     @"profile_coupon"

#define kGAAction_search     @"search"

#define kGAAction_running_lottery_tapped     @"running_lottery_tapped"
#define kGAAction_running_lottery_top_refresh     @"running_lottery_top_refresh"


#define kGACategoryPay     @"kGACategoryPay"
#define kGAAction_enter_pay_interface     @"enter_pay_interface"
#define kGAAction_tap_pay_button     @"tap_pay_button"
#define kGAAction_pay_type_alipay     @"pay_type_alipay"
#define kGAAction_pay_success     @"pay_success"
#define kGAAction_pay_result_continue_buy_tap     @"pay_result_continue_buy_tap"
#define kGAAction_pay_result_lookup_record_tap     @"pay_result_lookup_record_tap"




@interface GA : NSObject

@property(nonatomic, strong) id<GAITracker> tracker;

+ (void)init;
+ (void)test;
+ (void)enable;
+ (void)disable;

+ (void)reportEventWithCategory:(NSString*)category
                         action:(NSString*)action
                          label:(NSString*)label
                          value:(NSNumber*)value;

#define kGACategoryTabbarTap    @"kGACategoryTabbarTap"

#define kGAAction_tabbar_tap_home     @"tabbar_tap_home"
#define kGAAction_tabbar_tap_running_lottery    @"tabbar_tap_running_lottery"

#define kGAAction_tabbar_tap_finder     @"tabbar_tap_finder"
#define kGALabel_finder_tap_free     @"finder_tap_free"
#define kGALabel_finder_tap_review     @"finder_tap_review"
#define kGALabel_finder_tap_coupon     @"finder_tap_coupon"
#define kGALabel_finder_tap_thrice     @"finder_tap_thrice"
#define kGALabel_finder_tap_FAQ     @"finder_tap_FAQ"

#define kGAAction_tabbar_tap_profile     @"tabbar_tap_profile"
#define kGALabel_profile_join_record_tap     @"profile_join_record_tap"
#define kGALabel_profile_win_record_tap     @"profile_win_record_tap"
#define kGALabel_profile_review_tap     @"profile_review_tap"
#define kGALabel_profile_invite_tap     @"profile_invite_tap"
#define kGALabel_profile_exchange_tap     @"profile_exchange_tap"
#define kGALabel_profile_coupon_tap     @"profile_coupon_tap"
#define kGALabel_profile_customer_service_tap     @"profile_customer_service_tap"
#define kGALabel_profile_setting_tap     @"profile_setting_tap"
#define kGALabel_profile_recharge_tap     @"profile_recharge_tap"
#define kGALabel_profile_letter_tap     @"profile_letter_tap"





@end



