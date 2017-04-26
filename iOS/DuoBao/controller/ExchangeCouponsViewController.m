//
//  ExchangeCouponsViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ExchangeCouponsViewController.h"

@interface ExchangeCouponsViewController ()

@end

@implementation ExchangeCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"兑换红包";
    
    _bgView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    _bgView.layer.borderWidth = 1.0f;
    _bgView.layer.masksToBounds =YES;
    _bgView.layer.cornerRadius = 3;
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 3;
    
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

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    if (_couponsText.text.length < 1) {
        [Tool showPromptContent:@"请输入兑换码" onView:self.view];
        return;
    }
    [self httpExchangeCoupons];
    
}

#pragma mark - http
- (void)httpExchangeCoupons
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"兑换中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ExchangeCouponsViewController *weakSelf = self;
    [helper exchangeCouponsWithUserId:[ShareManager shareInstance].userinfo.id
                            couponsId:_couponsText.text
                              success:^(NSDictionary *resultDic){
                                  [HUD hide:YES];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult:resultDic];
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
    if([self.delegate respondsToSelector:@selector(exchangeCouponsSuccess)])
    {
        [self.delegate exchangeCouponsSuccess];
    }
    [Tool showPromptContent:@"兑换成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}

@end
