//
//  ZJRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZJRecordViewController.h"
#import "WinningRecordTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "WantToSDViewController.h"
#import "ZJRecordListInfo.h"
#import "EditAddressViewController.h"
#import "CollectPrizeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ThriceViewController.h"
#import "CollectGoodsPrizeViewController.h"
#import "AcceptWinningThriceCoinTableViewController.h"


@interface ZJRecordViewController ()<EditAddressViewControllerDelegate,WantToSDViewControllerDelegate>
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation ZJRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"中奖记录";
    pageNum =1;
    dataSourceArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_myTableView reloadData];
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

#pragma mark - http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZJRecordViewController *weakSelf = self;
    
    [helper getZJRecordWithUserid:[ShareManager shareInstance].userinfo.id
                          pageNum:[NSString stringWithFormat:@"%d",pageNum]
                         limitNum:@"20"
                          success:^(NSDictionary *resultDic){
                              
                              [self hideRefresh];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadResult:resultDic];
                              }else {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              
                              [self hideRefresh];
                              [Tool showPromptContent:decretion onView:self.view];
                          }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightWinRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (dataSourceArray.count > 0 && pageNum == 1) {
            [dataSourceArray removeAllObjects];
            
        }
        
        ZJRecordListInfo *previous = nil;
        for (NSDictionary *dic in resourceArray)
        {
            ZJRecordListInfo *current = [dic objectByClass:[ZJRecordListInfo class]];
            
            // 同一场一元购可能产生两个订单，一元购中奖订单，三赔中奖订单
            BOOL isSameOrder = NO;
            if (previous) {
                NSString *good_fight_id = previous.id;
                NSString *current_fight_id = current.id;
                if ([good_fight_id isEqualToString:current_fight_id?:@""]) {
                    isSameOrder = YES;
                }
            }
            
            // 当前订单是三赔订单，预处理
            if ([current isThriceGoods]) {
                current.thriceOrderID = current.order_id;
                current.thriceOrderStatus = current.order_status;
                current.sanpeiRecordList = current.sanpeiRecordList;
            }

            if (isSameOrder) {
                
                // 合并两个中奖订单，即既中了一元购，也中了三赔
                NSString *thriceOrderID = current.order_id;
                NSString *orderStatus = current.order_status;
                previous.thriceOrderID = thriceOrderID;
                previous.thriceOrderStatus = orderStatus;
                previous.sanpeiRecordList = current.sanpeiRecordList;
                previous.get_beans = current.get_beans;

            } else {
                
                [dataSourceArray addObject:current];
                previous = current;
            }
        }
        
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
        
        // 中了三赔，也中了一元购, thriceOrderID == nil, 还有数据没有下发自动获取
        if ([previous hasWinThrice] && previous.thriceOrderID.length == 0 && [previous hasWinCrowdfunding]) {
            [self httpGetRecordList];
        }
        
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    
    [_myTableView reloadData];
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSDButtonAction:(UIButton *)btn
{
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    
    if ([info isVirtualGoods]) {
        
        CollectPrizeViewController *vc = [[CollectPrizeViewController alloc] initWithNibName:@"CollectPrizeViewController" bundle:nil];
        vc.orderInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if ([info.order_status isEqualToString:@"待发货"])
        {
            
            EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
            vc.orderInfo = info;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            if ([info.is_bask isEqualToString:@"y"]) {
                return;
            }else{
                
                WantToSDViewController *vc = [[WantToSDViewController alloc]initWithNibName:@"WantToSDViewController" bundle:nil];
                vc.detailInfo = info;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 160;
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info hasBettingThrice]) {
        height += 112;
    }
    
    return height;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    WinningRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinningRecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WinningRecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell reloadWithData:info ofUser:[ShareManager shareInstance].userinfo.id];
    
    cell.winningButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *data = @{@"status": @"待发货",
                               @"good_period": info.good_period?:@"",
                               @"good_name": info.good_name?:@""};
        [Tool showWinLottery:data];
        
        return [RACSignal empty];
    }];
    cell.bettingButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if ([info isThriceGoods]) {
            
            ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return [RACSignal empty];
    }];
    
    if ([info hasWinThrice]) {
        [cell.thriceResultView whenTapped:^{
            
            AcceptWinningThriceCoinTableViewController *vc = [[AcceptWinningThriceCoinTableViewController alloc] initWithNibName:@"AcceptWinningThriceCoinTableViewController" bundle:nil];
            vc.data = info;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    // 点击一元购区域
    if ([info hasWinCrowdfunding]) {
        
        if ([info isVirtualGoods]) {
            
            CollectPrizeViewController *vc = [[CollectPrizeViewController alloc] initWithNibName:@"CollectPrizeViewController" bundle:nil];
            vc.orderInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            CollectGoodsPrizeViewController *vc = [[CollectGoodsPrizeViewController alloc] initWithNibName:@"CollectGoodsPrizeViewController" bundle:nil];
            vc.orderInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        
        if ([info isThriceGoods]) {
            
            ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetRecordList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       [weakSelf httpGetRecordList];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
}

#pragma mark -  EditAddressViewControllerDelegate 

- (void)editAddressSuccess
{
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark -  WantToSDViewControllerDelegate 

- (void)shaidanSuccess
{
   [_myTableView.mj_header beginRefreshing];
}

@end
