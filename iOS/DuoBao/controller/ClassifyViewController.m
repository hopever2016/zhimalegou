//
//  ClassifyViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClsaafilyTableViewCell.h"
#import "SearchGoodsViewController.h"
#import "GoodsListViewController.h"
#import "GoodsTypeInfo.h"
#import "QingDanViewController.h"

@interface ClassifyViewController ()
{
    NSMutableArray *dataSourceArray;
}
@property (nonatomic, strong) SearchGoodsViewController *searchViewController;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self httpGetTypeData];
//    [self setRightBarButtonItem:@"购物车"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.searchViewController != nil) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.searchViewController = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Search view controller is not need navigation bar
    if (self.searchViewController != nil) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initVariable
{
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"分类浏览";
    
    _searchButton.layer.masksToBounds =YES;
    _searchButton.layer.cornerRadius = 5;
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
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

- (void)rightBarButtonItemAction
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    QingDanViewController *vc = [[QingDanViewController alloc]initWithNibName:@"QingDanViewController" bundle:nil];
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http

- (void)httpGetTypeData
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ClassifyViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_GetGoodsType
                      success:^(NSDictionary *resultDic){
                          [HUD hide:YES];
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                          }
                      }fail:^(NSString *decretion){
                          [HUD hide:YES];
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsTypeList"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsTypeInfo *info = [dic objectByClass:[GoodsTypeInfo class]];
            [dataSourceArray addObject:info];
        }
    }
    else
    {
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }

    [_myTableView reloadData];
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSearchButtonAction:(id)sender
{
    SearchGoodsViewController *vc = [[SearchGoodsViewController alloc]initWithNibName:@"SearchGoodsViewController" bundle:nil];
    self.searchViewController = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return 35;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < 1) {
        
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 35);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 35)];
    contentView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:contentView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 97,35)];
    titleLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
    titleLabel.text = @"分类浏览";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titleLabel];
    
    return bgView;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClsaafilyTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ClsaafilyTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClsaafilyTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.iconImage.layer.masksToBounds =YES;
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
    
    if (indexPath.section == 0) {
        cell.lineLabel.hidden = YES;
        cell.iconImage.hidden = NO;
        cell.iconImage.image = PublicImage(@"cont_class");
        cell.titleLabel.text = @"全部商品";
    }else
    {
        cell.lineLabel.hidden = NO;
        
        GoodsTypeInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:info.goods_type_header] placeholderImage:nil];
        
        cell.titleLabel.text = info.goods_type_name;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GoodsListViewController *vc = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
    if (indexPath.section == 1) {
        GoodsTypeInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        vc.typeId = info.id;
        vc.typeName = info.goods_type_name;
       
    }else{
        vc.typeId = @"";
        vc.typeName = @"全部商品";
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
