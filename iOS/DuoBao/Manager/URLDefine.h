//
//  URLDefine.h
//  Esport
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** Server URL ***/

#if DEBUG
//    #define URL_Server @"http://www.zhimalegou.com:51001/GetTreasureAppSesame/"
//    #define URL_Server @"http://192.168.0.102:8585/GetTreasureAppSesame/"
    #define URL_Server @"http://15f7y30995.iask.in:8585/GetTreasureAppSesame/"       // 测试服务器

#else
    #define URL_Server @"http://www.zhimalegou.com:51001/GetTreasureAppSesame/"
#endif

#define URL_Server_Still @"http://www.zhimalegou.com:51001/GetTreasureAppSesame/"
#define URL_ServerTest @"http://www.zhimalegou.com:51011/GetTreasureAppSesame/"       // 测试服务器

#define URL_ShareServer @"http://zhima.h5h5h5.cn/GetTreasureAppSesame/"

//图片地址
#define URL_UpdateImageUrl @"appInterface/uploadImg.jhtml"

//上架接口，判断是否隐藏第三方登录
#define URL_GetIsSJ @"appInterface/getStaticData.jhtml"

#pragma mark  wap地址

//大转盘
#define Wap_RotaryGameUrl @"appInterface/rotaryGame.jhtml?"

//赚钱帮助页面
#define Wap_HelpUrl @"appInterface/newHelpIndexInfo.jhtml"

//关于我们
#define Wap_AboutDuobao @"appInterface/aboutUsContentInfo.jhtml?"

//分享app
#define Wap_ShareDuobao @"appInterface/showShareContent.jhtml?"

//常见问题
#define Wap_CJWT @"appInterface/commonProblemInfo.jhtml"

//计算详情
#define Wap_JSXQ @"appInterface/countInfo.jhtml?"

//跳转支付页面
#define Wap_PayMoneyView @"appInterface/paymentGoodsFightIndex.jhtml?"

#pragma mark  登录注册模块

//获取验证码
#define URL_GetVerificationCode @"appInterface/getCode.jhtml"

//注册
#define URL_Register @"appInterface/addUser.jhtml"

//登陆
#define URL_Login @"appInterface/userLogin.jhtml"

//第三方登陆
#define URL_ThirdLogin @"appInterface/otherAddUser.jhtml"

//找回密码
#define URL_FindPwd @"appInterface/updateUserPassword.jhtml"

//第三方绑定接口
#define URL_BangDing @"appInterface/otherUserFirstLogin.jhtml"

#pragma mark  首页 商品
//获取首页数据
#define URL_GetHomePageData @"appInterface/getIndexData.jhtml"

//获取首页数据
#define URL_GetGoodsInfoList @"appInterface/getIndexGoodsList.jhtml"

//获取分类数据
#define URL_GetGoodsType @"appInterface/getGoodsTypeData.jhtml"

//获取分类下商品列表
#define URL_GetGoodsListOfType @"appInterface/getGoodsTypeList.jhtml"

//获取热门搜索
#define URL_GetHotSearchData @"appInterface/getHotSearchData.jhtml"

//搜索商品
#define URL_SearchGoodsInfo @"appInterface/getGoodsSearchList.jhtml"

//加载商品详情
#define URL_LoadGoodsDetailInfo @"appInterface/getGoodsInfoData.jhtml"

//加载夺宝记录
#define URL_LoadDuoBaoRecord @"appInterface/getFightRecordList.jhtml"

//查看夺宝号码
#define URL_LoadDuoBaoLuckNum @"appInterface/getMoreFightNum.jhtml"

//获取往期揭晓数据
#define URL_GetOldDuoBaoData @"appInterface/getHistoryGoodsFightList.jhtml"

//查询是否有某期夺宝
#define URL_QueryPeriod @"appInterface/getGoodsFightIdByPeriod.jhtml"

#pragma mark - 晒单

//晒单列表
#define URL_GetZoneList @"appInterface/getBaskList.jhtml"

//晒单分享详情
#define URL_GetZoneDetail @"appInterface/getBaskContent.jhtml"

//晒单分享回调或者app分享回调
#define URL_GetShaiDanOrAppShareBack @"appInterface/shareReturn.jhtml"

#pragma mark -  支付

//支付
#define URL_Pay @"appInterface/paymentGoodsFight.jhtml"

//获取支付详情
#define URL_GetPayDetailInfo @"appInterface/getOrderIndexData.jhtml"

//获取订单号
#define URL_GetOrderNo @"appInterface/genOrder.jhtml"

