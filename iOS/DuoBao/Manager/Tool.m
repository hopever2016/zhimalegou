//
//  Tool.m
//  Matsu
//
//  Created by linqsh on 15/5/13.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "Tool.h"
#import "MBProgressHUD.h"
#import "SJAvatarBrowser.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "LKDBHelper.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "KeychainWrapper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WinningLotteryAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import "PaySelectedData.h"
#import "WinningThriceAlertView.h"


#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

@implementation Tool


+ (void)showPromptContent:(NSString *)content
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = content;
    HUD.margin = 10.f;
    HUD.yOffset = 90.f ;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.5];
}

/**
 *  显示提示信息
 *
 *  @param content  提示内容
 *  @param selfView 提示信息所在的页面
 */
+ (void)showPromptContent:(NSString *)content onView:(UIView *)selfView
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:selfView animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = content;
    HUD.margin = 10.f;
    HUD.yOffset = 90.f ;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.5];
    
}

/**
 *  present ViewController
 *
 *  @param viewController        presenting viewController
 *  @param presentViewController presented viewController
 *  @param animated              animation
 */
+ (void)presentModalFromViewController:(UIViewController *)viewController
                 presentViewController:(UIViewController *)presentViewController
                              animated:(BOOL)animated
{
    if (IOS6_OR_LATER)
    {
        [viewController presentViewController:presentViewController
                                     animated:animated
                                   completion:nil];
    }
    else
    {
        [viewController presentViewController:presentViewController animated:YES completion:nil];
    }
}

/**
 *  dismiss viewController
 *
 *  @param dismissViewController dismissed viewController
 *  @param animated              animation
 */
+ (void)dismissModalViewController:(UIViewController *)dismissViewController
                          animated:(BOOL)animated
{
    if (IOS6_OR_LATER)
    {
        [dismissViewController dismissViewControllerAnimated:animated completion:nil];
    }
    else
    {
        [dismissViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  16进制颜色值转RGB
 *
 *  @param hexString 16进制字符串色值
 *
 *  @return RGB色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor clearColor];;
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range = NSMakeRange(0, 2);
    
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float)red / 255.0f)
                           green:((float)green / 255.0f)
                            blue:((float)blue / 255.0f)
                           alpha:1.0f];
}

/**
 *  保存图片到document
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/**
 *  压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/**
 *  获取公共图片
 */
+ (UIImage *)imageInPublic:(NSString *)imageName{
    NSString *imgName = [NSString stringWithFormat:@"%@.png", imageName];
    return [UIImage imageNamed:imgName];
}


/**
 *  获取连接的wifi的信息
 */
+ (NSDictionary *)wifiInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count])
        {
            NSMutableDictionary *proccessWifiInfo = [NSMutableDictionary dictionary];
            [proccessWifiInfo setObject:[info objectForKey:@"SSID"] forKey:@"SSID"];
            [proccessWifiInfo setObject:[info objectForKey:@"SSIDDATA"] forKey:@"SSIDDATA"];
            
            NSString *bssid = [info objectForKey:@"BSSID"];
            NSArray *array = [bssid componentsSeparatedByString:@":"];
            
            NSMutableString *proccessBSSID = [NSMutableString string];
            for (int i=0; i<array.count; i++)
            {
                NSString *ipComponent = [array objectAtIndex:i];
                if (ipComponent.length == 1) {
                    [proccessBSSID appendFormat:@"0%@", ipComponent];
                }else{
                    [proccessBSSID appendString:ipComponent];
                }
                
                if (i != array.count-1) {
                    [proccessBSSID appendString:@":"];
                }
            }
            
            [proccessWifiInfo setObject:proccessBSSID forKey:@"BSSID"];
            
            return proccessWifiInfo;
            break;
        }
    }
    
    return nil;
}


/**
 *  全屏查看图片（单张）
 */

+ (void)FullScreenToSeePicture:(UIImage*)image 
{
    
    [SJAvatarBrowser showImage:image];
}

/**
 *  获取当前时间
 *  @param dateFormatString 时间格式
 */

+ (NSString *)getCurrentTimeWithFormat:(NSString *)dateFormatString
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:dateFormatString];
    NSString * curTime = [df stringFromDate:currentDate];
    
    //    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //    [formater setDateFormat:dateFormatString];
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //    [formater setTimeZone:timeZone];
    //    NSString * curTime = [formater stringFromDate:[NSDate date]];
    
    return curTime;
}

