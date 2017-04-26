//
//  CouponsViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponsListTableViewCell.h"
#import "ExchangeCouponsViewController.h"
#import "CouponsListInfo.h"

@interface CouponsViewController ()<ExchangeCouponsViewControllerDelegate>
{
    BOOL isSelectDie;
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self setTabelViewRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    pageNum = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"红包";
    _buttonWidth.constant = FullScreen.size.width/2;
    [self updateHeadButtonStatue];
    
    dataSourceArray = [NSMutableArray array];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectCoupon:)])
    {
        self.title = @"选择红包";
        self.myTableView.tableHeaderView = nil;
        self.tableHeaderViewHeightConstraint.constant = 0;
        self.tableHeaderView.hidden = YES;
    }
}

- (void)updateHeadButtonStatue
{
    [_ksyButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_dieButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    _ksyLine.hidden = YES;
    _dieLine.hidden = YES;
    
    if (isSelectDie ) {
        [_dieButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
        _dieLine.hidden = NO;
        
    }else{
        [_ksyButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
        _ksyLine.hidden = NO;
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
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"兑换" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:16];
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

#pragma mark - http

- (void)httpCouponsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak CouponsViewController *weakSelf = self;
    
    NSString *typeStr = @"1";
    if (isSelectDie) {
        typeStr = @"2";
    }
    
    [helper getCouponsListWithUserId:[ShareManager shareInstance].userinfo.id
                                type:typeStr
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
                                success:^(NSDictionary *resultDic){
                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleloadFriendsListResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}

- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            CouponsListInfo *info = [dic objectByClass:[CouponsListInfo class]];
            
            // 是否设置过滤条件
            if (_conditionMax > 0) {
                
                // 满足过滤条件则显示
                int value = info.ticket_condition;
                if (value <= _conditionMax) {
                    
                    if (isSelectDie && [info isThriceCoupon]) {
                        
                    } else {
                        [dataSourceArray addObject:info];
                    }
                }
            } else{
                
                if (isSelectDie && [info isThriceCoupon]) {
                    
                } else {
                    [dataSourceArray addObject:info];
                }
            }
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



#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    ExchangeCouponsViewController *vc = [[ExchangeCouponsViewController alloc]initWithNibName:@"ExchangeCouponsViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickKSYButtonAction:(id)sender
{
    isSelectDie = NO;
    [self updateHeadButtonStatue];
    [_myTableView.mj_header beginRefreshing];
}
- (IBAction)clickDieButtonAction:(id)sender
{
    isSelectDie = YES;
    [self updateHeadButtonStatue];
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark - ExchangeCouponsViewControllerDelegate

- (void)exchangeCouponsSuccess
{
    [self clickKSYButtonAction:nil];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CouponsListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    CouponsListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.0f",info.ticket_value];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"有效期至%@",info.valid_date];
    cell.detailLabel.text = [NSString stringWithFormat:@"满%.0f元使用",info.ticket_condition];
    
    if(isSelectDie)
    {
        cell.titleLabel.text = info.ticket_name;
        cell.bgImage.image = [UIImage imageNamed:@"coupon_gray_bg"];
    }else{
        cell.titleLabel.text = info.ticket_name;
        cell.bgImage.image = [UIImage imageNamed:@"coupon_red_bg"];
    }
    
    [cell relaodWithData:info];

    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([self.delegate respondsToSelector:@selector(didSelectCoupon:)])
    {
        CouponsListInfo *selectedCoupon = [dataSourceArray objectAtIndex:indexPath.row];
        [self.delegate didSelectCoupon:selectedCoupon];
        [self.navigationController popViewControllerAnimated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpCouponsList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpCouponsList];
        
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
