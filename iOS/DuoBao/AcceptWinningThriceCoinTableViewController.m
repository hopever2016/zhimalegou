//
//  AcceptWinningThriceCoinTableViewController.m
//  DuoBao
//
//  Created by clove on 4/18/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "AcceptWinningThriceCoinTableViewController.h"
#import "ThriceResultView.h"
#import "ZJRecordListInfo.h"
#import "BottomToolBar.h"
#import "FAQTableViewController.h"

@interface AcceptWinningThriceCoinTableViewController ()
@property (nonatomic, strong) ThriceResultView *thriceResultView;

@end

@implementation AcceptWinningThriceCoinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"领豆豆";
    [self leftNavigationItem];
    [self setRightBarButtonItem:@"使用规则"];
    
    [self addBottomToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
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

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemAction
{
    FAQTableViewController *vc = [[FAQTableViewController alloc] initWithNibName:@"FAQTableViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonAction
{
    NSString *orderID = _data.thriceOrderID;
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak typeof(self) wself = self;
    
    int winningThriceCoin = [_data.get_beans intValue];
    
    [helper getWinningThriceCoin:orderID
                         success:^(NSDictionary *data) {
                             
                             wself.data.thriceOrderStatus = @"已发货";
                             [ShareManager shareInstance].userinfo.happy_bean_num += winningThriceCoin;
                             [wself.tableView reloadData];
                             
                         } failure:^(NSString *description) {
                             
                         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.textColor = [UIColor defaultColor474747];
        cell.textLabel.text = @"本期三赔赢得";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
        
        NSString *winningThriceCoinStr = _data.get_beans;
        
        UIView *view = [Tool thriceCoinViewWithStr:winningThriceCoinStr fontSize:14 textColor:redColor];
        view.centerY = cell.height/2;
        view.left = 125;
        [cell.contentView addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"立即领取" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor whiteColor] darkerColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[[UIColor whiteColor] darkerColor] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor defaultRedColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.height = 26;
        button.width = 26*3;
        button.right = ScreenWidth - 16;
        button.centerY = cell.height/2;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.height * 0.1;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        if ([_data hasAcceptWinningThirceCoin] == NO) {
            [cell.contentView addSubview:button];
        }
        
    } else {
        
        _thriceResultView = [[ThriceResultView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115) ];
        [cell.contentView addSubview:_thriceResultView];
        
        ZJRecordListInfo *data = _data;
        NSString *prizeNumber = [data thricePrizeNumber];
        NSArray *thriceBettingArray = [ServerProtocol thriceBettingArrayWithData:data.sanpeiRecordList];
        
        
        PrizeType prizeType = PrizeTypeNone;
        if ([data hasAcceptWinningThirceCoin]) {
            prizeType = PrizeTypeAccept;
        }
        
        [_thriceResultView reloadWithPrizeNumber:prizeNumber bettingArray:thriceBettingArray prizeType:prizeType];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    
    if (indexPath.row == 1) {
        height = 115 - 2;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    label.textColor = [UIColor colorFromHexString:@"c2c2c2"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    
    int value = [ShareManager shareInstance].configure.exchangeRate * 100;
    label.text = [NSString stringWithFormat:@"欢乐豆可抵%d%%啦！", value];
    
    return label;
}

- (void)addBottomToolBar
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BottomToolBar" owner:nil options:nil];
    BottomToolBar *view = [nib lastObject];
    view.bottom = self.view.height;
    view.width = self.view.width;
    
//    [view configureReviewButton];
    [view.rightButton addTarget:self action:@selector(rightBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    view.titleLabel.text = @"手气不错，要乘胜追击哦！";
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_thrice_coin_two"]];
//    imageView.centerY = view.height/2;
//    imageView.left = view.titleLabel.left;
//    [view addSubview:imageView];
//    
//    view.titleLabelLeadingConstraint.constant += imageView.right - 10;
    
    [self.view addSubview:view];
}

- (void)rightBottomButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController setSelectedIndex:0];
}


@end