+ (BOOL)isMobileNumberClassification:(NSString*)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES)
        || ([regextestphs evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)islogin
{
    if ([ShareManager shareInstance].userinfo ) {
        return [ShareManager shareInstance].userinfo.islogin;
    }
    return NO;
}

+ (BOOL)isTestAccount
{
    if ([[ShareManager shareInstance].userinfo.id isEqualToString:@"18046057263"]) {
        return YES;
    }
    return NO;
}

+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    if (!viewControl) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:animated completion:nil];
    }else{
        [viewControl presentViewController:nav animated:animated completion:nil];
    }
}


+ (void)autoLoginSuccess:(void (^)(NSDictionary *))success
                    fail:(void (^)(NSString *))fail {
    
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    HttpHelper *helper = [[HttpHelper alloc] init];
    if (userInfo && userInfo.islogin) {
        
        if (userInfo.password.length == 0 || [userInfo.password isEqualToString:@"<null>"]) {
            
            NSString *loginIdStr = nil;
            NSString *typeStr = nil;
            
            if (userInfo.qq_login_id.length > 0 && ![userInfo.qq_login_id isEqualToString:@"<null>"] ) {
                loginIdStr = userInfo.qq_login_id ;
                typeStr = @"qq";
            }else{
                loginIdStr = userInfo.weixin_login_id ;
                typeStr = @"weixin";
            }
            
            [helper thirdloginByWithLoginId:loginIdStr
                                  nick_name:userInfo.nick_name
                                user_header:userInfo.user_header
                                       type:typeStr
                                   jpush_id:[JPUSHService registrationID]
                                    success:^(NSDictionary *resultDic){

                                        success(resultDic);
                                    }fail:^(NSString *decretion){
                                        if (fail) {
                                            fail(decretion);
                                        }
                                    }];
        }
        else{
            [helper loginByWithMobile:userInfo.app_login_id
                             password:userInfo.password
                             jpush_id:[JPUSHService registrationID]
                              success:^(NSDictionary *resultDic){
                                  success(resultDic);
                              }fail:^(NSString *decretion){
                                  if (fail) {
                                      fail(decretion);
                                  }
                              }];
        }
    }
}

/**
 *  统一收起键盘
 */
+ (void)hideAllKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


/**
 *  获取数据库相关信息(用户信息)
 */
+ (void)getUserInfoFromSqlite
{
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    
    if ([DBHelper getTableCreatedWithClass:[UserInfo class]]) {
        NSArray *array = [DBHelper search:[UserInfo class] where:nil orderBy:nil offset:0 count:0];
        
        if (array && array.count > 0) {
            for (UserInfo *info in array) {
                [ShareManager shareInstance].userinfo = info;
                break;
            }
        }
        
    }
}

/**
 *  获取数据库相关信息(用户信息)
 */
+ (SystemConfigure *)getSystemConfigureFromDB
{
    SystemConfigure *object = nil;
    
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    
    if ([DBHelper getTableCreatedWithClass:[SystemConfigure class]]) {
        NSArray *array = [DBHelper search:[SystemConfigure class] where:nil orderBy:nil offset:0 count:0];
        object = [array firstObject];
//        if (array && array.count > 0) {
//            for (SystemConfigure *info in array) {
//                [ShareManager shareInstance].userinfo = info;
//                break;
//            }
//        }
        
    }
    
    if (object == nil) {
        object = [[SystemConfigure alloc] init];
    }
    
    return object;
}


+ (void)saveSystemConfigureToDB:(SystemConfigure *)object
{
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];

    if([DBHelper getTableCreatedWithClass:[SystemConfigure class]])
    {
        [DBHelper deleteWithClass:[SystemConfigure class] where:nil];
    }
    
    [DBHelper insertToDB:object];
}

/**
*  存储当前账号信息，本地只保存一次，覆盖逻辑
*/
+ (void)saveUserInfoToDB:(BOOL)islogin
{
    if (islogin) {
        [ShareManager shareInstance].userinfo.islogin = YES;
    }else{
        [ShareManager shareInstance].userinfo.islogin = NO;
    }
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    if([DBHelper getTableCreatedWithClass:[UserInfo class]])
    {
        [DBHelper deleteWithClass:[UserInfo class] where:nil];
    }
    
    [DBHelper insertToDB:[ShareManager shareInstance].userinfo];
}




