//
//  AppDelegate.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "HomePageViewController.h"
#import "JieXiaoViewController.h"
#import "ZengQianViewController.h"
#import "QingDanViewController.h"
#import "ProfileTableViewController.h"
#import <MeiQiaSDK/MQManager.h>
#import "CollectPrizeViewController.h"
#import "LoginViewController.h"
#import "DiscoverTableViewController.h"
#import "InviteViewController.h"
#import "WinningLotteryAlertView.h"
#import "CollectPrizeViewController.h"
#import "TYAlertController.h"
#import "WithdrawViewController.h"
#import "SelectGoodsNumberView.h"
#import "FreeGoTableViewController.h"
#import "GA.h"
#import "LoginModel.h"
#import "SPayManager.h"
#import "SPayClient.h"
#import "MustPaySDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "AlertViewOperation.h"
#import "WinningThriceAlertView.h"

#if DEBUG

#import <ReactiveCocoa/ReactiveCocoa.h>

#endif

//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*  获取服务器配置信息
     *
     *  1.校验版本判断是否正在进行苹果审核
     *  2.是否需要强制更新
     */
    [Tool getServerConfigure];
    
//    SystemConfigure *configure = [Tool getSystemConfigureFromDB];
//    BOOL cantVerifyVersion = configure.cantVerifyVersion;
    [NSThread sleepForTimeInterval:2.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController =  [[UIViewController alloc] init];
    
    //web加载内存控制
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 30*1024*1024; // 30MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    [Tool getUserInfoFromSqlite];
    
    //注册极光
    [self registerJGPushWithLaunchOptions:launchOptions];
    
    // 微信注册
    [self initWXApi];
    
    [self initShareFunction];
    
    // Google analytics
    [GA init];
    
    //是否屏蔽支付接口
    [Tool httpGetIsShowThridView];
    
    //初始化tab
    [self initlizeMainViewControllerWithLaunchOptions:launchOptions];
    
    [self autoLogin];
    
    //推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    //#error 请填写您的美洽 AppKey
    [MQManager initWithAppkey:kMeiQiaAppKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@", error);
        }
    }];
        
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
    wechatConfigModel.appScheme = @"wxe76985ecf18269b0";
    wechatConfigModel.wechatAppid = @"wxe76985ecf18269b0";
    wechatConfigModel.isEnableMTA =YES;
    
    //配置微信APP支付
    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
    [[SPayClient sharedInstance] application:application
               didFinishLaunchingWithOptions:launchOptions];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;

#if DEBUG
    
    [self test];
#endif
    
    
    
    return YES;
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)test
{
//    NSDictionary *data = @{@"status": @"待发货",
//                           @"lotteryNumber": @"8",
//                           @"count": @"2200"};
//    
////    [Tool showWinningThrice:data];
//    
//    for (int i=0; i<2; i++) {
//        
//        NSOperation *operation = [[AlertViewOperation alloc] initWithWinningThriceData:data];
//        [_operationQueue addOperation:operation];
//    }
}

- (void)autoLogin
{
    if ([Tool islogin])
    {
        if (![ShareManager shareInstance].userinfo) {
            return;
        }
        
        // Token未失效, 不用自动登录
        BOOL tokenIsValid = [LoginModel validateToken];
        if (tokenIsValid) {
            return;
        }
        
        [Tool autoLoginSuccess:^(NSDictionary *resultDic) {
            
            NSInteger resultCode = [resultDic[@"status"] integerValue];
            if (resultCode != 0) {
                XLog(@"自动登录失败");
//                [Tool showPromptContent:@"自动登录失败" onView:self.window];
            }
            
        } fail:^(NSString *description) {
            XLog(@"自动登录失败");
            //自动登录失败，显示登录对话框
//            [Tool showPromptContent:@"自动登录失败" onView:self.window];
        }];
    }
}

#pragma mark - 初始化主页面

