//
//  MessageListViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListTableViewCell.h"
#import "SystemListInfo.h"
#import "SafariViewController.h"

@interface MessageListViewController ()
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation MessageListViewController

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
    self.title = @"我的消息";
    pageNum = 1;
    dataSourceArray = [NSMutableArray array];
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

- (void)httpGetSystemMessgae
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak MessageListViewController *weakSelf = self;
    
    [helper getSystemMessageWithPageNum:[NSString stringWithFormat:@"%d",pageNum]
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
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"messageList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            SystemListInfo *info = [dic objectByClass:[SystemListInfo class]];
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



#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MessageListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    SystemListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = info.title;
    cell.timeLabel.text = info.create_time;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SystemListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.urlStr = info.href;
    vc.title = @"消息详情";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetSystemMessgae];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetSystemMessgae];
        
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