/**
 *  指定大小压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 * label 自适应字体大小
 */
+ (void)setFontSizeThatFits:(UILabel*)label
{
    label.adjustsFontSizeToFitWidth = YES;
}


/**
 *  32位MD5加密
 *
 *  @param string           加密字符串
 *  @param LetterCaseOption 加密选项 {UpperLetter:大写；LowerLetter:小写}
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encodeUsingMD5ByString:(NSString *)srcString
                    letterCaseOption:(LetterCaseOption)letterCaseOption
{
    if (!srcString) {
        srcString = @"";
    }
    
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned)strlen(cStr), digest );
    NSMutableString *encodeString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [encodeString appendFormat:@"%02x", digest[i]];
    
    if (letterCaseOption == UpperLetter) {
        return [encodeString uppercaseString];
    }else{
        return [encodeString lowercaseString];
    }
    
}

/*
 * 时间戳转为时间字符串
 *
 */
+ (NSString *)timeStringToDateSting:(NSString *)timestr format:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];//
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


/**
 *  判断号码是否是合法手机号
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)validateMobile:(NSString *)checkString
{
    NSString * regex = @"(^[0-9]{11}$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:checkString];
    return isMatch && (checkString.length == 11);
}


/**
 *  判断是否输入的金额是否合法
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  随机生成字符串
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (NSString *)randomlyGeneratedStrWithLength:(NSInteger)lenght
{
    char data[lenght];
    for (int x=0;x<lenght;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:lenght encoding:NSUTF8StringEncoding];
}

/**
 *  发送短信
 *
 *  @param viewController 从哪个viewConotroller弹出的短信窗口
 *  @param recipients     收件人
 *  @param content        短信内容
 */
+ (void)sendMessageByViewController:(UIViewController *)viewController
                         recipients:(NSArray *)recipients
                            content:(NSString *)content
{
    
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if (!canSendSMS) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备无法发送短信"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = (id)viewController;
    picker.body = content;
    picker.recipients = [NSArray arrayWithArray:recipients];
    
//    [FindMeTool presentModalFromViewController:viewController
//                         presentViewController:picker
//                                      animated:NO];
    [viewController presentViewController:picker animated:YES completion:nil];
}

/*
 * 校验身份证
 *
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    BOOL flag;
    if (cardNo.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:cardNo];
}

/**
 *  注入本地JavaScript代码
 */
+ (void)injectLocalJavaScript:(UIWebView *)webview jsFileName:(NSString *)jsFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsFileName ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithContentsOfFile:filePath
                                                         encoding:NSASCIIStringEncoding
                                                            error:nil];
    [webview stringByEvaluatingJavaScriptFromString:jsString];
}

/*
 * 获取个人信息
 *
 */
+ (void)getUserInfo
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                              }
                          }fail:^(NSString *decretion){
                          }];
}


+ (void)showShareActionSheet:(UIView *)sender
                        text:(NSString *)text
                      images:(id)images
                         url:(NSURL *)url
                       title:(NSString *)title
                        type:(SSDKContentType)type
                  completion:(void (^)(SSDKResponseState state))completion

