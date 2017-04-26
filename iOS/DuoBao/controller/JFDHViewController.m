//
//  JFDHViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "JFDHViewController.h"
#import "JFHeadTableViewCell.h"
#import "JFTitleIconTableViewCell.h"
#import "PointListInfo.h"
#import "SafariViewController.h"
#import "ALiPayBangViewController.h"

@interface JFDHViewController ()<JFHeadTableViewCellDelegate>
{
    BOOL isClickDHMX;
    NSMutableArray *dataSourceArray;
    UIButton *inComeBtn;
    UILabel *incomeLine;
    UIButton *dhBtn;
    UILabel *dhLine;
    int pageNum;
    NSString *sxfValue;
    NSString *zrsyStr;
    NSMutableArray *valueArray;
    NSString *selectExchangeValue;
}

@end

@implementation JFDHViewController

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
    if(_isTiXian)
    {
       self.title = @"积分提现";
        valueArray = [NSMutableArray arrayWithObjects:@"10", @"20",@"50",@"100",@"300",@"500",nil];
    }else{
       self.title = @"积分兑换";
       valueArray = [NSMutableArray arrayWithObjects:@"5", @"10",@"30",@"50",@"100",@"300",nil];
    }
    selectExchangeValue = [valueArray objectAtIndex:0];
    
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


- (void)updateHeadView
{
    [inComeBtn setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    incomeLine.hidden = YES;
    [dhBtn setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    dhLine.hidden = YES;
    
    if (isClickDHMX) {
        [dhBtn setTitleColor:[UIColor colorWithRed:253.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
        dhLine.hidden = NO;
    }else{
        [inComeBtn setTitleColor:[UIColor colorWithRed:253.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
        incomeLine.hidden = NO;
    }
    
}


#pragma mark - http

- (void)getUserInfo
{
    __weak JFDHViewController *weakSelf = self;
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                                  [weakSelf.myTableView reloadData];
                              }else{
                                  [Tool showPromptContent:@"获取用户信息失败" onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:decretion onView:self.view];
                          }];
}

- (void)httpGetPointListInfo
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak JFDHViewController *weakSelf = self;
    NSString *typeStr = @"1";
    if (isClickDHMX) {
        typeStr = @"2";
    }
    [helper getPointDetailInfoWithUserId:[ShareManager shareInstance].userinfo.id
                                    type:typeStr
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
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"scoreOrmoneyList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            PointListInfo *info = [dic objectByClass:[PointListInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 30) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }
    
    
    [_myTableView reloadData];
}

- (void)httpSXF
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak JFDHViewController *weakSelf = self;
    [helper getPointDHWithUserId:[ShareManager shareInstance].userinfo.id
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadSXFResult:resultDic];
                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                          }
                      }fail:^(NSString *decretion){
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];
}

- (void)handleloadSXFResult:(NSDictionary *)resultDic
{
    
    sxfValue = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"poundage"]];
    zrsyStr = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"last_date_score"]];
    [_myTableView reloadData];
}

