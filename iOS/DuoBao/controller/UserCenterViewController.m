//
//  UserCenterViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterHeadTableViewCell.h"
#import "IconTableViewCell.h"
#import "DuoBaoRecordViewController.h"
#import "MessageListViewController.h"
#import "ZJRecordViewController.h"
#import "ShaiDanViewController.h"
#import "JFDHViewController.h"
#import "SafariViewController.h"
#import "TaskViewController.h"
#import "InviteFriendsViewController.h"
#import "MoreViewController.h"
#import "UserInfoViewController.h"
#import "CouponsViewController.h"
#import "CZViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "ConnectOurViewController.h"
#import "InviteViewController.h"

#import "MQChatViewManager.h"
#import "MQChatDeviceUtil.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "NSArray+MQFunctional.h"
#import "MQBundleUtil.h"
#import "MQAssetUtil.h"
#import "MQImageUtil.h"

@interface UserCenterViewController ()<UINavigationControllerDelegate,IconTableViewCellDelegate>
{
    NSMutableArray *titleArray;
    NSMutableArray *imageArray;
}

@end

@implementation UserCenterViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateUserInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VoucherDismiss" object:nil];

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self registerNotif];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
//    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [_myTableView reloadData];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParameter
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
}

- (void)createUI
{
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, 35)];
    warnLabel.text = @"声明：所有商品抽奖活动与苹果公司（apple inc.）无关";
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:12];
    warnLabel.textColor =[UIColor colorWithRed:240.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];    warnLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    self.myTableView.tableFooterView = warnLabel;
}