{
    UIImage *image = [UIImage imageNamed:@"app_logo.png"];
    if (images) {
        image = images;
    }
    
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray = images;
    if (images)
    {
        if ([images isKindOfClass:[UIImage class]]) {
            imageArray = @[images];
        }
        
        [shareParams SSDKSetupShareParamsByText:text
                                         images:imageArray
                                            url:url
                                          title:title
                                           type:type];
        
//        [shareParams SSDKEnableUseClientShare];
    } else {
        
        [shareParams SSDKSetupShareParamsByText:text
                                         images:imageArray
                                            url:url
                                          title:title
                                           type:type];
    }
    
    // 分享微信好友
    SSDKContentType shareType = type == SSDKContentTypeImage ? SSDKContentTypeImage : SSDKContentTypeApp;
    [shareParams SSDKSetupWeChatParamsByText:text
                                       title:title
                                         url:url
                                  thumbImage:image
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:shareType
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    // 分享微信朋友圈
    shareType = type == SSDKContentTypeImage ? SSDKContentTypeImage : SSDKContentTypeWebPage;
    [shareParams SSDKSetupWeChatParamsByText:text
                                       title:title
                                         url:url
                                  thumbImage:image
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:shareType
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    // 分享QQ好友
    shareType = type == SSDKContentTypeImage ? SSDKContentTypeImage : SSDKContentTypeWebPage;
    [shareParams SSDKSetupQQParamsByText:text
                                   title:title
                                     url:url
                              thumbImage:image
                                   image:nil
                                    type:shareType
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    // 分享QQ空间
    shareType = type == SSDKContentTypeImage ? SSDKContentTypeImage : SSDKContentTypeWebPage;
    [shareParams SSDKSetupQQParamsByText:text
                                   title:title
                                     url:url
                              thumbImage:image
                                   image:nil
                                    type:shareType
                      forPlatformSubType:SSDKPlatformSubTypeQZone];

    // 分享新浪微博
    shareType = type == SSDKContentTypeImage ? SSDKContentTypeImage : SSDKContentTypeWebPage;
    [shareParams SSDKSetupSinaWeiboShareParamsByText:text
                                               title:title
                                               image:image
                                                 url:url
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:shareType];
    [shareParams SSDKEnableUseClientShare];
    
    //2、分享
    [ShareSDK showShareActionSheet:sender
                             items:@[
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformSubTypeQZone),
                                     @(SSDKPlatformTypeSinaWeibo)
//                                     @(SSDKPlatformTypeTencentWeibo),
                                     ]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
                       case SSDKResponseStateSuccess:
                       {
                           if (completion) {
                               completion(state);
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (completion) {
                               completion(state);
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           if (completion) {
                               completion(state);
                           }
                           break;
                       }
                       default:
                           break;
                   }
               }];
}

///*
// * 分享
// *
// */
//+ (void)shareMessageToOtherApp:(NSString *)shareImageUrl
//                   description:(NSString *)description
//                      titleStr:(NSString *)titleStr
//                      shareUrl:(NSString *)shareUrl
//                      fromView:(UIView *)fromView
//{
//    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//    id<ISSContent> publishContent = nil;
//    
//    if(shareImageUrl)
//    {
//        //构造分享内容
//        publishContent = [ShareSDK content:description
//                            defaultContent:description
//                                     image:[ShareSDK imageWithUrl:shareImageUrl]
//                                     title:titleStr
//                                       url:shareUrl
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK imageWithUrl:shareImageUrl]];
//    }else{
//        //构造分享内容
//        publishContent = [ShareSDK content:description
//                            defaultContent:description
//                                     image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]
//                                     title:titleStr
//                                       url:shareUrl
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]];
//    }
//    
//    
//    //自定义新浪微博分享菜单项
//    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
//                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
//                                                                      clickHandler:^{
//                                                                          [ShareSDK shareContent:publishContent
//                                                                                            type:ShareTypeSinaWeibo
//                                                                                     authOptions:nil
//                                                                                   statusBarTips:YES
//                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                                                                              
//                                                                                              if (state == SSPublishContentStateSuccess)
//                                                                                              {
//                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
//                                                                                                  [Tool shareAppSuccessBackCall];
//                                                                                              }
//                                                                                              else if (state == SSPublishContentStateFail)
//                                                                                              {
//                                                                                                  [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
//                                                                                                  NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
//                                                                                              }
//                                                                                          }];
//                                                                      }];
//    
//    
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:fromView
//                            arrowDirect:UIPopoverArrowDirectionUp];
//    
//    
//    NSArray *shareList = nil;
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi] && [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])
//    {
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
//                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//        
//    }
//    if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
//                     nil];
//    }
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//    }
//    
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     nil];
//    }
//    
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    [Tool shareAppSuccessBackCall];
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
//                                    
//                                }
//                            }];
//}
//
///*
// * 分享图片
// *
// */
//+ (void)shareMessageToOtherAppWithImage:(UIImage *)shareImage
//                            description:(NSString *)description
//                               titleStr:(NSString *)titleStr
//                               shareUrl:(NSString *)shareUrl
//                               fromView:(UIView *)fromView
//{
//    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//    id<ISSContent> publishContent = nil;
//    
//    if(shareImage)
//    {
//        //构造分享内容
//        publishContent = [ShareSDK content:nil
//                            defaultContent:nil
//                                     image:[ShareSDK jpegImageWithImage:shareImage quality:1.0]
//                                     title:titleStr
//                                       url:nil
//                               description:nil
//                                 mediaType:SSPublishContentMediaTypeImage];
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK jpegImageWithImage:shareImage quality:1.0]];
//    }else{
//        //构造分享内容
//        publishContent = [ShareSDK content:description
//                            defaultContent:description
//                                     image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]
//                                     title:titleStr
//                                       url:shareUrl
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]];
//    }
//    
//    
//    //自定义新浪微博分享菜单项
//    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
//                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
//                                                                      clickHandler:^{
//                                                                          [ShareSDK shareContent:publishContent
//                                                                                            type:ShareTypeSinaWeibo
//                                                                                     authOptions:nil
//                                                                                   statusBarTips:YES
//                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                                                                              
//                                                                                              if (state == SSPublishContentStateSuccess)
//                                                                                              {
//                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
//                                                                                                  [Tool shareAppSuccessBackCall];
//                                                                                              }
//                                                                                              else if (state == SSPublishContentStateFail)
//                                                                                              {
//                                                                                                  [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
//                                                                                                  NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
//                                                                                              }
//                                                                                          }];
//                                                                      }];
//    
//    
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:fromView
//                            arrowDirect:UIPopoverArrowDirectionUp];
//    
//    
//    NSArray *shareList = nil;
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi] && [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])
//    {
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
//                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//        
//    }
//    if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
//                     nil];
//    }
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//    }
//    
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     nil];
//    }
//    
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    [Tool shareAppSuccessBackCall];
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
//                                    
//                                }
//                            }];
//    
//}
//
///*
// * 分享图片
// *
// */
//+ (void)shareMessageToOtherApp:(UIImage *)shareImage
//                   description:(NSString *)description
//                      titleStr:(NSString *)titleStr
//                      shareUrl:(NSString *)shareUrl
//                      fromView:(UIView *)fromView
//                        result:(SSPublishContentEventHandler)result
//{
//    id<ISSContent> publishContent = nil;
//    
//    if(shareImage)
//    {
//        //构造分享内容
//        publishContent = [ShareSDK content:description
//                            defaultContent:description
//                                     image:[ShareSDK jpegImageWithImage:shareImage quality:1.0]
//                                     title:titleStr
//                                       url:shareUrl
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//        
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK jpegImageWithImage:shareImage quality:1.0]];
//    }else{
//        //构造分享内容
//        publishContent = [ShareSDK content:description
//                            defaultContent:description
//                                     image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]
//                                     title:titleStr
//                                       url:shareUrl
//                               description:description
//                                 mediaType:SSPublishContentMediaTypeNews];
//        //定制新浪信息
//        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"app_logo.png"]]];
//    }
//    
//    
//    //自定义新浪微博分享菜单项
//    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
//                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
//                                                                      clickHandler:^{
//                                                                          [ShareSDK shareContent:publishContent
//                                                                                            type:ShareTypeSinaWeibo
//                                                                                     authOptions:nil
//                                                                                   statusBarTips:YES
//                                                                                          result:result];
//                                                                      }];
//    
//    
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:fromView
//                            arrowDirect:UIPopoverArrowDirectionUp];
//    
//    
//    NSArray *shareList = nil;
//    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi] && [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])
//    {
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
////                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//        
//    }
//    if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
//                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
//                     nil];
//    }
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
////                     [NSNumber numberWithInteger:ShareTypeQQ],
//                     [NSNumber numberWithInteger:ShareTypeQQSpace],
//                     nil];
//    }
//    
//    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
//    {
//        
//        shareList = [ShareSDK customShareListWithType:
//                     sinaItem,
//                     nil];
//    }
//    
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:result];
//}
//
//
//+ (void)shareAppSuccessBackCall
//{
//    [Tool showPromptContent:@"分享成功" onView:[UIApplication sharedApplication].keyWindow];
//    if ([ShareManager shareInstance].shareType == 1) {
//        HttpHelper *helper = [[HttpHelper alloc] init];
//        [helper getShareBackWithUserId:[ShareManager shareInstance].userinfo.id
//                               news_id:[ShareManager shareInstance].shareContentId
//                               success:^(NSDictionary *resultDic){
//                                   NSLog(@"%@",resultDic);
//                               }fail:^(NSString *decretion){
//                               }];
//    }
//    else if ([ShareManager shareInstance].shareType == 2){
//        HttpHelper *helper = [[HttpHelper alloc] init];
//        [helper getShaiDanOrAppShareBackWithUserId:[ShareManager shareInstance].userinfo.id
//                                              type:@"9"
//                                         target_id:[ShareManager shareInstance].shareContentId
//                                           success:^(NSDictionary *resultDic){
//                                               NSLog(@"%@",resultDic);
//                                           }fail:^(NSString *decretion){
//                                           }];
//    }else if ([ShareManager shareInstance].shareType == 3){
//        HttpHelper *helper = [[HttpHelper alloc] init];
//        [helper getShaiDanOrAppShareBackWithUserId:[ShareManager shareInstance].userinfo.id
//                                              type:@"4"
//                                         target_id:nil
//                                           success:^(NSDictionary *resultDic){
//                                               NSLog(@"%@",resultDic);
//                                           }fail:^(NSString *decretion){
//                                           }];
//    }
//}

