//
//  PayResultViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "PayResultViewController.h"
#import "BuyResultListTableViewCell.h"
#import "ShopCartInfo.h"
#import "DBNumViewController.h"
#import "DuoBaoRecordViewController.h"

@interface PayResultViewController ()

@end

@implementation PayResultViewController

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
    
    _detailLabel.text = [NSString stringWithFormat:@"您成功参与了%lu件商品共%.0f人次夺宝，信息如下",(unsigned long)_goodsListArray.count,_allMoney];
    
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
    [GA reportEventWithCategory:kGACategoryPay
                         action:kGAAction_pay_result_continue_buy_tap
                          label:nil
                          value:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(clickBackButton)])
        {
            [self.delegate clickBackButton];
        }
    }];
}

- (IBAction)clickDuoBaoRecordButtonAction:(id)sender
{
    [GA reportEventWithCategory:kGACategoryPay
                         action:kGAAction_pay_result_lookup_record_tap
                          label:nil
                          value:nil];

    DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc]initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickJXDBButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(clickBackButton)])
        {
            [self.delegate clickBackButton];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goodsListArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyResultListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"BuyResultListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuyResultListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ShopCartInfo *info = [_goodsListArray objectAtIndex:indexPath.row];
    cell.goodsName.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    cell.buyNum.text = [NSString stringWithFormat:@"%@人次",info.goods_buy_num];
    CGSize size = [cell.buyNum sizeThatFits:CGSizeMake(MAXFLOAT, 36)];
    cell.buyNumLabelWidth.constant = size.width;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ShopCartInfo *info = [_goodsListArray objectAtIndex:indexPath.row];
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = info.id;
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.userName = [ShareManager shareInstance].userinfo.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