#pragma mark - notif Action
- (void)registerNotif
{
    /**
     *  监听网络状态变化
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachableNetworkStatusChange
                                               object:nil];
    
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoData)
                                                name:kUpdateUserInfo
                                              object:nil];
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoData)
                                                name:kLoginSuccess
                                              object:nil];
    
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginReload)
                                                name:kQuitLoginSuccess
                                              object:nil];
    
    //跳转到红包界面
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(voucherDismiss)
                                                name:@"VoucherDismiss"
                                              object:nil];
}

- (void)voucherDismiss
{
    [self.tabBarController setSelectedIndex:3];
    
    // 跳转到红包界面
    [self selectIconInfo:6];
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        [self httpUserInfo];
    }
}

- (void)updateUserInfoData
{
    [self httpUserInfo];
    
}

- (void)quitLoginReload
{
    [_myTableView reloadData];
    
}
#pragma mark - http

- (void)httpUserSign
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"签到中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper userSignWithUserId:[ShareManager shareInstance].userinfo.id
                       success:^(NSDictionary *resultDic){
                           [HUD hide:YES];
                           if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                           {
                               [weakSelf handleloadSignResult:[resultDic objectForKey:@"data"]];
                           }else{
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                           
                       }fail:^(NSString *decretion){
                           [HUD hide:YES];
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
}

- (void)handleloadSignResult:(NSDictionary *)resultDic
{
    [ShareManager shareInstance].userinfo.user_is_sign = @"y";
    [Tool saveUserInfoToDB:YES];
    [_myTableView reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"签到提示" message:[resultDic objectForKey:@"alertData"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)httpUserInfo
{
    if (![ShareManager shareInstance].userinfo.islogin) {
        return;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                       success:^(NSDictionary *resultDic){
                           
                           if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                           {
                               [weakSelf handleloadUserInfoResult:[resultDic objectForKey:@"data"]];
                           }else{
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                           
                       }fail:^(NSString *decretion){
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
}

- (void)handleloadUserInfoResult:(NSDictionary *)resultDic
{
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [Tool saveUserInfoToDB:YES];
    [_myTableView reloadData];
}


#pragma -mark buttonAction
- (void)clickMessageButtonAction:(id)sender
{
    MessageListViewController *vc = [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSignButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    [self httpUserSign];
}

- (void)clickCZButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    UserInfoViewController *vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickLoginAction
{
    [Tool loginWithAnimated:YES viewController:nil];
}

#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 230;
    }else{
        //只创建一个cell用作测量高度
        static IconTableViewCell *cell = nil;
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IconTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            [cell initImageCollectView];
            cell.collectView.delegate = cell;
            cell.collectView.dataSource = cell;
        }
        
        [self loadGoodsCellContent:cell indexPath:indexPath];
        return [self getGoodsCellHeight:cell];
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UserCenterHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCenterHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([ShareManager shareInstance].userinfo.islogin) {
            
            cell.noLoginControl.hidden = YES;
            cell.normalView.hidden = NO;
            
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
            cell.photoImage.layer.borderColor = [[UIColor whiteColor] CGColor];
            cell.photoImage.layer.borderWidth = 3.0f;
            
            cell.photoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
            [cell.photoImage addGestureRecognizer:tap];
            
            cell.rankLabel.layer.masksToBounds =YES;
            cell.rankLabel.layer.cornerRadius = cell.rankLabel.frame.size.height/2;
            
            cell.signButton.layer.masksToBounds =YES;
            cell.signButton.layer.cornerRadius = cell.signButton.frame.size.height/2;
            
            cell.czButton.layer.masksToBounds =YES;
            cell.czButton.layer.cornerRadius = cell.czButton.frame.size.height/2;
            
            [cell.messageButton addTarget:self action:@selector(clickMessageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.czButton addTarget:self action:@selector(clickCZButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.signButton addTarget:self action:@selector(clickSignButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
                cell.czButton.hidden = NO;
                cell.signButtonCenterX.constant = -54;
            }else{
                cell.czButton.hidden = YES;
                cell.signButtonCenterX.constant = 0;
            }
            
            UserInfo *info = [ShareManager shareInstance].userinfo;
            [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
            cell.numLabel.text = [NSString stringWithFormat:@"ID:%@",info.id];
            if ([info.nick_name isEqualToString:@"<null>"]) {
                cell.nameLabel.text = @"未设置";
            }else{
                cell.nameLabel.text = info.nick_name;
            }
            cell.rankLabel.text = info.level_name;
            CGSize size = [cell.rankLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
            cell.rankLabelWidth.constant = size.width+16;
            
            cell.pointLabel.text = [NSString stringWithFormat:@"%ld",(long)info.user_score];
            size = [cell.pointLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
            cell.poinrLabelWidth.constant = size.width;
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",info.user_money];
            
            if ([info.user_is_sign isEqualToString:@"y"]) {
                [cell.signButton setTitle:@"已签到" forState:UIControlStateNormal];
            }else{
                [cell.signButton setTitle:@"签到" forState:UIControlStateNormal];
            }

        }else{
            
            cell.numLabel.text = @"ID:--";
            cell.noLoginControl.hidden = NO;
            cell.normalView.hidden = YES;
            
            cell.noLoginImage.layer.masksToBounds =YES;
            cell.noLoginImage.layer.cornerRadius = cell.noLoginImage.frame.size.height/2;
            cell.noLoginImage.layer.borderColor = [[UIColor whiteColor] CGColor];
            cell.noLoginImage.layer.borderWidth = 4.0f;
            [cell.noLoginControl addTarget:self action:@selector(clickLoginAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }else{
        IconTableViewCell*cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"IconTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IconTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
            [cell initImageCollectView];
            cell.delegate = self;
            cell.collectView.delegate = cell;
            cell.collectView.dataSource = cell;
            
        }
        [self loadGoodsCellContent:cell indexPath:indexPath];
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)loadGoodsCellContent:(IconTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    [cell.collectView reloadData];
}

- (CGFloat)getGoodsCellHeight:(IconTableViewCell*)cell
{
    
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = cell.collectView.contentSize.height + 12;
    
    if (FullScreen.size.height - 230 - 49 - 35 > height) {
        height = FullScreen.size.height - 230 - 49 - 35;
    }
    return height;
}

#pragma mark - IconTableViewCellDelegate

- (void)selectIconInfo:(NSInteger)index
{
    NSArray *array = @[kGAAction_tabbar_tap_profile,
                       kGALabel_profile_join_record_tap,
                       kGALabel_profile_win_record_tap,
                       kGALabel_profile_review_tap,
                       kGALabel_profile_invite_tap,
                       kGALabel_profile_exchange_tap,
                       kGALabel_profile_coupon_tap,
                       kGALabel_profile_customer_service_tap,
                       kGALabel_profile_setting_tap];
    
    if (index < array.count) {
        [GA reportEventWithCategory:kGACategoryTabbarTap
                             action:kGAAction_tabbar_tap_profile
                              label:array[index]
                              value:nil];
    }
    
    switch (index) {
        case 0:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc] initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ShaiDanViewController *vc = [[ShaiDanViewController alloc] initWithNibName:@"ShaiDanViewController" bundle:nil];
            vc.userId = [ShareManager shareInstance].userinfo.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            JFDHViewController *vc = [[JFDHViewController alloc]initWithNibName:@"JFDHViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            JFDHViewController *vc = [[JFDHViewController alloc]initWithNibName:@"JFDHViewController" bundle:nil];
            vc.isTiXian = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 7:
//        {
//            if (![Tool islogin]) {
//                [Tool loginWithAnimated:YES viewController:nil];
//                return;
//            }
//            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
//            vc.title = @"大转盘";
//            vc.urlStr = [NSString stringWithFormat:@"%@%@user_id=%@",URL_Server,Wap_RotaryGameUrl,[ShareManager shareInstance].userinfo.id];
//            vc.isRotaryGame = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 8:
//        {
//            if (![Tool islogin]) {
//                [Tool loginWithAnimated:YES viewController:nil];
//                return;
//            }
//            TaskViewController *vc = [[TaskViewController alloc]initWithNibName:@"TaskViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 7:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            
            UserInfo *userInfo = [ShareManager shareInstance].userinfo;
            NSString *userID = [ShareManager shareInstance].userinfo.id;
            userID = userID ? userID : @"";
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *versionString = [NSString stringWithFormat:@"iOS %@", version];
            NSString *alias = [ShareManager shareInstance].userinfo.nick_name;
            NSString *telephone = userInfo.user_tel ?:@"";
            
            
            MQChatViewConfig *chatViewConfig = [MQChatViewConfig sharedConfig];
            
            MQChatViewController *chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
            [chatViewConfig setEnableOutgoingAvatar:false];
            [chatViewConfig setEnableRoundAvatar:YES];
            chatViewConfig.navTitleColor = [UIColor whiteColor];
            chatViewConfig.navBarTintColor = [UIColor whiteColor];
            [chatViewConfig setStatusBarStyle:UIStatusBarStyleLightContent];
            
            chatViewController.title = @"客服";
            [chatViewConfig setNavTitleText:@"客服"];
            [chatViewConfig setCustomizedId:userID];
            [chatViewConfig setEnableEvaluationButton:NO];
            [chatViewConfig setAgentName:@"客服"];
            [chatViewConfig setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone}];
            [chatViewConfig setUpdateClientInfoUseOverride:YES];
            [chatViewConfig setRecordMode:MQRecordModeDuckOther];
            [chatViewConfig setPlayMode:MQPlayModeMixWithOther];
            [self.navigationController pushViewController:chatViewController animated:YES];

//            MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
//            [chatViewManager.chatViewStyle setEnableOutgoingAvatar:false];
//            [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
//            chatViewManager.chatViewStyle.navTitleColor = [UIColor whiteColor];
//            chatViewManager.chatViewStyle.navBarTintColor = [UIColor whiteColor];
//            [chatViewManager.chatViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
//            [chatViewManager setNavTitleText:@"客服"];
//            [chatViewManager setLoginCustomizedId:userID];
//            [chatViewManager enableSyncServerMessage:NO];
//            [chatViewManager enableEvaluationButton:NO];
//            MQChatViewController *chatViewController = [chatViewManager pushMQChatViewControllerInViewController:self];
//            chatViewController.title = @"客服";
//            //  [chatViewManager setPreSendMessages:@[@"message1"]];
//            //   [chatViewManager setScheduledAgentId:@"f60d269236231a6fa5c1b0d4848c4569"];
//            //[chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectNone];
//            //    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
////            [self removeIndecatorForView:basicFunctionBtn];
//            [chatViewManager setAgentName:@"客服"];
//            [chatViewManager setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone} override:YES];
//            
//            [chatViewManager setRecordMode:MQRecordModeDuckOther];
//            [chatViewManager setPlayMode:MQPlayModeMixWithOther];
            
            UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
            [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
            back.image = [UIImage imageNamed:@"nav_back.png"];
            [leftItemControl addSubview:back];
            
            chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
            
//            ConnectOurViewController *vc = [[ConnectOurViewController alloc]initWithNibName:@"ConnectOurViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            
            SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)removeIndecatorForView:(UIView *)view {
//    UIView *v = [view viewWithTag:indicator_tag];
//    if (v) {
//        [v removeFromSuperview];
//    }
//}


#pragma mark - 
- (void)pushWinLotteryViewController
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
