//
//  InviteFriendsViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsHeadTableViewCell.h"
#import "FriendsInfo.h"
#import "FriendsInfoTableViewCell.h"
#import "UserViewController.h"

@implementation ServiceListInfo

@end

@interface InviteFriendsViewController ()
{
    NSInteger selectType;//1 一级 2 二级  3 三级
    UIButton *_yjButton;
    UIButton *_ejButton;
    UIButton *_sjButton;

    UILabel *_yjLine;
    UILabel *_ejLine;
    UILabel *_sjLine;
    
    NSString *allFriendsNum;
    NSString *yjFriendsNum;
    NSString *ejFriendsNum;
    NSString *sjFriendsNum;
    
    NSMutableArray *serverSourceArray;
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation InviteFriendsViewController

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
    self.title = @"邀请好友";
    pageNum = 1;
    serverSourceArray = [NSMutableArray array];
    dataSourceArray = [NSMutableArray array];
    selectType = 1;
}

- (void)leftNavigationItem
{
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

//- (void)setLeftBarButtonItemArrow
//{
//    if (self.navigationController == nil) {
//        return;
//    }
//    
//    self.navigationItem.hidesBackButton = YES;
//    
//    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil style:UIButtonTypeCustom target:self action:@selector(popNavigationItemAnimated:)];
//    //    self.navigationItem.backBarButtonItem = item;
//    
//    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-arrow-left-gray"]
//    //                                                                   style:UIBarButtonItemStyleBordered
//    //                                                                  target:self
//    //                                                                  action:@selector(leftBarButtonItemAction:)];
//    //
//    //    self.navigationItem.leftBarButtonItem = backButton;
//    
//    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
//    [leftItemControl addTarget:self.navigationController action:@selector(popNavigationItemAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
//    back.image = [UIImage imageNamed:@"nav_back.png"];
//    [leftItemControl addSubview:back];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
//}

- (void)updateHeadButtonStatue
{
    [_yjButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_ejButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_sjButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    _yjLine.hidden = YES;
    _ejLine.hidden = YES;
    _sjLine.hidden = YES;

    if (selectType == 1) {
        [_yjButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
        _yjLine.hidden = NO;
        
    }else if (selectType == 2){
        [_ejButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
        _ejLine.hidden = NO;
    }else{
        [_sjButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
        _sjLine.hidden = NO;
    }
    
    _sjLine.hidden = YES;

}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickYJButtonAction:(id)sender
{
    selectType = 1;
    [self updateHeadButtonStatue];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickEJButtonAction:(id)sender
{
    selectType = 2;
    [self updateHeadButtonStatue];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickSJButtonAction:(id)sender
{
    selectType = 3;
    [self updateHeadButtonStatue];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickInvitiveButtonAction:(id)sender
{
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"%@ - 最靠谱的众筹购物APP，一元购你所想！", bundleDisplayName];
    
    [ShareManager shareInstance].shareType = 3;
}

#pragma mark - http
- (void)httpBaseData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak InviteFriendsViewController *weakSelf = self;
    [helper getInviteFriendsInfoWithUserId:[ShareManager shareInstance].userinfo.id
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    allFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_all"]];
    yjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_one"]];
    ejFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_two"]];
    sjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_three"]];
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"serviceList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ServiceListInfo *info = [dic objectByClass:[ServiceListInfo class]];
            [serverSourceArray addObject:info];
        }
    }

    [_myTableView reloadData];
}

- (void)httpGetFriendsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak InviteFriendsViewController *weakSelf = self;
    
    [helper getFriendsByLevelWithUserId:[ShareManager shareInstance].userinfo.id
                                  level:[NSString stringWithFormat:@"%ld",(long)selectType]
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
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"friendsList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            FriendsInfo *info = [dic objectByClass:[FriendsInfo class]];
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
    
    int count = 2;
    
    _yjButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, FullScreen.size.width/count, 35)];
    [_yjButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_yjButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_yjButton setTitle:@"一级好友" forState:UIControlStateNormal];
    _yjButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_yjButton addTarget:self action:@selector(clickYJButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_yjButton];
    
    _yjLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, FullScreen.size.width/count, 2)];
    _yjLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1];
    [bgView addSubview:_yjLine];
    
    _ejButton =[[UIButton alloc]initWithFrame:CGRectMake(FullScreen.size.width/count, 0, FullScreen.size.width/count, 35)];
    [_ejButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_ejButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_ejButton setTitle:@"二级好友" forState:UIControlStateNormal];
    _ejButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ejButton addTarget:self action:@selector(clickEJButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_ejButton];
    
    _ejLine = [[UILabel alloc]initWithFrame:CGRectMake(FullScreen.size.width/count, 34, FullScreen.size.width/count, 2)];
    _ejLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1];
    [bgView addSubview:_ejLine];
    
    _sjButton =[[UIButton alloc]initWithFrame:CGRectMake(FullScreen.size.width/count*2, 0, FullScreen.size.width/count, 35)];
    [_sjButton setTitleColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_sjButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_sjButton setTitle:@"三级好友" forState:UIControlStateNormal];
    _sjButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sjButton addTarget:self action:@selector(clickSJButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:_sjButton];
    
    _sjLine = [[UILabel alloc]initWithFrame:CGRectMake(FullScreen.size.width/count*2, 34, FullScreen.size.width/count, 2)];
    _sjLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1];