- (void)initlizeMainViewControllerWithLaunchOptions:(NSDictionary *)launchOptions
{
    //导航栏背景图
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:49.0/255.0 blue:64.0/255.0 alpha:1]];//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 首页
    NSString *tabBarImageNameNormal = @"tab_index.png";
    NSString *tabBarImageNameSelected = @"tab_index_selected.png";
    NSString *title = @"夺宝";
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    BaseNavigationController *homePageNav = [[BaseNavigationController alloc] initWithRootViewController:homePageVC];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    homePageVC.tabBarItem = tabBarItem;
    
    
    JieXiaoViewController *jieXiaoVC = [[JieXiaoViewController alloc] initWithNibName:@"JieXiaoViewController" bundle:nil];
    BaseNavigationController *jieXiaoNav = [[BaseNavigationController alloc] initWithRootViewController:jieXiaoVC];
    tabBarImageNameNormal = @"tab_new.png";
    tabBarImageNameSelected = @"tab_new_selected.png";
    title = @"揭晓";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    jieXiaoVC.tabBarItem = tabBarItem;

    
    DiscoverTableViewController *qingDanVC = [[DiscoverTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    BaseNavigationController *qingDanNav = [[BaseNavigationController alloc] initWithRootViewController:qingDanVC];
    tabBarImageNameNormal = @"tab_find.png";
    tabBarImageNameSelected = @"tab_find_selected.png";
    title = @"发现";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    qingDanVC.tabBarItem = tabBarItem;

    
    ProfileTableViewController * userCenterVC = [[ProfileTableViewController alloc] initWithNibName:@"ProfileTableViewController" bundle:nil];
    BaseNavigationController *userCentervcNav = [[BaseNavigationController alloc] initWithRootViewController:userCenterVC];
    tabBarImageNameNormal = @"tab_me.png";
    tabBarImageNameSelected = @"tab_me_selected.png";
    title = @"我的";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    userCenterVC.tabBarItem = tabBarItem;
    
    
    NSArray *navArray = [NSArray arrayWithObjects:homePageNav,jieXiaoNav,qingDanNav,userCentervcNav, nil];

    BaseTabBarController *tabBarController = [[BaseTabBarController alloc] init];
    [tabBarController setViewControllers:navArray];

    self.window.rootViewController = tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //应用图标标签清零
    application.applicationIconBadgeNumber = 0;
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [MQManager openMeiqiaService];
    
    
    [[SPayClient sharedInstance] applicationWillEnterForeground:application];

    [self autoLogin];
    
    //当微信 支付宝不能调起你们的应用时 用户打开你们的应用 发个验证订单的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMustpayCheck object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 各平台回调

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    
    if([url.host isEqualToString:@"data_success"])
    {
        //在safari中支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessInSafari object:nil userInfo:nil];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        NSString *str = url.query;
        NSDictionary *resultDict = [str.stringByRemovingPercentEncoding objectFromJSONString];
        if (resultDict) {
            NSDictionary *dict = [resultDict objectForKey:@"memo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNotification object:nil userInfo:dict];
        }
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"processOrderWithPaymentResult = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:self];
    }

    [[SPayClient sharedInstance] application:app openURL:url options:options];
    
    return YES;
};

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if([url.host isEqualToString:@"data_success"])
    {
        //在safari中支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessInSafari object:nil userInfo:nil];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        NSString *str = url.query;
        NSDictionary *resultDict = [str.stringByRemovingPercentEncoding objectFromJSONString];
        if (resultDict) {
            NSDictionary *dict = [resultDict objectForKey:@"memo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNotification object:nil userInfo:dict];
        }
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"processOrderWithPaymentResult = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
    
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
}

/**
 *  支付结果处理支付结果
 */
- (void)handlePayResultNotification:(NSString *)resultStatue
{
    switch ([resultStatue intValue] ) {
        case 9000:
            [Tool showPromptContent:@"恭喜您，支付成功！" onView:self.window];
            break;
        case 8000:
            [Tool showPromptContent:@"正在处理中,请稍候查看！" onView:self.window];
            break;
        case 4000:
            [Tool showPromptContent:@"很遗憾，您此次支付失败，请您重新支付！" onView:self.window];
            break;
        case 6001:
            [Tool showPromptContent:@"您已取消了支付操作！" onView:self.window];
            break;
        case 6002:
            [Tool showPromptContent:@"网络连接出错，请您重新支付！" onView:self.window];
            break;
        default:
            break;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    XLog(@"%@ %@", NSStringFromSelector(_cmd), url);
    
    return  [[SPayClient sharedInstance] application:application handleOpenURL:url];

//    return [ShareSDK handleOpenURL:url  wxDelegate:self];
}

//#pragma mark - 微信支付回调
#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)onResp:(BaseResp *)resp{
    
//    // 微信Auth回调
//    if ([resp isKindOfClass:[SendAuthResp class]]) {
//        SendAuthResp *object = (SendAuthResp *)resp;
//        NSString *state = object.state;
//        
//        if ([state isEqualToString:kWeixinAuth]) {
//            __weak typeof(self) weakself = self;
//            HttpHelper *helper = [[HttpHelper alloc] init];
//            
//            [helper getWeiXinAuth:object.code Succeed:^(NSDictionary *resultDic) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:kWeixinAuthNotification object:nil];
//            } fail:^(NSString *description) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kWeixinAuthNotification object:nil];
//            }];
//            
//            return;
//        }
//    }
    
    NSLog(@"%@", NSStringFromSelector(_cmd));

    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        int isSuccess  = 0;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付成功!");
                isSuccess = 0;
            }
                break;
            case WXErrCodeCommon:
                isSuccess = -1;
                break;
            case WXErrCodeUserCancel:
                isSuccess = -2;
                break;
            case WXErrCodeSentFail:
                isSuccess = -3;
                break;
            case WXErrCodeUnsupport:
                isSuccess = -5;
                break;
            case WXErrCodeAuthDeny:
                isSuccess = -4;
                break;
            default:
                break;
        }
        
        NSDictionary *parameters = nil;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",isSuccess],@"statue",nil];
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayNotif object:nil userInfo:parameters];
        
    }
}

