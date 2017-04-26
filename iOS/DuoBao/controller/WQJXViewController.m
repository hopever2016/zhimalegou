//
//  WQJXViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "WQJXViewController.h"
#import "WQJXListTableViewCell.h"
#import "UserViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsDetailInfo.h"
#import "WQJXDJSTableViewCell.h"

@interface WQJXViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation WQJXViewController

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
    self.title = @"往期揭晓";
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 8)];
    
    _seeButton.layer.masksToBounds =YES;
    _seeButton.layer.cornerRadius = _seeButton.frame.size.height/2;
    dataSourceArray = [NSMutableArray array];
    pageNum = 1;
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

- (void)httpGetSourceData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak WQJXViewController *weakSelf = self;
    [helper getOldDuoBaoDataWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
                               success:^(NSDictionary *resultDic){
                                   [self hideRefresh];
                                   if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                       [weakSelf handleloadResult:resultDic];
                                   }else
                                   {
                                       [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                   }
                               }fail:^(NSString *decretion){
                                   [self hideRefresh];
                                   [Tool showPromptContent:decretion onView:self.view];
                               }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsFightHistoryList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsDetailInfo *info = [dic objectByClass:[GoodsDetailInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 30) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    [_myTableView reloadData];
}


- (void)httpQueryPeriod
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"查询中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak WQJXViewController *weakSelf = self;
    [helper queryPeriodWithGoodsId:_goodId
                       good_period:_textFiled.text
                            success:^(NSDictionary *resultDic){
                                [HUD hide:YES];
                                if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                    [weakSelf handleLoadQueryResult:resultDic];
                                }else
                                {
                                    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                }
                            }fail:^(NSString *decretion){
                                [HUD hide:YES];
                                [Tool showPromptContent:decretion onView:self.view];
                            }];
}


- (void)handleLoadQueryResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    if (dic) {
        NSString *goodId = [dic objectForKey:@"goods_fight_id"];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = goodId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Tool showPromptContent:@"查无此期夺宝" onView:self.view];
    }
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    UIImageView *imageview = (UIImageView *)tap.self.view;
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:imageview.tag];
    NSString *userIdStr = info.win_user_id;
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    vc.userId = userIdStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)clicSeeButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
 
    if (_textFiled.text.length < 1) {
        [Tool showPromptContent:@"请输入要查询的期数" onView:self.view];
        return;
    }
    [self httpQueryPeriod];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSourceArray.count;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if([info.status isEqualToString:@"倒计时"])
    {
        return 44;
    }else{
        return 130;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 12;
    }
    return 8;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if([info.status isEqualToString:@"倒计时"])
    {
        WQJXDJSTableViewCell  *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"WQJXDJSTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WQJXDJSTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numLabel.text = [NSString stringWithFormat:@"第%@期",info.good_period];
        CGSize size = [cell.numLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        cell.numLabelWidth.constant = size.width;
        return cell;
    }else{
        WQJXListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"WQJXListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WQJXListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.photoImage.tag = indexPath.section;
        cell.photoImage.userInteractionEnabled = YES;
        cell.photoImage.tag = indexPath.section;
        cell.photoImage.layer.masksToBounds = YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
        [cell.photoImage addGestureRecognizer:tap];
        
        cell.numLabel.text = [NSString stringWithFormat:@"第%@期",info.good_period];
        CGSize size = [cell.numLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        cell.numlabelWidth.constant = size.width;
        cell.timeLabel.text = [NSString stringWithFormat:@"[揭晓时间：%@]",info.lottery_time];
        
        if(info.win_user.nick_name.length > 0 && ![info.win_user.nick_name isEqualToString:@"<null>"])
        {
            cell.nameLabel.text = info.win_user.nick_name;
        }else{
            cell.nameLabel.text = @"--";
        }
        
        size = [cell.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        cell.namaLabelWidth.constant  = size.width;
        
        if(info.win_user.user_ip_address.length > 0 && ![info.win_user.user_ip_address isEqualToString:@"<null>"])
        {
            cell.addressLabel.text = [NSString stringWithFormat:@"(%@)",info.win_user.user_ip_address];
        }else{
            cell.addressLabel.text = @"";
        }
        
        
        cell.hjIDLabel.text = [NSString stringWithFormat:@"%@(唯一不变标识)",info.win_user.id];
        cell.xyhmLabel.text = info.win_num;
        cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.win_user.fight_time];
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.win_user.user_header] placeholderImage:PublicImage(@"default_head")];
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if(![info.status isEqualToString:@"倒计时"])
    {
        GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetSourceData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetSourceData];
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


@end
