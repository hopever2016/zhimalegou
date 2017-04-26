//
//  ProfileTableViewController.m
//  DuoBao
//
//  Created by clove on 2/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "DuoBaoRecordViewController.h"
#import "ZJRecordViewController.h"
#import "ShaiDanViewController.h"
#import "JFDHViewController.h"
#import "SafariViewController.h"
#import "UserInfoViewController.h"
#import "CouponsViewController.h"
#import "CZViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "InviteViewController.h"
#import "RechargeThriceTableViewController.h"

#import "MQChatViewManager.h"
#import "MQChatDeviceUtil.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "NSArray+MQFunctional.h"
#import "MQBundleUtil.h"
#import "MQAssetUtil.h"
#import "MQImageUtil.h"
#import "BTBadgeView.h"

@interface ProfileTableViewController ()<UINavigationControllerDelegate, MQManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *prizeButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UIView *recordContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *profileContainerView;
@property (nonatomic, weak) BTBadgeView *badgeView;
@property (weak, nonatomic) IBOutlet UIButton *crowdfundingRechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *thriceRechargeButton;
@property (nonatomic, strong) UIView *thriceCoinView;
@property (weak, nonatomic) IBOutlet UIView *leftContainerView;
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileWidthConstraint;

@end

@implementation ProfileTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _tableHeaderView.width = ScreenWidth;
    _tableHeaderView.height = 201 * UIAdapteRate;
    
    self.tableView.top = -20;
    self.tableView.tableHeaderView = _tableHeaderView;
    self.navigationController.navigationBarHidden = YES;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    
    [_profileImageView whenTapped:^{
        [self profileAction];
    }];
    
    [_nameLabel whenTapped:^{
        [self clickLoginAction];
    }];
    
    [self registerNotif];
    
    float leftMargin = 40;
    _recordContainerView.width = ScreenWidth;
    _recordButton.left = leftMargin;
    _prizeButton.centerX = ScreenWidth/2;
    _reviewButton.right = ScreenWidth - leftMargin;
    
    float space = 4;
    [_recordButton verticalImageAndTitle:2];
    [_prizeButton verticalImageAndTitle:2];
    [_reviewButton verticalImageAndTitle:2];
    
}

- (void)UIAdapter
{
    _profileWidthConstraint.constant = 78 * UIAdapteRate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self updateUserInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self UIAdapter];
    
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.borderWidth = 4;
    _profileImageView.layer.borderColor = [UIColor colorFromHexString:@"fb9289"].CGColor;
    _profileImageView.backgroundColor = [UIColor colorFromHexString:@"ffffff"];
    _profileImageView.layer.cornerRadius = _profileImageView.width/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger num = 1;
    
    if (section == 1) {
        num = 2;
    }
    
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    NSString *imageName = @"icon_redpacket";
    NSString *title = @"我的红包";
    NSString *detail = @"";
    
    
    if (indexPath.section == 0) {

        _recordContainerView.top = 0;
        [cell.contentView addSubview:_recordContainerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                imageName = @"icon_redpacket";
                title = @"我的红包";
                detail = @"";
            } else if (indexPath.row == 1) {
                imageName = @"icon_invite";
                title = @"邀请好友";
                detail = @"邀请有大礼";
            }
            
        } else if (indexPath.section == 2) {
            imageName = @"icon_service";
            title = @"联系客服";
            detail = @"";
            
            float width = 30;
            BTBadgeView *bagdeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//            bagdeView.value = @"1";
            [cell.contentView addSubview:bagdeView];
            bagdeView.right = ScreenWidth - 29;
            bagdeView.centerY = cell.height/2;
            bagdeView.shadow = NO;
            bagdeView.strokeWidth = 0;
            bagdeView.shine = NO;
            bagdeView.font = [UIFont systemFontOfSize:12 * UIAdapteRate];
            bagdeView.fillColor = [UIColor colorWithRed:0.9647 green:0.1176 blue:0.1373 alpha:1];
            
            _badgeView = bagdeView;
        }
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detail;
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textColor = [UIColor colorFromHexString:@"474747"];
        cell.textLabel.font = [UIFont systemFontOfSize:16 * UIAdapteRate];
