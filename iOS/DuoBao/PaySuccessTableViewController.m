//
//  PaySuccessTableViewController.m
//  DuoBao
//
//  Created by clove on 4/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySuccessTableViewController.h"
#import "ServerProtocol.h"
#import "DuoBaoRecordViewController.h"
#import "ProfileTableViewController.h"

@interface PaySuccessTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (strong, nonatomic) IBOutlet UIView *payFailureView;
@property (weak, nonatomic) IBOutlet UIButton *payFailureButton;

@end

@implementation PaySuccessTableViewController

- (void)dealloc
{
    XLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

+ (PaySuccessTableViewController *)createWithData:(NSDictionary *)dictionary
{
    PaySuccessTableViewController *vc = [[PaySuccessTableViewController alloc] initWithNibName:@"PaySuccessTableViewController" bundle:nil];
    vc.data = dictionary;
    
    
    NSString *result = [dictionary objectForKey:@"result"];
    NSString *title = @"支付成功";
    NSString *prompt = @"请等待系统为您揭晓";
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        title = @"支付成功";
        prompt = @"请等待系统为您揭晓";
        
        int payCrowdfundingCoin = [[dictionary objectForKey:@"payCrowdfundingCoin"] intValue];
        int payThriceCoin = [[dictionary objectForKey:@"payThriceCoin"] intValue];
        
        [ShareManager shareInstance].userinfo.user_money -= payCrowdfundingCoin;
        [ShareManager shareInstance].userinfo.happy_bean_num -= payThriceCoin;
    }
    
    
    [Tool autoLoginSuccess:^(NSDictionary *success) {
    } fail:^(NSString *failure) {
    }];

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"支付结果";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    NSString *result = [_data objectForKey:@"result"];
    NSString *title = @"支付成功";
    NSString *prompt = @"请等待系统为您揭晓";
    
    if ([result isEqualToString:@"success"]) {
        title = @"支付成功";
        prompt = @"请等待系统为您揭晓";
    }
    
    
    if ([result isEqualToString:@"timeout"]) {
        title = @"支付成功";
        prompt = @"请到夺宝记录查看夺宝详情";
    }
    
    _promptLabel.text = prompt;
    
    if ([result isEqualToString:@"failure"]) {
        self.tableView.tableHeaderView = _payFailureView;
    }
    
    [self leftNavigationItem];
    
    
    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
    UIButton *button = _leftButton;
    button.layer.cornerRadius = button.height * 0.1;
    button.layer.borderWidth = 1;
    button.layer.borderColor = redColor.CGColor;
    
    button = _rightButton;
    button.layer.cornerRadius = button.height * 0.1;

    button = _payFailureButton;
    button.layer.cornerRadius = button.height * 0.1;
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
    [self leftButtonAction:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)dataArray:(NSDictionary *)dictionary
{
    NSMutableArray *array = [NSMutableArray array];
    UIColor *darkColor = [UIColor colorFromHexString:@"474747"];
    UIColor *grayColor = [UIColor colorFromHexString:@"a3a3a3"];
    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
    UIFont *font = [UIFont systemFontOfSize:12];
    UIFont *fontBig = [UIFont systemFontOfSize:13];
    
    
    int crowdfundingCardinalNumber = [[dictionary objectForKey:@"crowdfundingCardinalNumber"] intValue] != 0 ?: 1;
    int purchasedCrowdfundingCoin = [[dictionary objectForKey:@"purchasedCrowdfundingCoin"] intValue];
    int purchasedCrowdfundingTimes = purchasedCrowdfundingCoin / crowdfundingCardinalNumber;
    int payCNY = [[dictionary objectForKey:@"payCNY"] intValue];
    int payCrowdfundingCoin = [[dictionary objectForKey:@"payCrowdfundingCoin"] intValue];
    int payThriceCoin = [[dictionary objectForKey:@"payThriceCoin"] intValue];
    int costedCrowdfundingCoin = [[dictionary objectForKey:@"costedCrowdfundingCoin"] intValue];
    int costedThriceCoin = [[dictionary objectForKey:@"costedThriceCoin"] intValue];
    
    
    // 共计
    NSString *str = [NSString stringWithFormat:@"共计:"];
    if (payCNY > 0) {
        str = [str stringByAppendingFormat:@"  %d元", payCNY];
    }
    if (costedCrowdfundingCoin > 0) {
        str = [str stringByAppendingFormat:@"  %d夺宝币", costedCrowdfundingCoin];
    }
    if (costedThriceCoin > 0) {
        str = [str stringByAppendingFormat:@"  %d欢乐豆", costedThriceCoin];
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:darkColor, NSFontAttributeName:fontBig}];
    NSDictionary *dict = @{@"title":attr1};
    [array addObject:dict];
    
    
    // 夺宝币
    NSString *goosTitle = [ServerProtocol periodAndGoodsName:dictionary];
    NSString *detail = [NSString stringWithFormat:@"%d人次", purchasedCrowdfundingTimes];
    attr1 = [[NSMutableAttributedString alloc] initWithString:goosTitle attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
    dict = @{@"title":attr1, @"detail":attr2};
    [array addObject:dict];

    
    // 欢乐豆
    NSString *title = nil;
    NSArray *thriceArray = [dictionary objectForKey:@"thriceArray"];
    for (NSDictionary *thriceDict in thriceArray) {
        NSString *type = [thriceDict objectForKey:@"type"];
        NSNumber *count = [thriceDict objectForKey:@"count"];
        
        if ([type hasPrefix:@"1"]) {
            type = @"147";
        }
        if ([type hasPrefix:@"2"]) {
            type = @"258";
        }
        if ([type hasPrefix:@"3"]) {
            type = @"369";
        }
        
        NSString *title = [NSString stringWithFormat:@"三赔玩法%@", type];
        detail = [NSString stringWithFormat:@"%@欢乐豆", count];
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }
    
    
    // 返回夺宝币
    int unusedThriceCoint = [[dict objectForKey:@"unusedThriceCoint"] intValue];
    if (unusedThriceCoint > 0) {
        NSString *reason = [dict objectForKey:@"unusedCrowdfundingReason"];
        title = [NSString stringWithFormat:@"返回夺宝币 %@", reason];
        detail = [NSString stringWithFormat:@"%d夺宝币", unusedThriceCoint];
        
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }
    
    
    // 返回欢乐豆
    int unusedCrowdfunding = [[dict objectForKey:@"unusedCrowdfunding"] intValue];
    if (unusedCrowdfunding > 0) {
        title = [NSString stringWithFormat:@"返回欢乐豆 本期已结束"];
        detail = [NSString stringWithFormat:@"%d欢乐豆", unusedCrowdfunding];
        
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }

    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButtonAction:(id)sender {
    
    [GA reportEventWithCategory:kGACategoryPay
                         action:kGAAction_pay_result_continue_buy_tap
                          label:nil
                          value:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)rightButtonAction:(id)sender {
    
    [GA reportEventWithCategory:kGACategoryPay
                         action:kGAAction_pay_result_lookup_record_tap
                          label:nil
                          value:nil];
//    
//    DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc]initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    UITabBarController *rootViewController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *tempNV = (UINavigationController *)rootViewController.selectedViewController;
    UIViewController *topVC = tempNV.topViewController;
    if ([topVC isMemberOfClass:[DuoBaoRecordViewController class]]) {
        return;
    }
    
    [rootViewController.navigationController popToRootViewControllerAnimated:NO];
    [rootViewController setSelectedIndex:3];
    
    for (UINavigationController *nv in rootViewController.viewControllers) {
        [nv popToRootViewControllerAnimated:NO];
    }
    
    UINavigationController *nv = (UINavigationController *)rootViewController.selectedViewController;
    ProfileTableViewController *vc = (ProfileTableViewController *)nv.viewControllers.firstObject;
    if ([vc isMemberOfClass:[ProfileTableViewController class]]) {
        [vc.navigationController popToRootViewControllerAnimated:NO];
        [vc pushBettingRecordViewController];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"]) {
        NSArray *array = [self dataArray:_data];
        number = array.count;
    }

    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    NSArray *array = [self dataArray:_data];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    NSAttributedString *title = [dict objectForKey:@"title"];
    NSAttributedString *detail = [dict objectForKey:@"detail"];
    
    cell.textLabel.text = @" ";
    
    CGFloat height = 22;
    CGFloat width = ScreenWidth - 30* 2 - 80;
    if (indexPath.row == 0) {
        height = 31;
        width = 300;
    }
    
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, width, height)];
    lblTitle.attributedText = title;
    [cell.contentView addSubview:lblTitle];
    
    lblTitle= [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, height)];
    lblTitle.attributedText = detail;
    lblTitle.right = ScreenWidth - 30;
    lblTitle.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:lblTitle];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 22;
    if (indexPath.row == 0) {
        height = 31;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        height = 100;
    }

    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    UIView *view = nil;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        
        view = _tableFooterView;
    }
    
    return view;
}


@end