//支付宝回调
#define URL_AllipayNotify  @"appInterface/allipay/appNotify.jhtml"

//获取微信支付参数
#define URL_GetWeiXinPayInfo  @"appInterface/unifiedorder.jhtml"

#pragma mark - 购物车

//添加购物车
#define URL_AddShopCart @"appInterface/addShopCart.jhtml"

//获取购物车列表
#define URL_GetShopCarList @"appInterface/getShopCartList.jhtml"

//修改购物车商品
#define URL_ChangeShopCarListInfo @"appInterface/updateShopCart.jhtml"

//删除购物车
#define URL_DeleteShopCart @"appInterface/delShopCart.jhtml"



#pragma mark  － 最新揭晓

//获取最新揭晓
#define URL_GetZXJX @"appInterface/getWillDoGoodsList.jhtml"

#pragma mark  － 赠钱
//挣钱列表
#define URL_GetShareList @"appInterface/getNewsList.jhtml"

//分享后回调
#define URL_GetShareBack @"appInterface/saveNewsShare.jhtml"


#pragma mark - 邀请好友

#define URL_GetInviteInfo @"appInterface/inviteFriends.jhtml"


#pragma mark  我的

//获取大转盘的大奖历史
#define URL_GetRotaryGameHistory @"appInterface/getRotaryGameHistory.jhtml"

//签到
#define URL_Sign @"appInterface/signIn.jhtml"

//获取用户信息
#define URL_GetUserInfo @"appInterface/getUserData.jhtml"

//获取收货地址列表
#define URL_GetAdressList @"appInterface/getUserAddressListData.jhtml"

//修改默认地址接口
#define URL_ChangeDefaultAddress @"appInterface/changeDefaultAddress.jhtml"

//新增收货地址
#define URL_AddAddress @"appInterface/saveAddress.jhtml"

//获取城市列表
#define URL_GetCityInfo @"appInterface/getCityByProvince.jhtml"

//删除地址
#define URL_DeleteMyAddress @"appInterface/delAddress.jhtml"

//修改用户信息
#define URL_ChangeUserInfo @"appInterface/updateUser.jhtml"

//获取系统消息
#define URL_SystemMessage @"appInterface/getMessageInfoList.jhtml"

//夺宝记录
#define URL_GetDuoBaoRecordList @"appInterface/getFightRecordInfoList.jhtml"

//查看他人的夺宝记录
#define URL_GetOtherDuoBaoRecordList @"appInterface/getOtherFightWinRecordList.jhtml"

//中奖记录
#define URL_GetZJRecord @"appInterface/getFightWinRecordList.jhtml"

//选择充值卡兑换方式
#define URL_ChangeCardCollectPrize @"appInterface/saveOrderGetType.jhtml"

//获取订单详情
#define URL_GetFightOneWinRecord @"appInterface/getFightOneWinRecordList.jhtml"

//修改中奖地址
#define URL_ChangeOrderAddress @"appInterface/saveOrderAddress.jhtml"

//发布晒单
#define URL_PublishFightBask @"appInterface/publishFightBask.jhtml"

//积分流水
#define URL_GetPointDetailInfo @"appInterface/getScoreOrMoneyHistoryList.jhtml"

//积分页面所需数据
#define URL_GetTXPoundage @"appInterface/getExchangeData.jhtml"

//积分兑换
#define URL_PointExchange @"appInterface/exchangeInMoney.jhtml"

//邀请好友基本数据
#define URL_InviteFriendsInfo @"appInterface/friendsInfo.jhtml"

//获取好友列表
#define URL_GetFriendsByLevel @"appInterface/getFriendsByLevel.jhtml"

//获取红包列表
#define URL_GetCouponList @"appInterface/getMyTicketList.jhtml"

//兑换红包
#define URL_ExchangeCouponList @"appInterface/addTicketById.jhtml"

//任务大厅
#define URL_TaskList @"appInterface/taskIndex.jhtml"

//等级说明
#define URL_GetMyLevelInfo @"appInterface/getUserLevelInfoData.jhtml"

//充值记录
#define URL_GetCZReord @"appInterface/getMyAlreadyPayList.jhtml"

//充值接口
#define URL_PayCZ @"appInterface/rechargeInMoney.jhtml"

//意见反馈
#define URL_Feedback @"appInterface/saveSuggest.jhtml"

//获取版本号
#define URL_GetVersion @"appInterface/getIosCheckStats.jhtml"


@interface URLDefine : NSObject

@end
