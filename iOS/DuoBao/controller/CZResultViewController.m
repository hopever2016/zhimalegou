//
//  CZResultViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CZResultViewController.h"
#import "CZRecordListViewController.h"

@interface CZResultViewController ()

@end

@implementation CZResultViewController

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
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.title = @"支付结果";
    
    _leftButton.layer.masksToBounds =YES;
    _leftButton.layer.cornerRadius = 3;
    
    _rightButton.layer.masksToBounds =YES;
    _rightButton.layer.cornerRadius = 3;
    
    _buttonWidth.constant = (FullScreen.size.width - 50)/2;
    
    NSString * warnStr = [NSString stringWithFormat:@"恭喜您，获得<color1>%.0f</color1>夺宝币",_allMoney];
    
    if (_coinType) {
        warnStr = [NSString stringWithFormat:@"恭喜您，获得<color1>%.0f</color1>欢乐豆",_allMoney * ThriceExchangeRate];
    }
    
    _titleLabel.textColor = [UIColor blackColor];
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                            @"color1":[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]};
    _titleLabel.attributedText = [warnStr attributedStringWithStyleBook:style];
    
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickGoBackButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSeeRecordButtonAction:(id)sender
{
    CZRecordListViewController *vc = [[CZRecordListViewController alloc]initWithNibName:@"CZRecordListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
