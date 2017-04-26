//
//  CZViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CZViewController.h"
#import "CZRecordListViewController.h"
#import "CZResultViewController.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "IQUIView+IQKeyboardToolbar.h"
#import "PaySelectedController.h"

@interface CZViewController ()<UITextFieldDelegate>
{
    int selectMoney;
    BOOL isSelectWeiXin;
    double czMoney;
}
@property (nonatomic, strong) PaySelectedController *paySelectedController;


@end

@implementation CZViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPayNotif object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
//    [self registerNotif];
    
    [self.sixTextFiled addCancelDoneOnKeyboardWithTarget:self.sixTextFiled cancelAction:@selector(resignFirstResponder) doneAction:@selector(resignFirstResponder)];

    
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    [self.view addSubview:tableViewController.tableView];
    [self addChildViewController:tableViewController];
    tableViewController.tableView.top = _moneyShortcutContainer.bottom + 24;
    _paySelectedController = tableViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = [_paySelectedController height];
    CGFloat constantHeigth = 52;
    height = height == 0 ? constantHeigth : constantHeigth + height - 4;
    _paySelectHeight.constant = height;
    
    // App store 审核期间隐藏购买
    [self hidePurchaseInAppReviewing];
}

// App store 审核期间隐藏购买
- (void)hidePurchaseInAppReviewing
{
    if ([ShareManager shareInstance].isInReview == YES) {
//        _sureButton.hidden = YES;
    }
}

- (void)initVariable
{
    self.title = @"充值";
    
    _photoImage.clipsToBounds = YES;
    
    _oneButton.layer.masksToBounds =YES;
    _oneButton.layer.cornerRadius = 4;
    
    _twoButton.layer.masksToBounds =YES;
    _twoButton.layer.cornerRadius = 4;
    
    _threeButton.layer.masksToBounds =YES;
    _threeButton.layer.cornerRadius = 4;
    
    _fourButton.layer.masksToBounds =YES;
    _fourButton.layer.cornerRadius = 4;
    
    _fiveButton.layer.masksToBounds =YES;
    _fiveButton.layer.cornerRadius = 4;
    
    _sixTextFiled.layer.masksToBounds =YES;
    _sixTextFiled.layer.cornerRadius = 4;

    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 6;
    
    _oneButton.layer.borderWidth = 1.0f;
    _twoButton.layer.borderWidth = 1.0f;
    _threeButton.layer.borderWidth = 1.0f;
    _fourButton.layer.borderWidth = 1.0f;
     _fiveButton.layer.borderWidth = 1.0f;
    _sixTextFiled.layer.borderWidth = 1.0f;
    
    _moneyButtonWidth.constant = (FullScreen.size.width - 40)/3;
    
    selectMoney =0;
    [self updateMoneyLabelStatue];
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        _weixinView.hidden = YES;
        _weixinConstraint.constant = 0;
    }
    else{
        _weixinView.hidden = NO;
        _weixinConstraint.constant = 44;
    }
    
    // 微信商户帐号被微信不支持了
    _weixinConstraint.constant = 0;
    _weixinView.hidden = YES;
}

- (void)updateMoneyLabelStatue
{
    _oneButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];

    _twoButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _threeButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _fourButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _fiveButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
   
    _sixTextFiled.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    
    switch (selectMoney) {
        case 0:
            _oneButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 1:
            _twoButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 2:
            _threeButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 3:
            _fourButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 4:
            _fiveButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        default:
            _sixTextFiled.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
    }

}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"充值记录" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

//支付成功页面
- (void)presentCZSuccessVC
{
    [ShareManager shareInstance].userinfo.user_money = [ShareManager shareInstance].userinfo.user_money + czMoney;
    //进度支付结果页面
    CZResultViewController *vc = [[CZResultViewController alloc]initWithNibName:@"CZResultViewController" bundle:nil];
    vc.allMoney = czMoney;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -

//获取订单号
- (void)httpGetPayOrderInfo
{
    NSString *purchasePermission = [_paySelectedController paymentPermission:czMoney];
    if (![purchasePermission isEqualToString:@"allow"]) {
        [Tool showPromptContent:purchasePermission];
        return;
    }
    
    __block typeof(self) wself = self;
    [_paySelectedController rechargeCrowdfundingCoin:czMoney completion:^(BOOL result, NSString *description, NSDictionary *dict) {
        
        if (result) {
            [wself presentCZSuccessVC];
        } else {
            [Tool showPromptContent:description onView:self.view];
        }
    }];
}

/**
 *  处理支付结果
 */
- (void)handlePayResultNotification:(NSDictionary *)userInfo
{
    NSString *message = nil;
    NSString *resultCode = (NSString*)[userInfo objectForKey:@"resCode"];
    if ([resultCode isEqualToString:@"00"] ||[resultCode isEqualToString:@"9000"]) {
       
        [self presentCZSuccessVC];
    }
    else if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"])
    {
        message = @"很遗憾，您此次支付失败，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
        message = @"您已取消了支付操作！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"8000"]){
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
        
        
    }else if([resultCode isEqualToString:@"6002"]){
        message = @"网络连接出错，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
    }
    
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    CZRecordListViewController *vc = [[CZRecordListViewController alloc]initWithNibName:@"CZRecordListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickMoneyButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    selectMoney = (int)btn.tag;
    [self updateMoneyLabelStatue];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    
    if ([ShareManager shareInstance].isInReview == YES) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_fight_ids=%@&goods_buy_nums=%@&is_shop_cart=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, @"234",@"5",@"n"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    } else {
        
        switch (selectMoney) {
            case 0:
                czMoney = 5.0;
                break;
            case 1:
                czMoney = 10.0;
                break;
            case 2:
                czMoney = 30.0;
                break;
            case 3:
                czMoney = 50.0;
                break;
            case 4:
                czMoney = 100.0;
                break;
            default:
            {
                if (_sixTextFiled.text.length < 1)
                {
                    [Tool showPromptContent:@"请输入充值金额" onView:self.view];
                    return;
                }else{
                    czMoney = [_sixTextFiled.text doubleValue];
                }
            }
                break;
        }
        
        [self httpGetPayOrderInfo];
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectMoney = 6;
    [self updateMoneyLabelStatue];
    return YES;
}

@end