#pragma mark - 

- (void)initWXApi
{
    [WXApi registerApp:WeiXinKey];
    BOOL result = [WXApi isWXAppInstalled];
    XLog(@"isWXAppInstalled = %d", result);
    
    result = [WXApi isWXAppSupportApi];
    XLog(@"isWXAppSupportApi = %d", result);
    
    XLog(@"getApiVersion %@", [WXApi getApiVersion]);
}

#pragma mark - init sharesdk

- (void)initShareFunction
{
    // ShareSDK
    [ShareSDK registerApp:@"1c05c5f5ff82f"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:WeiBoKey
                                                appSecret:WeiBoSecret
                                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                                 authType:SSDKAuthTypeBoth];
                      break;
//                  case SSDKPlatformTypeTencentWeibo:
//                      //设置腾讯微博应用信息
//                      [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
//                                                   appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                                 redirectUri:@"http://www.sharesdk.cn"];
//                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:WeiXinKey
                                            appSecret:WeiXinSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:QQKey
                                           appKey:QQSecret
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];

//    [ShareSDK registerApp:@"api20"];//字符串api20为您的ShareSDK的AppKey
//    
//    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:WeiBoKey
//                               appSecret:WeiBoSecret
//                             redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
//    
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:WeiBoKey
//                                appSecret:WeiBoSecret
//                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
//                              weiboSDKCls:[WeiboSDK class]];
//    
//    //添加QQ应用  注册网址   http://mobile.qq.com/api/
//    [ShareSDK connectQQWithQZoneAppKey:QQKey
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    
//    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:QQKey
//                           appSecret:QQSecret
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//    //微信登陆的时候需要初始化
//    [ShareSDK connectWeChatWithAppId:WeiXinKey
//                           appSecret:WeiXinSecret
//                           wechatCls:[WXApi class]];
}