//上架屏蔽数据判断接口
+ (void)httpGetIsShowThridView
{
    [ShareManager shareInstance].isShowThird = @"y";
    
    if ([ShareManager shareInstance].isInReview == YES){
        [ShareManager shareInstance].isShowThird = @"n";
    }

    return;
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getHttpWithUrlStr:URL_GetIsSJ
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [ShareManager shareInstance].isShowThird = [[resultDic objectForKey:@"data"] objectForKey:@"is_money_pay"];
                              [ShareManager shareInstance].serverPhoneNum = [[resultDic objectForKey:@"data"] objectForKey:@"tel"];
                              [ShareManager shareInstance].domain = [[resultDic objectForKey:@"data"] objectForKey:@"domain"];
                          }
                      }fail:^(NSString *decretion){
                      }];
}

+ (NSString*)getUUID
{
    NSString* UUID = [KeychainWrapper keychainStringFromMatchingIdentifier:[KeychainWrapper UUID]];
    if (UUID == nil || UUID.length == 0) {
        CFUUIDRef CFUUIDRef = CFUUIDCreate(kCFAllocatorDefault);
        if (CFUUIDRef) {
            UUID = (__bridge NSString *)(CFUUIDCreateString(kCFAllocatorDefault, CFUUIDRef));
            [KeychainWrapper createKeychainNSStringValue:UUID forIdentifier:[KeychainWrapper UUID]];
        }
    }
    
    return UUID;
}

