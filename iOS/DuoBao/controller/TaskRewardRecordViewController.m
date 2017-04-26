//
//  TaskRewardRecordViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "TaskRewardRecordViewController.h"
#import "JFTitleIconTableViewCell.h"
#import "PointListInfo.h"

@interface TaskRewardRecordViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNum;
    
}

@end

@implementation TaskRewardRecordViewController

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
    self.title = @"奖励记录";
    dataSourceArray = [NSMutableArray array];
    pageNum = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _iconWidth.constant = FullScreen.size.width/3;
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
- (void)httpGetPointListInfo
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TaskRewardRecordViewController *weakSelf = self;
    
    [helper getPointDetailInfoWithUserId:[ShareManager shareInstance].userinfo.id
                                    type:@"1"
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


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 42;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    cell.titleOneLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
    cell.titleTwoLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
    cell.titleThreeLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
    
    PointListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.titleOneLabel.text = info.create_time;
    [Tool setFontSizeThatFits:cell.titleOneLabel];
    cell.titleTwoLabel.text = info.value1;
    [Tool setFontSizeThatFits:cell.titleTwoLabel];
    cell.titleThreeLabel.text = info.value2;
    [Tool setFontSizeThatFits:cell.titleThreeLabel];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [weakSelf httpGetPointListInfo];
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
