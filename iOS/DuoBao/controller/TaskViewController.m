//
//  TaskViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskListTableViewCell.h"
#import "TaskListInfo.h"
#import "TaskRewardRecordViewController.h"

@interface TaskViewController ()
{
    NSMutableArray *scoreArray;
    NSMutableArray *moneyArray;
}

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"任务大厅";
    scoreArray = [NSMutableArray array];
    moneyArray = [NSMutableArray array];
    
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
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,75, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"奖励记录" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,8)];
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

- (void)httpGetTaskList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TaskViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_TaskList
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
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSLog(@"%@",resultDic);
    if (scoreArray.count > 0) {
        [scoreArray removeAllObjects];
    }
    if (moneyArray.count > 0) {
        [moneyArray removeAllObjects];
    }
    
    NSArray *resoureArray = [[resultDic objectForKey:@"data"] objectForKey:@"taskScoreList"];
    if (resoureArray && resoureArray.count > 0 )
    {
        for (NSDictionary *dic in resoureArray)
        {
            TaskListInfo *info = [dic objectByClass:[TaskListInfo class]];
            [scoreArray addObject:info];
        }
        
    }

    resoureArray = [[resultDic objectForKey:@"data"] objectForKey:@"taskMoneyList"];
    if (resoureArray && resoureArray.count > 0 )
    {
        for (NSDictionary *dic in resoureArray)
        {
            TaskListInfo *info = [dic objectByClass:[TaskListInfo class]];
            [moneyArray addObject:info];
        }
        
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
    TaskRewardRecordViewController *vc = [[TaskRewardRecordViewController alloc]initWithNibName:@"TaskRewardRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }else if (section == 1)
    {
        if (moneyArray.count > 0) {
            return 40;
        }else{
            return 0;
        }
    }else{
        if (scoreArray.count > 0) {
            return 40;
        }else{
            return 0;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1)
    {
        if (moneyArray.count == 0) {
            return nil;
        }
    }else if (section == 2){
        if (scoreArray.count == 0) {
            return nil;
        }
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    [bgView addSubview:lineview];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, FullScreen.size.width, 20)];
    
    switch (section) {
        case 0:
            nameLabel.text = @"玩转游戏";
            break;
        case 1:
            nameLabel.text = @"夺宝币任务";
            break;
        case 2:
            nameLabel.text = @"积分任务";
            break;
        default:
            break;
    }
    
    nameLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
   
    nameLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:nameLabel];
    
    return bgView;
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1)
    {
        return moneyArray.count;
    }else{
        return scoreArray.count;
    }
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0)
    {
        cell.photoImage.image = [UIImage imageNamed:@"cont_luckybig"];
        cell.titleLabel.text = @"幸运大转盘";
        cell.detailLabel.text = @"每天免费玩一次，惊喜大奖等着你";
    }
    else if(indexPath.section == 1)
    {
        TaskListInfo *info = [moneyArray objectAtIndex:indexPath.row];
        
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:PublicImage(@"defaultImage")];
        cell.photoImage.layer.masksToBounds =YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        cell.titleLabel.text = info.title;
        cell.detailLabel.text = info.remark;
        
        
    }else{
        TaskListInfo *info = [scoreArray objectAtIndex:indexPath.row];
        
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:PublicImage(@"defaultImage")];
        cell.photoImage.layer.masksToBounds =YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        cell.titleLabel.text = info.title;
        cell.detailLabel.text = info.remark;
    }
    
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
        [weakSelf httpGetTaskList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
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