- (void)httpExchangePoint:(NSString *)pointValue
{
    NSString *typeStr = nil;
    if (_isTiXian) {
        typeStr = @"real";
    }else{
        typeStr = @"virtual";
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"申请中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak JFDHViewController *weakSelf = self;
    [helper putPointExchangeApplyWithUserId:[ShareManager shareInstance].userinfo.id
                              exchange_type:typeStr
                                  pay_score:pointValue
                                    success:^(NSDictionary *resultDic){
                                         [HUD hide:YES];
                                        [weakSelf handleloadExchangePointResult:resultDic];
                                    }fail:^(NSString *decretion){
                                         [HUD hide:YES];
                                        [Tool showPromptContent:@"网络出错了" onView:self.view];
                                    }];
}

- (void)handleloadExchangePointResult:(NSDictionary *)resultDic
{
    
    if ([[resultDic objectForKey:@"status"] integerValue] == 2) {
        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
        [self performSelector:@selector(pushALiPayBangView) withObject:nil afterDelay:1.5];
        
    }else if ([[resultDic objectForKey:@"status"] integerValue] == 0){
        [Tool showPromptContent:@"提交申请成功" onView:self.view];
        [_myTableView.mj_header beginRefreshing];
    }else{
        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
    }
}

- (void)pushALiPayBangView
{
    ALiPayBangViewController *vc = [[ALiPayBangViewController alloc]initWithNibName:@"ALiPayBangViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickInComeButtonAction:(id)sender
{
    isClickDHMX = NO;
    [self updateHeadView];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickDHMXButtonAction:(id)sender
{
    isClickDHMX = YES;
    [self updateHeadView];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickHelpButtonAction:(id)sender
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"帮助";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_HelpUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSureButtonAction:(id)sender
{
    [self httpExchangePoint:[NSString stringWithFormat:@"%d",[selectExchangeValue intValue]*100]];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
    {
        return 36;
        
    }else{
        
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 1) {
        
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 36);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 35, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [bgView addSubview:lineview];
    
    inComeBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, FullScreen.size.width/2, 35)];
    [inComeBtn setTitleColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [inComeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [inComeBtn setTitle:@"积分收益明细" forState:UIControlStateNormal];
    inComeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [inComeBtn addTarget:self action:@selector(clickInComeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:inComeBtn];
    
    incomeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, FullScreen.size.width/2, 2)];
    incomeLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1];
    [bgView addSubview:incomeLine];
    
    dhBtn =[[UIButton alloc]initWithFrame:CGRectMake(FullScreen.size.width/2, 0, FullScreen.size.width/2, 35)];
    [dhBtn setTitleColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [dhBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    dhBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [dhBtn setTitle:@"积分兑换明细" forState:UIControlStateNormal];
    [dhBtn addTarget:self action:@selector(clickDHMXButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:dhBtn];
    
    dhLine = [[UILabel alloc]initWithFrame:CGRectMake(FullScreen.size.width/2, 34, FullScreen.size.width/2, 2)];
    dhLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1];
    [bgView addSubview:dhLine];
    [self updateHeadView];
    return bgView;
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return dataSourceArray.count+1;
    }
    
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 272;
    }else{
        if (indexPath.row == 0) {
            return 36;
        }
        return 42;
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JFHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"JFHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JFHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            [cell initValueCollectView];
            cell.collectView.delegate = cell;
            cell.collectView.dataSource = cell;
            cell.delegate = self;
            cell.syLabeWidth.constant = (FullScreen.size.width-24)/2;
            
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.valueArray = valueArray;
        
        [cell.collectView reloadData];
        
        [cell.helpButton addTarget:self action:@selector(clickHelpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.sureButton.layer.masksToBounds =YES;
        cell.sureButton.layer.cornerRadius = 3;
        [cell.sureButton addTarget:self action:@selector(clickSureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_isTiXian) {
            cell.warnLabel.text = [NSString stringWithFormat:@"   选择兑换金额(100积分＝1元(手续费:%.0f％))",[sxfValue doubleValue]*100];
            [cell.sureButton setTitle:@"立即提现" forState:UIControlStateNormal];
        }else{
            cell.warnLabel.text = @"   选择兑换金额(100积分＝1夺宝币)";
            [cell.sureButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        }
        
        
        UserInfo *info = [ShareManager shareInstance].userinfo;
        cell.moneyLabel.text = [NSString stringWithFormat:@"%ld",(long)info.user_score];
        cell.ljsyLabel.text = [NSString stringWithFormat:@"累计收益: %ld",(long)info.user_score_all];
        if([zrsyStr isEqualToString:@"<null>"] || !zrsyStr)
        {
            cell.zrsyLabel.text = [NSString stringWithFormat:@"昨日收益: 0"];
        }else{
            cell.zrsyLabel.text = [NSString stringWithFormat:@"昨日收益: %@",zrsyStr];
        }
        
        
        return cell;
    }else{
        
        JFTitleIconTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"JFTitleIconTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JFTitleIconTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleWidth.constant = FullScreen.size.width/3;
        
        if (indexPath.row == 0) {
            cell.titleOneLabel.textColor = [UIColor lightGrayColor];
            cell.titleTwoLabel.textColor = [UIColor lightGrayColor];
            cell.titleThreeLabel.textColor = [UIColor lightGrayColor];
            
            if (isClickDHMX) {
                cell.titleOneLabel.text = @"时间";
                cell.titleTwoLabel.text = @"金额";
                cell.titleThreeLabel.text = @"状态";
            }else{
                cell.titleOneLabel.text = @"时间";
                cell.titleTwoLabel.text = @"来源";
                cell.titleThreeLabel.text = @"积分";
            }
            
        }else{
            cell.titleOneLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
            cell.titleTwoLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
            cell.titleThreeLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
            
            PointListInfo *info = [dataSourceArray objectAtIndex:indexPath.row-1];
            cell.titleOneLabel.text = info.create_time;
            [Tool setFontSizeThatFits:cell.titleOneLabel];
            cell.titleTwoLabel.text = info.value1;
            [Tool setFontSizeThatFits:cell.titleTwoLabel];
            cell.titleThreeLabel.text = info.value2;
            [Tool setFontSizeThatFits:cell.titleThreeLabel];
        }
        
        return cell;
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - JFHeadTableViewCellDelegate 

- (void)selectJFValueIndex:(NSInteger)index value:(NSString *)valueStr
{
    selectExchangeValue = valueStr;
}


#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetPointListInfo];
        [weakSelf getUserInfo];
        [weakSelf httpSXF];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetPointListInfo];
        
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
