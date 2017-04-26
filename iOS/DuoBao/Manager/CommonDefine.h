//
//  CommonDefine.h
//  XHWiFi
//
//  Created by linqsh on 15/5/19.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//
/*************************************************************************************************
 *
 *  CommonDefine用来定义公用的常量，用符号常量代替数字，提高可维护性
 *
 *************************************************************************************************/
#import <Foundation/Foundation.h>


/**
 *  大小写选项
 */
typedef enum LetterCaseOption{
    UpperLetter = 1, //大写
    LowerLetter //小写
}LetterCaseOption;



//分享的页面
typedef enum ShareTypeOption{
    ShareTypeOption_HomePage = 1, //首页分享
    ShareTypeOption_MyStore,//我的商城分享
    ShareTypeOption_BuyGoods,//采购分享
    ShareTypeOption_QRCode,//二维码页面的分享
    ShareTypeOption_ShareVC
}ShareTypeOption;


//筛选
typedef enum ClickTypeOption{
    ClickOption_NoOne = 1, //
    ClickOption_QYXZ,//区域
    ClickOption_ZNPX,//智能
    ClickOption_SX//筛选
}ClickTypeOption;

//筛选
typedef enum OrderTypeOption{
    OrderTypeOption_All = 1, //全部
    OrderTypeOption_NoPay,//待支付
    OrderTypeOption_NoReciver,//待收货
    OrderTypeOption_NoReview//待评价
}OrderTypeOption;

//赚钱页面筛选
typedef enum ButtonViewSelectOption{
    SelectOption_Recommend = 1, //推荐
    SelectOption_ZX, //最新
    SelectOption_Hot, //热门
    SelectOption_Help //帮助
}ButtonViewSelectOption;

//首页刷新
typedef enum HomePageSelectOption{
    SelectOption_RQ = 1, //人气
    SelectOption_ZX1, //最新
    SelectOption_JD, //进度
    SelectOption_DuplicateJD, //在此点击进度
    SelectOption_ZXRC, //总需人次
    SelectOption_DuplicateZXRC //在此点击总需人次
}HomePageSelectOption;

//支付方式
typedef enum PayTypeOption{
    PayTypeOption_DJB = 1, //多金币
    PayTypeOption_ALiPay, //支付宝
    PayTypeOption_WeiXin
    
}PayTypeOption;