#pragma mark - jpush
- (void)registerJGPushWithLaunchOptions:(NSDictionary *)launchOptions
{
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    BOOL isProduction = NO;
#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:JGPushKey channel:@"public" apsForProduction:isProduction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpfNetworkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)jpfNetworkDidReceiveMessage:(NSNotification *)notify
{
    XLog(@"%@", notify);
    NSDictionary *userInfo = notify.userInfo;
    NSDictionary *dict = [userInfo objectForKey:@"extras"];
    XLog(@"%@", [dict my_description]);
//    NSDictionary *dict = [dataStr objectFromJSONString];
    
    NSString *messageType = [dict objectForKey:@"messageType"];
    NSString *title = [dict objectForKey:@"title"];
    NSDictionary *data = [dict objectForKey:@"content"];
    
    // 是否支持版本
    BOOL containThisVersion = NO;
    NSDictionary *versionsDict = [dict objectForKey:@"versions"];
    NSArray *versions = [[versionsDict objectForKey:@"ios"] componentsSeparatedByString:@","];
    NSString *currenVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    for (NSString *version in versions) {
        if ([version isEqualToString:currenVersion]) {
            containThisVersion = YES;
            break;
        }
    }
    
    // 字段为空支持所有版本
    if (versions.count == 0) {
        containThisVersion = YES;
    }
    
    if (containThisVersion) {
        
        // 显示中奖动画
        if ([messageType isEqualToString:@"win_lottery"]) {
            
            NSString *status = [data objectForKey:@"status"];
            if (data && [status isEqualToString:@"待发货"]) {
                
                NSOperation *operation = [[AlertViewOperation alloc] initWithWinningCrowdfundingData:data];
                [_operationQueue addOperation:operation];
//                WinningLotteryAlertView *alertView = [[WinningLotteryAlertView alloc] initWithDictionary:data];
//                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
//                alertController.backgoundTapDismissEnable = YES;
//                alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
//                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
            
        // 显示提示信息
        } else if ([messageType isEqualToString:@"show_alert_0"]) {
            
            NSString *message = [data objectForKey:@"message"];
            NSString *title = [data objectForKey:@"title"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        // 购买成功返回数据
        } else if ([messageType isEqualToString:@"payResult_alert"]) {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:kPayNotification object:nil userInfo:data];
        
        // 配置信息发生变化
        } else if ([messageType isEqualToString:@"configs_Change"]) {
            
            [Tool getConfigurePaymentChannels];
        
        // 欢乐豆兑换比例发生变化
        } else if ([messageType isEqualToString:@"happy_specific"]) {
            
            [self autoLogin];
            
        // 三赔中奖
        } else if ([messageType isEqualToString:@"sanpei_win_lottery"]) {
            
            NSString *status = [data objectForKey:@"status"];
            if (data && [status isEqualToString:@"待发货"]) {
                
                NSOperation *operation = [[AlertViewOperation alloc] initWithWinningThriceData:data];
                [_operationQueue addOperation:operation];
            }
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    
    XLog(@"apple device token = %@", deviceToken);
    
    // 上传设备deviceToken，以便美洽自建推送后，迁移推送
    [MQManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    XLog(@"%@ = %@", NSStringFromSelector(_cmd), userInfo);

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    XLog(@"%@ = %@", NSStringFromSelector(_cmd), [userInfo my_description]);
    
    if ([Tool currentVersionIsLower:@"1.1.10"]) {
        
        NSDictionary *data = [userInfo objectForKey:@"data"];
        NSString *status = [data objectForKey:@"status"];
        if (data && [status isEqualToString:@"待发货"]) {
            WinningLotteryAlertView *alertView = [[WinningLotteryAlertView alloc] initWithDictionary:data];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
            alertController.backgoundTapDismissEnable = YES;
            alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        
        // IOS 7 Support Required
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}





@end