//    [bgView addSubview:_sjLine];
    
    [self updateHeadButtonStatue];
    return bgView;
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return dataSourceArray.count;
    }
    
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 280;
    }else{
        return 95;
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        InviteFriendsHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.numLabelWidth.constant = (FullScreen.size.width-32)/2;
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (allFriendsNum) {
            cell.allFriendsNum.text = allFriendsNum;
        }
        
        if (yjFriendsNum) {
            cell.oneNumLabel.text = [NSString stringWithFormat:@"一级好友：%@",yjFriendsNum];
        }
        
        if (ejFriendsNum) {
            cell.twoNumLabel.text = [NSString stringWithFormat:@"二级好友：%@",ejFriendsNum];
        }
        
        if (sjFriendsNum) {
            cell.threeNumLabel.text = [NSString stringWithFormat:@"三级好友：%@",sjFriendsNum];
        }
        
        if (serverSourceArray.count > 0) {
            
            NSString *str1 = nil;
            NSString *str2 = nil;
            NSString *str3 = nil;
            NSString *str4 = nil;
            NSString *str5 = nil;
            NSString *str6 = nil;
            
            for (ServiceListInfo *info in serverSourceArray) {
                if ([info.type isEqualToString:@"divide_one"]) {
                    str1 = info.value;
                    
                }
                if ([info.type isEqualToString:@"divide_two"]) {
                    str2 = info.value;
                    
                }
                if ([info.type isEqualToString:@"divide_three"]) {
                    str3 = info.value;
                    
                }
                if ([info.type isEqualToString:@"buy_divide_one"]) {
                    str4 = info.value;
                    
                }
                if ([info.type isEqualToString:@"buy_divide_two"]) {
                    str5 = info.value;
                    
                }
                if ([info.type isEqualToString:@"buy_divide_three"]) {
                    str6 = info.value;
                    
                }
            }
            cell.warn1Label.text = [NSString stringWithFormat:@"夺宝提成%.2f％",[str4 doubleValue]*100.0];
            cell.warn2Label.text = [NSString stringWithFormat:@"夺宝提成%.2f％",[str5 doubleValue]*100.0];
            cell.warn3Label.text = [NSString stringWithFormat:@"夺宝提成%.2f％",[str6 doubleValue]*100.0];
        }
        
        cell.inviteButton.layer.masksToBounds =YES;
        cell.inviteButton.layer.cornerRadius = 3;
        [cell.inviteButton addTarget:self action:@selector(clickInvitiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        
        
        FriendsInfoTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsInfoTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsInfoTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        FriendsInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        
        cell.photoImage.layer.masksToBounds =YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
        if(info.nick_name.length > 0 && ![info.nick_name isEqualToString:@"<null>"])
        {
            cell.nameLabel.text = info.nick_name;
        }else{
            cell.nameLabel.text = @"";
        }
        
        cell.hyIdStr.text = info.id;
        cell.dbrcLabel.text = [NSString stringWithFormat:@"%@人次",info.fight_record_num];
        cell.timeLabel.text = info.create_time;
        return cell;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        FriendsInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        vc.userId = info.id;
        [self.navigationController pushViewController:vc animated:YES];
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
        [weakSelf httpGetFriendsList];
        [weakSelf httpBaseData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetFriendsList];
        
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