//        cell.detailTextLabel.textColor = [UIColor colorFromHexString:@""];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14 * UIAdapteRate];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if (indexPath.section == 0) {
        height = 85;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self couponAction];
        } else if (indexPath.row == 1) {
            [self inviteAction];
        }
    } else if (indexPath.section == 2) {
        [self messageAction];
    }
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
                                            selector:@selector(quitLoginReload)
                                                name:kQuitLoginSuccess
                                              object:nil];
    
    
    //我的tab点击事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoFromServer)
                                                name:kUpdateUserInfo
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
    [self couponAction];
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
//        [self httpUserInfo];
    }
}

- (void)quitLoginReload
{
    [self updateUserInterface];
}

#pragma mark -

- (void)updateUserInterface
{
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    NSString *profileImageName = userInfo.user_header;
    NSString *name = userInfo.nick_name;
    NSString *crowdfundingCoin = [NSString stringWithFormat:@"%.0f", userInfo.user_money];
    NSString *thriceCoin = [NSString stringWithFormat:@"%.0f", userInfo.happy_bean_num];
    float coinFontSize = 22 * UIAdapteRate;

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:crowdfundingCoin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:coinFontSize]}];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:@" 夺宝币" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 * UIAdapteRate]}];
    [attr appendAttributedString:attr2];
    
    _nameLabel.text = name;
    _leftLabel.attributedText = attr;

    [_thriceCoinView removeFromSuperview];
    _thriceCoinView = [Tool thriceCoinViewWithStr:thriceCoin font:[UIFont boldSystemFontOfSize:coinFontSize] textColor:[UIColor whiteColor]];
    [_rightContainerView addSubview:_thriceCoinView];
    _thriceCoinView.centerX = _rightContainerView.width/2;
    _thriceCoinView.centerY = _rightContainerView.height/2;
    
    // 没有夺宝币显示充值
    if ([crowdfundingCoin isEqualToString:@"0"]) {
        _leftLabel.attributedText = nil;
        _leftLabel.text = @"充值夺宝币";
        _leftLabel.font = [UIFont systemFontOfSize:16 * UIAdapteRate];
    }
    
    // 没有欢乐豆显示充值
    [_thriceRechargeButton setTitle:nil forState:UIControlStateNormal];
    if ([thriceCoin isEqualToString:@"0"]) {
        
        [_thriceCoinView removeFromSuperview];
        [_thriceRechargeButton setTitle:@"充值欢乐豆" forState:UIControlStateNormal];
        _thriceRechargeButton.font = [UIFont systemFontOfSize:16 * UIAdapteRate];
    }
    
    if ([ShareManager shareInstance].userinfo.islogin) {
        
        _nameLabel.userInteractionEnabled = NO;
        _nameLabel.font = [UIFont systemFontOfSize:13 * UIAdapteRate];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"myimage"];
        NSURL *URL = [NSURL URLWithString:profileImageName];

        __weak typeof(self) wself = self;
        [_profileImageView sd_setImageWithURL:URL placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (cacheType == SDImageCacheTypeNone && image) {
                [UIView transitionWithView:wself.profileImageView
                                  duration:0.25
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    wself.profileImageView.image = image;
                                } completion:^(BOOL finished) {
                                    
                                }];
                
                [wself.profileImageView setNeedsLayout];
            }
        }];
        
    } else {
        _nameLabel.userInteractionEnabled = YES;
        _nameLabel.font = [UIFont boldSystemFontOfSize:17];
        
        _profileImageView.image = PublicImage(@"myimage");
        _nameLabel.text = @"登录";
        _leftLabel.text = @"夺宝币";
        
        [_thriceCoinView removeFromSuperview];
        [_thriceRechargeButton setTitle:@"欢乐豆" forState:UIControlStateNormal];
    }
    
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    NSString *currentMQID = [MQManager getCurrentCustomizedId];
    if (userID.length > 0) {
        
        [[MQChatViewConfig sharedConfig] setMQClientId:userID];
        
        [MQManager getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
            
            NSString *value = @"";
            if (messages.count > 0) {
                value = [NSString stringWithFormat:@"%ld", messages.count];
            }
            _badgeView.value = value;
            
            XLog(@"%@", messages);
            [MQManager setClientOffline];
            [[MQChatViewConfig sharedConfig] setMQClientId:nil];
        }];

    }
    
    if ([ShareManager shareInstance].isInReview == YES) {
        
        [_thriceCoinView removeFromSuperview];
        [_thriceRechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        [_thriceRechargeButton addTarget:self action:@selector(rechargeCrowdfundingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -

- (IBAction)rechargeCrowdfundingAction:(id)sender {
    
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_exchange_tap
                          value:nil];
    
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    CZViewController *vc = [[CZViewController alloc] initWithNibName:@"CZViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rechargeThriceAction:(id)sender {
    
    if ([ShareManager shareInstance].isInReview == YES) {
        return;
    }
    
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_exchange_tap
                          value:nil];
    
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    RechargeThriceTableViewController *vc = [[RechargeThriceTableViewController alloc]initWithNibName:@"RechargeThriceTableViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)profileAction
{
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGAAction_tabbar_tap_profile
                          value:nil];
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    UserInfoViewController *vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)recordAction:(id)sender {

    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_join_record_tap
                          value:nil];

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc] initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)winRecordAction:(id)sender {

    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_win_record_tap
                          value:nil];

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)reviewAction:(id)sender {

    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_review_tap
                          value:nil];

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    ShaiDanViewController *vc = [[ShaiDanViewController alloc] initWithNibName:@"ShaiDanViewController" bundle:nil];
    vc.userId = [ShareManager shareInstance].userinfo.id;
    [self.navigationController pushViewController:vc animated:YES];
}
//- (void)clickSignButtonAction:(id)sender
//{
//    if (![Tool islogin]) {
//        [Tool loginWithAnimated:YES viewController:nil];
//        return;
//    }
//    
//    [self httpUserSign];
//}

