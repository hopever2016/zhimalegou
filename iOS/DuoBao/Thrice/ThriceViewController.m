//
//  ThriceViewController.m
//  DuoBao
//
//  Created by clove on 3/29/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ThriceViewController.h"
#import "LDProgressView.h"
#import "ServerProtocol.h"
#import "ThriceActivityView.h"
#import "PurchaseNumberViewController.h"
#import "PayTableViewController.h"
#import "SafariViewController.h"

@interface ThriceViewController ()<PurchaseNumberViewControllerDelegate>
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) ThriceActivityView *activityView;

@end

@implementation ThriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"三赔";
    
    [self initRefreshTopView];
    
    [self autoRefreshTop];
    
    [self addBottomButton];
    
    [self setLeftBarButtonItemArrow];
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ThriceActivityView" owner:nil options:nil] firstObject];
    self.tableView.tableHeaderView = view;
    _activityView = (ThriceActivityView *)view;
    [_activityView.lookupRuleButton addTarget:self action:@selector(lookupRuleAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    _activityView.height = 1299 * UIAdapteRate;
    [self.tableView reloadData];
}

- (void)leftBarItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(leftBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lookupRuleAction:(id)sender {
    
    SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"计算详情";
    
    NSString *serverPrefix = URL_Server;
    if ([ShareManager shareInstance].isInReview == YES) {
        serverPrefix = URL_ServerTest;
    }
    
    NSString *goods_fight_id = [_data objectForKey:@"id"];
    vc.urlStr = [NSString stringWithFormat:@"%@%@goods_fight_id=%@", serverPrefix, Wap_JSXQ, goods_fight_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [_activityView reloadWithData:data];
}

- (void)confirmButtonAction
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    // 缓存红包
    [[ShareManager shareInstance] refreshCoupons];
    
    PurchaseNumberViewController *vc = [[PurchaseNumberViewController alloc] initWithNibName:@"PurchaseNumberViewController" bundle:nil];
    vc.delegate = self;
    vc.data = _data;
//    [vc reloadWithData:_data];

    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ([self.navigationController.viewControllers.firstObject isKindOfClass:[self class]]) {
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - PurchaseNumberViewControllerDelegate

- (void)purchaseNumberDidSelected:(NSDictionary *)bettingData
{
    if (_data) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_data];
        
        if (bettingData) {
            [dict addEntriesFromDictionary:bettingData];
            
            PayTableViewController *vc = [PayTableViewController createWithData:dict];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - RefreshControlDelegate

- (void)refreshTopStartAnimating
{
    [self getThriceGoods];
}

#pragma mark - Http

- (void)getThriceGoods
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak typeof(self) wself = self;

    [helper getThriceGoods:^(NSDictionary *data) {
        
        NSLog(@"%@", data);
        wself.data = data;
        [wself refreshStopAnimatingTop];
        
    } failure:^(NSString *description) {
        
        [wself refreshStopAnimatingTop];
    }];
}

#pragma mark - 

- (void)addBottomButton
{
    float height = 60;
    float top = 5;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 64 - height, self.view.width, height)];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.backgroundColor = [UIColor colorFromHexString:@"900d1d"];
    imageView.alpha = 0.9;
    
    UIImage *image = [UIImage imageNamed:@"purchase_button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.top = top;
    button.centerX = imageView.centerX;
    
    [view addSubview:imageView];
    [view addSubview:button];
    
    [self.view addSubview:view];
}





@end