+ (void)getServerConfigure
{
    //校验是否需要版本审核
    SystemConfigure *configure = [Tool getSystemConfigureFromDB];
    BOOL cantVerifyVersion = configure.cantVerifyVersion;
    
    // 需要校验版本判断是否正在进行苹果审核
    if (cantVerifyVersion == YES) {
        [ShareManager shareInstance].isInReview = NO;
    }
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getVersion:^(NSDictionary *resultDic) {
        
        NSDictionary *dict = resultDic[@"data"];
        if (dict) {
            
            NSString *serverVersion = dict[@"version"];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            // 是否最新版本
            BOOL isNewestVersion = YES;
            
            // 版本号类型验证
            NSString *type = dict[@"type"];
            if ([type isEqualToString:@"Ios"]) {
               
                
                NSArray *serverNumbers = [serverVersion componentsSeparatedByString:@"."];
                NSArray *versionNumbers = [version componentsSeparatedByString:@"."];
                
                int serverNum = 0;
                int versionNum = 0;
                
                NSInteger count = serverNumbers.count - 1;
                for (NSInteger i= serverNumbers.count-1; i>=0; i--) {
                    
                    int rate = pow(100, i);
                    
                    NSNumber *m = [serverNumbers objectAtIndex:count-i];
                    serverNum += rate* [m intValue];
                    m = [versionNumbers objectAtIndex:count-i];
                    versionNum += rate* [m intValue];
                }
                
                if (versionNum < serverNum) {
                    isNewestVersion = NO;
                }

                // 本地版本号 > 服务器版本号, 表示正在审核阶段
                if (versionNum > serverNum) {
                    [ShareManager shareInstance].isInReview = YES;
                    configure.cantVerifyVersion = NO;
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kShouldVerifyVersion];
                    [ShareManager shareInstance].isShowThird = @"n";
                } else {
                    [ShareManager shareInstance].isInReview = NO;
                    configure.cantVerifyVersion = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kShouldVerifyVersion];
                    [ShareManager shareInstance].isShowThird = @"y";
                }
                
                [Tool saveSystemConfigureToDB:configure];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 是否强制升级
            NSString *forceUpdate = [dict objectForKey:@"is_force_update"];
            
//#if DEBUG
//    forceUpdate = @"y";
//#endif
                if (versionNum < serverNum) {
                    
                    if ([forceUpdate isEqualToString:@"y"]) {
                        
                        UIAlertView *chooseAlert = [[UIAlertView alloc] initWithTitle:@"您的客户端应用版本已经不再受到支持，请立即更新。" message:nil delegate:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
                        [chooseAlert show];
                        
                        [[chooseAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                            
                            NSURL *url = [NSURL URLWithString:ShareLinkItunes];
                            [[UIApplication sharedApplication] openURL:url];
                            
                            sleep(2);
                            exit(0);
                            //                    if ([indexNumber intValue] == 0) {
                            //                        exit(0);
                            //                    } else if ([indexNumber intValue] == 1) {
                            //
                            //                    }
                        }];
                    } else {
                        
                        // 当前版本不是最新，本地保存的latestVersion字段没有被更新，即非强制更新只显示一次
                        if (isNewestVersion == NO && serverVersion && ![configure.latestVersion isEqualToString:serverVersion]) {
                            
                            configure.latestVersion = serverVersion;    // 更新服务器版本号
                            [Tool saveSystemConfigureToDB:configure];
                            
                            UIAlertView *chooseAlert = [[UIAlertView alloc] initWithTitle:@"有新版本啦！" message:@"邀请好友可以获得夺宝币，还能支付宝提现哦！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", @"忽略此版本", nil];
                            [chooseAlert show];
                            
                            [[chooseAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                                if ([indexNumber intValue] == 0) {
                                    
                                } else if ([indexNumber intValue] == 1) {
                                    NSURL *url = [NSURL URLWithString:ShareLinkItunes];
                                    [[UIApplication sharedApplication] openURL:url];
                                }
                            }];
                        }
                    }
                    
                }
            }
        }
    } fail:^(NSString *description) {

    }];
    
    // 获取服务器支付渠道配置信息
    [self getConfigurePaymentChannels];
}


