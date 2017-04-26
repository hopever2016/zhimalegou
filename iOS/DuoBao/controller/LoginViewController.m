//
//  LoginViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "ResigterViewController.h"
#import "BangdingViewController.h"
#import <TKAlert&TKActionSheet/TKAlert&TKActionSheet.h>
#import "JMWhenTapped.h"

@interface LoginViewController ()<ResigterViewControllerDelegate, WXApiDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ShareManager shareInstance].userinfo.app_login_id.length > 0  && ![[ShareManager shareInstance].userinfo.app_login_id isEqualToString:@"<null>"]) {
        _phoneText.text = [ShareManager shareInstance].userinfo.app_login_id;
    }else{
        _phoneText.text = @"";
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    if (userID.length > 1) {
        NSString *loginHistory = [userID stringByAppendingString:@"_loginHistory"];
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:loginHistory];
        if ([value boolValue] == NO) {
//            [self performSelector:@selector(showVoucher) withObject:nil afterDelay:1];
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:loginHistory];
        }
    }
}

- (void)initVariable
{
    self.title = @"登录";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _loginButton.layer.masksToBounds =YES;
    _loginButton.layer.cornerRadius = 10;
    
    
    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
        if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) || ([QQApiInterface isQQInstalled] &&[QQApiInterface isQQSupportApi]))
        {
            _thirdLoginView.hidden = NO;
            
            if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
            {
                _weixinLoginButton.hidden = YES;
            }
            if (![QQApiInterface isQQInstalled] || ![QQApiInterface isQQSupportApi])
            {
                _qqLoginButton.hidden = YES;
            }
        }else{
            _thirdLoginView.hidden = YES;
        }
        
    }else{
        _thirdLoginView.hidden = YES;
    }

   
}


- (void)leftNavigationItem
{
//    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
//    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
//    back.image = [UIImage imageNamed:@"nav_back.png"];
//    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftItemAction:)];
    
//    UIView *rightItemView;
//    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
//    rightItemView.backgroundColor = [UIColor clearColor];
//    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
//    btnMoreItem.contentMode = UIViewContentModeLeft;
//    [btnMoreItem setTitle:@"取消" forState:UIControlStateNormal];
//    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,8)];
//    [btnMoreItem addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightItemView addSubview:btnMoreItem];
//    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
//    
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                    target:nil
//                                                                                    action:nil];
//    negativeSpacer.width = 15;
//    self.navigationItem.leftBarButtonItems = @[rightBarButtonItem];
}


- (void)rightItemView
{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定微信" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItemAction:)];
    return;
    
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"绑定微信" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,8)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clickRightItemAction:(id)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    vc.title = @"绑定微信";
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickLoginButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httpLogin];
    
    NSString *telephone = _phoneText.text?:@"";
    [GA reportEventWithCategory:kGACategoryLogin
                         action:kGAAction_telephone
                          label:telephone
                          value:nil];
}

- (IBAction)clickResigterButtonAction:(id)sender
{
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickFindPwdButtonAction:(id)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    vc.title = @"找回密码";
    vc.isFindPwd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickQQLoginButtonAction:(id)sender
{
    [ShareSDK authorize:SSDKPlatformTypeQQ
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self httpOtherLoginWithId:user.uid
                                  band_type:@"qq"
                                  nick_name:user.nickname
                                 user_photo:user.icon];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [Tool showPromptContent:@"授权失败" onView:self.view];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
    
    [GA reportEventWithCategory:kGACategoryLogin
                         action:kGAAction_QQ
                          label:nil
                          value:nil];
}

- (IBAction)clickWeiXinLoginButtonAction:(id)sender
{
    [ShareSDK authorize:SSDKPlatformTypeWechat
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self httpOtherLoginWithId:user.uid
                                  band_type:@"weixin"
                                  nick_name:user.nickname
                                 user_photo:user.icon];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [Tool showPromptContent:@"授权失败" onView:self.view];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
    
    
    [GA reportEventWithCategory:kGACategoryLogin
                         action:kGAAction_weixin
                          label:nil
                          value:nil];
}

//-(void)reloadStateWithType:(ShareType)type{
//    //现实授权信息，包括授权ID、授权有效期等。
//    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
//    //    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
//    id<ISSPlatformUser> credential = [ShareSDK currentAuthUserWithType:type];
//    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//    //                                                        message:[NSString stringWithFormat:
//    //                                                                 @"uid = %@\ntoken = %@",
//    //                                                                 [credential uid],
//    //                                                                 [credential nickname]]
//    //                                                       delegate:nil
//    //                                              cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//    //                                              otherButtonTitles:nil];
//    //    [alertView show];
//    NSLog(@"%@",[NSString stringWithFormat:@"uid = %@; name = %@;image = %@",[credential uid],[credential nickname],[credential profileImage]]);
//    NSString *typeStr = nil;
//    if (type == ShareTypeWeixiSession) {
//        typeStr = @"weixin";
//    }else{
//        typeStr = @"qq";
//    }
//    
//    [self httpOtherLoginWithId:[credential uid]
//                     band_type:typeStr
//                     nick_name:[credential nickname]
//                    user_photo:[credential profileImage]];
//    
//}


#pragma mark http

- (void)httpLogin
{
    
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(![Tool validateMobile:_phoneText.text] )
    {
        [Tool showPromptContent:@"请输入正确手机号" onView:self.view];
        return;
    }
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入密码" onView:self.view];
        return;
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    
    NSString *telephone = _phoneText.text;
    __weak LoginViewController *weakSelf = self;
    [helper loginByWithMobile:_phoneText.text
                     password:_pwdText.text
                     jpush_id:[JPUSHService registrationID]
                     success:^(NSDictionary *resultDic){
                         [HUD hide:YES];
                         if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                             [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                         }else
                         {
                             [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                         }
                         
                     }fail:^(NSString *decretion){
                         [HUD hide:YES];
                         [Tool showPromptContent:@"网络出错了" onView:self.view];
                     }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    //登录成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
    
//    [Tool showPromptContent:@"登录成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
    
}

//第三方登录
- (void)httpOtherLoginWithId:(NSString *)band_id
                   band_type:(NSString *)band_type
                   nick_name:(NSString *)nick_name
                  user_photo:(NSString *)user_photo
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    [helper thirdloginByWithLoginId:band_id
                          nick_name:nick_name
                        user_header:user_photo
                               type:band_type
                           jpush_id:[JPUSHService registrationID]
                       success:^(NSDictionary *resultDic){
                           [HUD hide:YES];
                           if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                               [weakSelf handleloadOtherLoginResult:[resultDic objectForKey:@"data"]];
                           }else
                           {
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                       }fail:^(NSString *decretion){
                           [HUD hide:YES];
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
    
}

- (void)handleloadOtherLoginResult:(NSDictionary *)resultDic
{
    UserInfo *info = [ShareManager shareInstance].userinfo;
    if (info.user_tel.length >0 && ![info.user_tel isEqualToString:@"<null>"]) {
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
//        [Tool showPromptContent:@"登录成功" onView:self.view];
        [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
    }
    else{
        [Tool saveUserInfoToDB:NO];
        BangdingViewController *vc = [[BangdingViewController alloc]initWithNibName:@"BangdingViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 

- (void)resigterSuccess:(NSString *)account
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