- (void)couponAction
{
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_coupon_tap
                          value:nil];

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inviteAction
{
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_invite_tap
                          value:nil];

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageAction
{
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_customer_service_tap
                          value:nil];

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
    NSString *mqID = [userID stringByAppendingFormat:@"_%@", alias];
    
    
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
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    
    chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLoginAction
{
    [Tool loginWithAnimated:YES viewController:nil];
}

- (IBAction)settingAction:(id)sender {
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_profile
                          label:kGALabel_profile_setting_tap
                          value:nil];

    SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)httpUserInfo
{
    if (![ShareManager shareInstance].userinfo.islogin) {
        return;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak typeof(self) weakSelf = self;
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  NSDictionary *dict = [resultDic objectForKey:@"data"];
                                  UserInfo *info = [dict objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                                  [weakSelf updateUserInterface];
                                
                              }else{
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                              
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
}

- (void)updateUserInfoFromServer
{
    [self updateUserInterface];
    [self httpUserInfo];
}

- (void)pushWinLotteryViewController
{
    [self winRecordAction:nil];
}

- (void)pushBettingRecordViewController
{
    [self recordAction:nil];
}

- (void)pushBettingRecordViewController:(NSDictionary *)dictionary
{
        [GA reportEventWithCategory:kGACategoryTabbarTap
                             action:kGAAction_tabbar_tap_profile
                              label:kGALabel_profile_win_record_tap
                              value:nil];
        
        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
        ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
}

@end