+ (void)getConfigurePaymentChannels
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    
    // 获取配置信息
    [helper getConfigure:^(NSDictionary *resultDic) {
        
        SystemConfigure *configure = [self getSystemConfigureFromDB];
        
        NSDictionary *data = [resultDic objectForKey:@"data"];
        NSString *status = [resultDic objectForKey:@"status"];
        if (data && [status isEqualToString:@"0"]) {
            NSArray *array = [data objectForKey:@"pay_channel"];
            NSString *exchangeRateStr = [data objectForKey:@"happy_specific"];

            NSMutableArray *configureArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    PaySelectedData *object = [dict objectByClass:[PaySelectedData class]];
                    [configureArray addObject:object];
                }
            }
            
            configure.exchangeRate = [exchangeRateStr doubleValue];
            configure.paymentChannels = configureArray;
            [ShareManager shareInstance].configureArray = [NSArray arrayWithArray:configureArray];
            [ShareManager shareInstance].configure = configure;
            [Tool saveSystemConfigureToDB:configure];
        }
        
    } fail:^(NSString *description) {
        
    }];
}

+ (void)showVoucher
{
    float rate = [UIScreen mainScreen].bounds.size.width / 375.0f;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift.png"]];
    imageView.size = CGSizeMake(554./2 * rate, 690./2 * rate);
    imageView.userInteractionEnabled = YES;
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:imageView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    [imageView whenTapped:^{
        [imageView hideView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VoucherDismiss" object:nil];
    }];
}


+ (void)showCarLotteryWithNumber:(NSString *)lotteryNumber
{    
    float rate = [UIScreen mainScreen].bounds.size.width / 375.0f;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app弹窗背景.png"]];
    imageView.size = CGSizeMake(554./2 * rate, 690./2 * rate);
    imageView.userInteractionEnabled = YES;
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:imageView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    [imageView whenTapped:^{
        [imageView hideView];
    }];
    
    alertController.viewWillHideHandler = ^(UIView *view) {
        
        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper activeCarLottery:^(NSDictionary *resultDic) {
            
        } fail:^(NSString *description) {
            
        }];
    };
}

+ (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    
    UIImage *codeImage = nil;
    
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);

    return codeImage;
}

// 邀请好友注册链接
+ (NSString *)inviteFriendToRegisterAddress:(NSString *)recommendUserID
{
    NSString *str = [NSString stringWithFormat:@"%@/%@h5Register.jhtml", kInviteLinkPrefix, recommendUserID];

    return str;
}

+ (void)showWinLottery:(NSDictionary *)data
{
    NSString *status = [data objectForKey:@"status"];
    if (data && [status isEqualToString:@"待发货"]) {
        WinningLotteryAlertView *alertView = [[WinningLotteryAlertView alloc] initWithDictionary:data];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        alertController.backgoundTapDismissEnable = YES;
        alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

+ (void)showWinningThrice:(NSDictionary *)data
{
//    NSString *status = [data objectForKey:@"status"];
//    if (data && [status isEqualToString:@"待发货"]) {
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WinningThriceAlertView" owner:nil options:nil];

        WinningThriceAlertView *alertView = [nib firstObject];
        [alertView setData:data];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        alertController.backgoundTapDismissEnable = YES;
        alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
}


+ (BOOL)currentVersionIsLower:(NSString *)thisVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    BOOL isLower = NO;
    
    NSArray *thisVersionNumbers = [thisVersion componentsSeparatedByString:@"."];
    NSArray *versionNumbers = [version componentsSeparatedByString:@"."];
    
    int thisVersionNum = 0;
    int versionNum = 0;
    
    NSInteger count = thisVersionNumbers.count - 1;
    for (NSInteger i=thisVersionNumbers.count-1; i>=0; i--) {
        
        int rate = pow(100, i);
        
        NSNumber *m = [thisVersionNumbers objectAtIndex:count-i];
        thisVersionNum += rate* [m intValue];
        m = [versionNumbers objectAtIndex:count-i];
        versionNum += rate* [m intValue];
    }
    
    if (versionNum < thisVersionNum) {
        isLower = YES;
    }
    
    return isLower;
}

+ (UIView *)thriceCoinViewWithStr:(NSString *)coinStr fontSize:(int)size textColor:(UIColor *)color
{
    UIFont *font = [UIFont systemFontOfSize:size];
    
    return [self thriceCoinViewWithStr:coinStr font:font textColor:color];
}

+ (UIView *)thriceCoinViewWithStr:(NSString *)coinStr font:(UIFont *)font textColor:(UIColor *)color
{
    if ([coinStr isKindOfClass:[NSNumber class]]) {
        coinStr = [coinStr description];
    }
    
    if (coinStr.length == 0 || [coinStr isEqualToString:@"0"]) {
        return nil;
    }
    
    UIColor *orangeCoinColor = color;
    
    if (orangeCoinColor == nil) {
        orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = coinStr;
    label.textColor = orangeCoinColor;
    label.font = font;
    [label sizeToFit];
    
    
    UIImageView *imageVeiw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_thrice_coin_17_21"]];
    imageVeiw.left = label.width + 3;
    imageVeiw.centerY = label.height / 2;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.width = label.width + imageVeiw.width + 3;
    view.height = label.height;
    [view addSubview:label];
    [view addSubview:imageVeiw];
    view.clipsToBounds = YES;
    view.userInteractionEnabled = NO;
    
    return view;
}

+ (void)UIAdapte:(UIView *)superview deepth:(int)deepth
{
    float rate = UIAdapteRate;
    
    for (UIView *view in superview.subviews) {
        view.width *= rate;
        view.height *= rate;
        view.left *= rate;
        view.top *= rate;
        
        if (deepth == 2) {
            
            UIView *containerView = view;
            for (UIView *view in containerView.subviews) {
                view.width *= rate;
                view.height *= rate;
                view.left *= rate;
                view.top *= rate;
                
                if (deepth == 3) {
                    
                    UIView *containerView = view;
                    for (UIView *view in containerView.subviews) {
                        
                        view.width *= rate;
                        view.height *= rate;
                        view.left *= rate;
                        view.top *= rate;
                    }
                }
            }
        }
    }
}



@end
