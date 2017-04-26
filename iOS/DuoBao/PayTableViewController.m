//
//  PayTableViewController.m
//  DuoBao
//
//  Created by clove on 4/9/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PayTableViewController.h"
#import "PaySelectedController.h"
#import "AgreementCheckbox.h"
#import "FooterButtonView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YYKitMacro.h"
#import "SelectCouponsViewController.h"
#import "CouponsListInfo.h"
#import "CouponsViewController.h"
#import "PaySuccessTableViewController.h"
#import "FAQTableViewController.h"
#import "RechargeThriceTableViewController.h"


static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";

@interface PayTableViewController ()<SelectCouponsViewControllerDelegate>
@property (nonatomic, strong) PaySelectedController *paySelectedController;
@property (nonatomic, strong) AgreementCheckbox *agreementCheckbox;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, strong) CouponsListInfo *selectedCoupon;
@property (nonatomic) BOOL footerButtonHasTapped;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;


@end

@implementation PayTableViewController

- (void)dealloc
{
    XLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

+ (PayTableViewController *)createWithData:(NSDictionary *)data
{
    PayTableViewController *vc = [[PayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.data = data;
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付订单";
    [self leftNavigationItem];
    
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    [self addChildViewController:tableViewController];
    _paySelectedController = tableViewController;
    
    FooterButtonView *footerView = [[FooterButtonView alloc] initWithTitle:@"立即购买"];
    [footerView.button addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _footerButton = footerView.button;
    self.tableView.tableFooterView = footerView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    imageView.backgroundColor = [UIColor colorFromHexString:@"f4f4f4"];
    self.tableView.backgroundView = imageView;
    
    // 默认选择红包
    NSDictionary *dict = _data;
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    _selectedCoupon = [self chooseCouponWithBidding:crowdfundingBettingAmount];
    [self.tableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)footerButtonAction
{
    if (_footerButtonHasTapped) {
        return;
    }
    _footerButtonHasTapped = YES;
    
    NSDictionary *dict = _data;
    
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = [self amountThriceCoin:thriceArray];
    int rebatedCoinFromCoupon = _selectedCoupon.ticket_value;
    int exchangedCrowdfundingCoin = [self exchangeCorwdfundingCoin];
    int exchangedThriceCoin = exchangedCrowdfundingCoin * ThriceExchangeRate;
    int remainderCrowdfundingCoin = [ShareManager shareInstance].userinfo.user_money;
    int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
    int payCrowdfundingCoin = crowdfundingBettingAmount - exchangedCrowdfundingCoin - rebatedCoinFromCoupon;
    int payThriceCoin = thriceBettingCount + exchangedThriceCoin;
    int payCNY = [self payCNY];

    // 夺宝币余额中支付的部分
    int costedCrowdfundingCoin = payCrowdfundingCoin <= remainderCrowdfundingCoin ? payCrowdfundingCoin : remainderCrowdfundingCoin;
    int costedThriceCoin = [self costedThriceCoin];
    int costedCoinCNY = costedCrowdfundingCoin + costedThriceCoin / ThriceExchangeRate;
    
    NSString *goods_fight_ids = [dict objectForKey:@"id"];
    NSString *ticket_send_id = _selectedCoupon.id;
    NSString *order_type = @"订单";
    NSString *goods_ids = [dict objectForKey:@"good_id"];
    NSString *buyType = @"now";
    NSString *is_shop_cart = _is_shop_cart;
    
    
    if ([ShareManager shareInstance].isInReview == YES) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_fight_ids=%@&goods_buy_nums=%d&is_shop_cart=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, goods_fight_ids, crowdfundingBettingCount, @"n"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        _footerButtonHasTapped = NO;
        return;
    }
    
    if ([self hasEnoughCoins]) {
        
        [self purchaseGoodsFightID:goods_fight_ids
                             count:crowdfundingBettingCount
                    thricePurchase:thriceArray
                        isShopCart:is_shop_cart
                            coupon:ticket_send_id
                exchangedThriceCoin:exchangedThriceCoin
                           goodsID:goods_ids
                           buyType:buyType];
        
    } else {
                
        [self payWithGoods:goods_fight_ids
                 orderType:order_type
                     count:crowdfundingBettingCount
            thricePurchase:thriceArray
                    coupon:ticket_send_id
          costedThriceCoin:costedThriceCoin
       exchangedThriceCoin:exchangedThriceCoin
                totalPrice:payCNY
                  cutPrice:payCNY
           payCrowdfunding:costedCrowdfundingCoin
                isShopCart:is_shop_cart
                   goodsID:goods_ids];
    }
}

// 购买支付成功
- (void)purchaseSuccess:(NSDictionary *)data
{
    _footerButtonHasTapped = NO;
    [_loadingHUD hide:YES];
    
    NSMutableDictionary *dict = [self payResultsDictionray:data];
    [dict setObject:@"success" forKey:@"result"];
    
    PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:dict];
    [self.navigationController pushViewController:vc animated:YES];
}

// 支付成功，用户实际扣款，服务器响应超时
- (void)purchaseTimeout:(int)payCNY
{
    _footerButtonHasTapped = NO;
    [_loadingHUD hide:YES];

    NSMutableDictionary *dict = [self payResultsDictionray:nil];
    [dict setObject:@"timeout" forKey:@"result"];

    PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:dict];
    [self.navigationController pushViewController:vc animated:YES];
    
    XLog(@"%@", [dict my_description]);
}

// 购买失败
- (void)purchaseFailure:(NSString *)description
{
    _footerButtonHasTapped = NO;
    [_loadingHUD hide:YES];

    NSMutableDictionary *dict = [self payResultsDictionray:nil];
    [dict setObject:@"failure" forKey:@"result"];
    
    PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:dict];
    [self.navigationController pushViewController:vc animated:YES];

//    [Tool showPromptContent:description];
}

- (void)couponsAction
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    NSDictionary *dict = _data;
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
    vc.delegate = self;
    vc.conditionMax = crowdfundingBettingAmount;
    [self.navigationController pushViewController:vc animated:YES];
}

// 自动选择适用的红包
- (CouponsListInfo *)chooseCouponWithBidding:(double)money
{
    double bidding = money;
    CouponsListInfo *selectedCoupon = nil;
    
    NSArray *array = [[ShareManager shareInstance] coupons];
    for (NSInteger i=array.count-1; i>=0; i--) {
        CouponsListInfo *object = array[i];
        if (bidding + 0.01 >= object.ticket_condition) {
            selectedCoupon = object;
            break;
        }
    }
    
    // 自动选择红包 优先级小于手动选择红包
    if (_selectedCoupon != nil && [_selectedCoupon.id isEqualToString:selectedCoupon.id]) {
        
    } else {
        selectedCoupon = _selectedCoupon;
    }

    return selectedCoupon;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    NSInteger number = 3;
    
    // 隐藏支付通道
    if ([self hasEnoughCoins]) {
        number = 2;
    }
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [super tableView:tableView numberOfRowsInSection:section];
    
    NSInteger number = 2;
    
    if (0 == section) {
        
        int thriceBettingCount = [self amountThriceCoin:[_data objectForKey:@"Thrice"]];
        if (thriceBettingCount == 0) {
            number = 1;
        } else {
            number = 2;
        }
    }
    if (1 == section) {
        
        int thriceBettingCount = [self amountThriceCoin:[_data objectForKey:@"Thrice"]];
        if (thriceBettingCount == 0) {
            number = 3;
        } else {
            number = 4;
        }
    }
    if (2 == section) {
        number = 1;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *redCoinColor = [UIColor colorFromHexString:@"e6322c"];
    UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
    UIColor *redCNYColor = [UIColor colorFromHexString:@"ea605d"];
    UIColor *dartTextColor = [UIColor colorFromHexString:@"444444"];
    UIColor *grayTextColor = [UIColor colorFromHexString:@"d7d7d7"];
    UIFont *smallFont = [UIFont systemFontOfSize:13];
    
    
    NSDictionary *dict = _data;
    
    // 选中的红包
    NSString *couponStr = [self selectedCouponName];
    
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = [self amountThriceCoin:thriceArray];
    int rebatedCoinFromCoupon = [self rebatedCoinFromCoupon];
    int exchangedCrowdfundingCoin = [self exchangeCorwdfundingCoin];
    int exchangeThriceCoin = exchangedCrowdfundingCoin * ThriceExchangeRate;
    int remainderCrowdfundingCoin = [ShareManager shareInstance].userinfo.user_money;
    int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
    int payCrowdfundingCoin = crowdfundingBettingAmount - exchangedCrowdfundingCoin - rebatedCoinFromCoupon;
    int payThriceCoin = thriceBettingCount + exchangeThriceCoin;
    int payCNY = [self payCNY];
    
    // 夺宝币余额中支付的部分
    int costedCrowdfundingCoin = payCrowdfundingCoin <= remainderCrowdfundingCoin ? payCrowdfundingCoin : remainderCrowdfundingCoin;
    int costedThriceCoin = [self costedThriceCoin];
    
    
    
    // 夺宝币参与金额
    NSString *purchasedCoinCrowdfundingStr = [NSString stringWithFormat:@"%d个夺宝币", crowdfundingBettingAmount];
    NSAttributedString *purchasedCoinCrowdfundingAttr = [[NSAttributedString alloc] initWithString:purchasedCoinCrowdfundingStr attributes:@{NSForegroundColorAttributeName:redCoinColor}];
    
    
    // 夺宝总人次
    NSMutableAttributedString *crowdfundingTimes = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d人次", crowdfundingBettingCount] attributes:@{NSForegroundColorAttributeName:redCoinColor, NSFontAttributeName: smallFont}];
    if (crowdfundingCardinalNumber != 10) {
        crowdfundingTimes = nil;
    }
    
    // 欢乐豆押注金额
    NSString *purchasedCoinThriceStr = [NSString stringWithFormat:@"%d", thriceBettingCount];
    NSAttributedString *purchasedCoinThriceAttr = [[NSAttributedString alloc] initWithString:purchasedCoinThriceStr attributes:@{NSForegroundColorAttributeName:orangeCoinColor}];
    
    
    // 欢乐豆自动抵扣夺宝币 title
    NSMutableAttributedString *autoexchangeCrowdfundingCoinAttr = [[NSMutableAttributedString alloc] initWithString:@"欢乐豆抵扣" attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    NSString *autoexchangeCrowdfundingCoinStr = [NSString stringWithFormat:@"%d", exchangedCrowdfundingCoin];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:autoexchangeCrowdfundingCoinStr attributes:@{NSForegroundColorAttributeName:redCoinColor}];
    [autoexchangeCrowdfundingCoinAttr appendAttributedString:attr];
    attr = [[NSMutableAttributedString alloc] initWithString:@"夺宝币" attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    [autoexchangeCrowdfundingCoinAttr appendAttributedString:attr];
    
    
    // 欢乐豆金额，抵扣夺宝币 detail
    NSString *rebatedCoinThriceStr = [NSString stringWithFormat:@"-%d", exchangeThriceCoin];
    NSAttributedString *rebatedCoinThriceAttr = [[NSAttributedString alloc] initWithString:rebatedCoinThriceStr attributes:@{NSForegroundColorAttributeName:orangeCoinColor}];
    
    
    // 夺宝币支付余额
    NSMutableAttributedString *payCrowdfundingCoinAttr = [[NSMutableAttributedString alloc] initWithString:@"夺宝币支付  " attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    NSString *str = [NSString stringWithFormat:@"余额: %d夺宝币", remainderCrowdfundingCoin];
    attr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:grayTextColor, NSFontAttributeName: smallFont}];
    [payCrowdfundingCoinAttr appendAttributedString:attr];
    
    
    // 夺宝币支付金额
    NSString *rebatedCoinCrowdfundingStr = [NSString stringWithFormat:@"-%d夺宝币", costedCrowdfundingCoin];
    NSMutableAttributedString *rebatedCoinCrowdfundingAttr = [[NSMutableAttributedString alloc] initWithString:rebatedCoinCrowdfundingStr attributes:@{NSForegroundColorAttributeName:redCoinColor}];
    
    // 金额为0不显示
    if (costedCrowdfundingCoin <= 0) {
        rebatedCoinCrowdfundingAttr = nil;
    }
    
    // 欢乐豆支付余额
    NSMutableAttributedString *payThriceCoinAttr = [[NSMutableAttributedString alloc] initWithString:@"欢乐豆支付  " attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    str = [NSString stringWithFormat:@"余额: %d欢乐豆", remainderThriceCoin];
    attr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:grayTextColor, NSFontAttributeName: smallFont}];
    [payThriceCoinAttr appendAttributedString:attr];
    
    
    // 欢乐支付金额
    NSString *rebatedThriceCoinStr = [NSString stringWithFormat:@"-%d", costedThriceCoin];
    NSMutableAttributedString *rebatedThriceCoinAttr = [[NSMutableAttributedString alloc] initWithString:rebatedThriceCoinStr attributes:@{NSForegroundColorAttributeName:orangeCoinColor}];
    
    
    // 共计 1314 元
    NSMutableAttributedString *amountCNYAttr = nil;
    attr = [[NSMutableAttributedString alloc] initWithString:@"共计" attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    str = [NSString stringWithFormat:@" %d ", payCNY];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:redCNYColor}];
    [attr appendAttributedString:attr2];
    attr2 = [[NSMutableAttributedString alloc] initWithString:@"元" attributes:@{NSForegroundColorAttributeName:dartTextColor}];
    [attr appendAttributedString:attr2];
    amountCNYAttr = attr;
    
    
    // 共计花费人民币金额说明
    NSMutableAttributedString *CNYDetailAttr = nil;
    str = [NSString stringWithFormat:@"买欢乐券送100欢乐豆"];
    attr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:grayTextColor, NSFontAttributeName: smallFont}];
    CNYDetailAttr = attr;
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    NSInteger row = indexPath.row;
    CGFloat textLableFontSize = 14;
    cell.textLabel.font = [UIFont systemFontOfSize:textLableFontSize];
    cell.textLabel.textColor = dartTextColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = grayTextColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.attributedText = purchasedCoinCrowdfundingAttr;
            cell.detailTextLabel.attributedText = crowdfundingTimes;

        } else if (indexPath.row == 1) {
            
            UIView *view = [self thriceCoinViewWithStr:purchasedCoinThriceAttr.string fontSize:textLableFontSize];
            view.left = self.tableView.separatorInset.left;
            view.centerY = cell.height/2;
            [cell.contentView addSubview:view];
        }
    } else if (indexPath.section == 1) {
        
        // 红包
        if (indexPath.row == 0) {
            cell.textLabel.text = @"红包";
            cell.detailTextLabel.text = couponStr;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            // 欢乐豆抵扣夺宝币
        } else if (indexPath.row == 1) {
            cell.textLabel.attributedText = autoexchangeCrowdfundingCoinAttr;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *view = [self thriceCoinViewWithStr:rebatedCoinThriceAttr.string fontSize:12];
            view.right = tableView.width - self.tableView.separatorInset.left- 3 - 20;
            view.centerY = cell.height/2;
            [cell.contentView addSubview:view];
            
            // 夺宝币支付
        } else if (indexPath.row == 2) {
            cell.textLabel.attributedText = payCrowdfundingCoinAttr;
            cell.detailTextLabel.attributedText = rebatedCoinCrowdfundingAttr;
            
            // 欢乐豆支付
        } else if (indexPath.row == 3) {
            cell.textLabel.attributedText = payThriceCoinAttr;
            UIView *view = [self thriceCoinViewWithStr:rebatedThriceCoinAttr.string fontSize:12];
            view.right = tableView.width - self.tableView.separatorInset.left - 3;
            view.centerY = cell.height/2;
            [cell.contentView addSubview:view];
        }
        
    } else if (indexPath.section == 2) {
        
        // 共计
        if (indexPath.row == 0) {
            cell.textLabel.attributedText = amountCNYAttr;
            
            if ([ShareManager shareInstance].isInReview == NO) {
                cell.detailTextLabel.attributedText = CNYDetailAttr;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
        }
    } else if (indexPath.section == 1) {
        
        // 红包
        if (indexPath.row == 0) {
            
            [self couponsAction];
            
            // 欢乐豆抵扣夺宝币
        } else if (indexPath.row == 1) {
            
            FAQTableViewController *vc = [[FAQTableViewController alloc] initWithNibName:@"FAQTableViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

            // 夺宝币支付
        } else if (indexPath.row == 2) {
            
            // 欢乐豆支付
        } else if (indexPath.row == 3) {
            
        }
        
    } else if (indexPath.section == 2) {
        
        // 共计
        if (indexPath.row == 0) {
            
            if ([ShareManager shareInstance].isInReview == NO) {
                
                RechargeThriceTableViewController *vc = [[RechargeThriceTableViewController alloc] initWithNibName:@"RechargeThriceTableViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        height = [_paySelectedController height];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if (section == 2) {
        height = _paySelectedController.height + 50;
    }
    
    if ([self hasEnoughCoins] && section == 1) {
        height = 44;
    }
    
    return height;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
{
    NSString *str = nil;
    
    if (section == 0) {
        str = @"商品合计";
    }
    
    return str;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    UIView *view = nil;
    
    // 夺宝币、欢乐豆足够不需要RMB购买，隐藏支付界面
    if (section == 2 && [self hasEnoughCoins] == NO) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _paySelectedController.height + 50)];
        
        // 支付方式选择
        [view addSubview:_paySelectedController.tableView];
        
        // Tabel section separation line
        UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _paySelectedController.height, ScreenWidth, 0.5)];
        separationLine.backgroundColor = [UIColor defaultTableViewSeparationColor];
        [view addSubview:separationLine];
        
        // 服务协议
        if (_agreementCheckbox == nil) {
            _agreementCheckbox = [[AgreementCheckbox alloc] initWithController:self];
        }
        
        AgreementCheckbox *checkboxView = _agreementCheckbox;
        checkboxView.centerX = view.width / 2;
        checkboxView.top = _paySelectedController.height;
        [view addSubview:_agreementCheckbox];
    }
    
    return view;
}

#pragma mark -

- (void)payWithGoods:(NSString *)goods_fight_ids
           orderType:(NSString *)order_type            // 订单/充值/欢乐豆
               count:(int)crowdfundingBettingCount
      thricePurchase:(NSArray *)thriceArray
              coupon:(NSString *)ticket_send_id
    costedThriceCoin:(int)costedThriceCoin
 exchangedThriceCoin:(int)exchangedThriceCoin
          totalPrice:(int)totalPrice
            cutPrice:(int)cutPrice
     payCrowdfunding:(int)payCrowdfunding
          isShopCart:(NSString *)is_shop_cart
             goodsID:(NSString *)goods_ids
{
    // 如果是mustpay支付，间隔时间设置为10秒，用户调出mustpay支付界面，没有选择支付，点击左上角的X后，loading无法监听和取消
    int loadingTime = 30;
    if (_paySelectedController.selectedPaymentType == PaymentTypeMustpay) {
        loadingTime = 20;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    //    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [_loadingHUD hide:NO];
    _loadingHUD = HUD;
    [_loadingHUD hide:YES afterDelay:loadingTime];
    [ _loadingHUD setCompletionBlock:^(void) {
        _footerButtonHasTapped = NO;
    }];

    
    int payCNY = cutPrice;
    
    NSString *purchasePermission = [_paySelectedController paymentPermission:payCNY];
    if (![purchasePermission isEqualToString:@"allow"]) {
        [Tool showPromptContent:purchasePermission];
        return;
    }
    
    __block typeof(self) wself = self;
    
    [_paySelectedController payWithGoods:goods_fight_ids
                               orderType:order_type
                                   count:crowdfundingBettingCount
                          thricePurchase:thriceArray
                                  coupon:ticket_send_id
                        costedThriceCoin:costedThriceCoin
                              totalPrice:totalPrice
                                cutPrice:cutPrice
                         payCrowdfunding:payCrowdfunding
                              completion:^(BOOL success, NSString *description, NSDictionary *dictionary) {
              
                                  
                                  if ([description isEqualToString:@"超时"]) {
                                      [wself purchaseTimeout:payCNY];
                                      
                                  // 支付失败，请重新尝试！！
                                  } else if ([description isEqualToString:@"支付渠道充值失败"]) {
                                      [wself purchaseFailure:@"支付失败，请重新尝试！！"];
                                
                                  // 服务器返回充值结果
                                  }else if ([description isEqualToString:@"服务器返回充值结果"]) {
                                      
                                      NSDictionary *data = [dictionary objectForKey:@"data"];
                                      
                                      int crowdfundingBettingCount = [[_data objectForKey:@"Crowdfunding"] intValue];
                                      
                                      int inventory = [[data objectForKey:@"has_inventory"] intValue];
                                      
                                      // 服务器返回支付结果
                                      BOOL result = NO;
                                      NSDictionary *dict = nil;
                                      NSArray *array = [data objectForKey:@"results"];
                                      
                                      if ([array isKindOfClass:[NSArray class]]) {
                                          
                                          NSDictionary *object = [array firstObject];
                                          
                                          if ([object isKindOfClass:[NSDictionary class]]) {
                                              dict = object;
                                              result = YES;
                                          }
                                      }
                                      
                                      NSString *wording = [NSString stringWithFormat:@"库存不足，是否包尾"];
                                      NSString *sureButtonStr = [NSString stringWithFormat:@"包尾"];
                                      
                                      if (result == YES) {
                                          
                                          [self purchaseSuccess:data];
                                          
                                      } else {
                                          // 该期已结束，是否参与下一期
                                          if (inventory == 0) {
                                              
                                              // 中断loading，显示alert
                                              [wself.loadingHUD hide:NO];
                                              
                                              wording = @"该期已结束，是否参与下一期";
                                              sureButtonStr = @"参与";
                                              
                                              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                  
                                                  
                                                  [wself purchaseGoodsFightID:goods_fight_ids
                                                                        count:crowdfundingBettingCount
                                                               thricePurchase:thriceArray
                                                                   isShopCart:is_shop_cart
                                                                       coupon:ticket_send_id
                                                             exchangedThriceCoin:exchangedThriceCoin
                                                                      goodsID:goods_ids
                                                                      buyType:@"next"];
                                              }];
                                              
                                              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                              }];
                                              
                                              [alertController addAction:cancelAction];
                                              [alertController addAction:alertAction];
                                              [self presentViewController:alertController animated:YES completion:nil];
                                          }
                                          
                                          // 库存不足
                                          if (inventory < crowdfundingBettingCount) {
                                              
                                              // 中断loading，显示alert
                                              [wself.loadingHUD hide:NO];

                                              wording = [NSString stringWithFormat:@"库存不足，是否包尾 ？"];
                                              sureButtonStr = @"包尾";
                                              
                                              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                  
                                                  [wself purchaseGoodsFightID:goods_fight_ids
                                                                        count:crowdfundingBettingCount
                                                               thricePurchase:thriceArray
                                                                   isShopCart:is_shop_cart
                                                                       coupon:ticket_send_id
                                                             exchangedThriceCoin:exchangedThriceCoin
                                                                      goodsID:goods_ids
                                                                      buyType:@"mantissa"];
                                                  
                                              }];
                                              
                                              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                              }];
                                              
                                              [alertController addAction:cancelAction];
                                              [alertController addAction:alertAction];
                                              [self presentViewController:alertController animated:YES completion:nil];
                                              
                                          }
                                      }
                                      
                                      XLog(@"%@", [dict my_description]);
                                      
                                  } else if (success == NO) {
                                      
                                      [wself purchaseFailure:description];
                                  }
                              }];
}


// 直接购买 = 生成与订单 -> 夺宝币欢乐豆均足够可直接购买
- (void)purchaseGoodsFightID:(NSString *)goods_fight_ids
                       count:(int)crowdfundingBettingCount
              thricePurchase:(NSArray *)thriceArray
                  isShopCart:(NSString *)is_shop_cart
                      coupon:(NSString *)ticket_send_id
            exchangedThriceCoin:(int)exchangedThriceCoin
                     goodsID:(NSString *)goods_ids
                     buyType:(NSString *)buyType
{
    // 如果是mustpay支付，间隔时间设置为10秒，用户调出mustpay支付界面，没有选择支付，点击左上角的X后，loading无法监听和取消
    int loadingTime = 30;
    if (_paySelectedController.selectedPaymentType == PaymentTypeMustpay) {
        loadingTime = 10;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    //    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [_loadingHUD hide:NO];
    _loadingHUD = HUD;
    [_loadingHUD hide:YES afterDelay:loadingTime];
    [ _loadingHUD setCompletionBlock:^(void) {
        _footerButtonHasTapped = NO;
    }];
    
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak typeof(self) wself = self;
    
    [helper purchaseGoodsFightID:goods_fight_ids
                           count:crowdfundingBettingCount
                  thricePurchase:thriceArray
                      isShopCart:is_shop_cart
                          coupon:ticket_send_id
                exchangedThriceCoin:exchangedThriceCoin
                         goodsID:goods_ids
                         buyType:buyType
                         success:^(NSDictionary *data) {
                             
                             int crowdfundingBettingCount = [[_data objectForKey:@"Crowdfunding"] intValue];
                             
                             int inventory = [[data objectForKey:@"has_inventory"] intValue];

                             BOOL result = NO;
                             NSDictionary *dict = nil;
                             NSArray *array = [data objectForKey:@"results"];
                             
                             if ([array isKindOfClass:[NSArray class]]) {
                                 
                                 NSDictionary *object = [array firstObject];
                                 
                                 if ([object isKindOfClass:[NSDictionary class]]) {
                                     dict = object;
                                     result = YES;
                                 }
                             }
                             
                             NSString *wording = [NSString stringWithFormat:@"库存不足，是否包尾"];
                             NSString *sureButtonStr = [NSString stringWithFormat:@"包尾"];
                             
                             if ([buyType isEqualToString:@"now"]) {
                                 
                                 // 该期已结束，是否参与下一期
                                 if (inventory == 0 && result == NO) {
                                     
                                     // 中断loading，显示alert
                                     [wself.loadingHUD hide:NO];
                                     
                                     wording = @"该期已结束，是否参与下一期";
                                     sureButtonStr = @"参与";
                                     
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         
                                         [wself purchaseGoodsFightID:goods_fight_ids
                                                               count:crowdfundingBettingCount
                                                      thricePurchase:thriceArray
                                                          isShopCart:is_shop_cart
                                                              coupon:ticket_send_id
                                                exchangedThriceCoin:exchangedThriceCoin
                                                             goodsID:goods_ids
                                                             buyType:@"next"];
                                     }];
                                     
                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     }];
                                     
                                     [alertController addAction:cancelAction];
                                     [alertController addAction:alertAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                     
                                 // 库存不足
                                 } else if (inventory < crowdfundingBettingCount && result == NO) {
                                     
                                     // 中断loading，显示alert
                                     [wself.loadingHUD hide:NO];

                                     wording = [NSString stringWithFormat:@"库存不足，是否包尾 ？"];
                                     sureButtonStr = @"包尾";
                                     
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         [wself purchaseGoodsFightID:goods_fight_ids
                                                               count:crowdfundingBettingCount
                                                      thricePurchase:thriceArray
                                                          isShopCart:is_shop_cart
                                                              coupon:ticket_send_id
                                                exchangedThriceCoin:exchangedThriceCoin
                                                             goodsID:goods_ids
                                                             buyType:@"mantissa"];
                                         
                                     }];
                                     
                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     }];
                                     
                                     [alertController addAction:cancelAction];
                                     [alertController addAction:alertAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             // 上一轮执行操作为包尾，存在两种情况，包尾成功／该期已结束
                             if ([buyType isEqualToString:@"mantissa"]) {
                                 
                                 // 包尾失败，该期已结束，操作终止
                                 if (inventory == 0  && result == NO) {
                                     
                                     [wself purchaseFailure:kPurchaseFailureOver];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             // 上一轮操作为买入到下一期，存在两种结果，库存不足没买上终止交易／购买成功
                             if ([buyType isEqualToString:@"next"]) {
                                 
                                 // 购买失败，库存不足，操作终止
                                 if (inventory < crowdfundingBettingCount && result == NO) {
                                     
                                     [wself purchaseFailure:kPurchaseFailureInventoryNotEnought];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             
                             XLog(@"%@", dict);
                             
                         } failure:^(NSString *description) {
                             
                             [self purchaseFailure:description];
                         }];
}

#pragma mark - SelectCouponsViewControllerDelegate

- (void)didSelectCoupon:(CouponsListInfo *)coupon
{
    _selectedCoupon = coupon;
    [self.tableView reloadData];
}

#pragma mark -

- (BOOL)isThriceBetting
{
    BOOL result = [_data objectForKey:@"Thrice"] != nil;
    return result;
}

- (int)exchangeCorwdfundingCoin
{
    int result = 0;
    
    // 三赔默认设置为0, 这里是计算一元购默认设为最大抵扣值
    if ([self isThriceBetting] == NO) {
        
        NSDictionary *dict = _data;
        int exchangeRate = [ShareManager shareInstance].configure.exchangeRate * 100;
        
        int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
        int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
        int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;

        // 最多可以抵扣的夺宝币
        int maxRebatedCrowdfundingCoin = crowdfundingBettingAmount * exchangeRate / 100;
        
        // 用户所有欢乐豆可以抵扣的夺宝币
        int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
        int maxCrowdfundingCointFromThriceCoinExchanged = remainderThriceCoin / ThriceExchangeRate;
        
        result = maxCrowdfundingCointFromThriceCoinExchanged < maxRebatedCrowdfundingCoin ? maxCrowdfundingCointFromThriceCoinExchanged : maxRebatedCrowdfundingCoin;
    }
    
    return result;
}


- (int)amountThriceCoin:(NSArray *)bettingArray
{
    int count = 0;
    
    for (NSDictionary *dict in bettingArray) {
        NSNumber *number = [dict objectForKey:@"count"];
        count += [number intValue];
    }
    
    return count;
}

- (UIView *)thriceCoinViewWithStr:(NSString *)coinStr fontSize:(int)size
{
    if ([coinStr intValue] == 0) {
        return nil;
    }
    
    UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = coinStr;
    label.textColor = orangeCoinColor;
    label.font = [UIFont systemFontOfSize:size];
    [label sizeToFit];
    
    
    UIImageView *imageVeiw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_thrice_coin.png"]];
    imageVeiw.left = label.width + 3;
    imageVeiw.centerY = label.height / 2;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.width = label.width + imageVeiw.width;
    view.height = label.height;
    [view addSubview:label];
    [view addSubview:imageVeiw];
    
    return view;
}

- (int)payCNY
{
    int cnyCount = 0;
    
    NSDictionary *dict = _data;
    
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
   NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = [self amountThriceCoin:thriceArray];
    int rebatedCoinFromCoupon = _selectedCoupon.ticket_value;
    int exchangedCrowdfundingCoin = [self exchangeCorwdfundingCoin];
    int exchangeThriceCoin = exchangedCrowdfundingCoin * ThriceExchangeRate;
    int remainderCrowdfundingCoin = [ShareManager shareInstance].userinfo.user_money;
    int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
    
    // 夺宝币支付金额 = 一元购买入金额 - 欢乐豆抵扣金额 - 欢乐豆抵扣金额
    int payCrowdfundingCoin = crowdfundingBettingAmount - exchangedCrowdfundingCoin - rebatedCoinFromCoupon;
    int payThriceCoin = thriceBettingCount + exchangeThriceCoin;
    
    if (payCrowdfundingCoin > remainderCrowdfundingCoin) {
        cnyCount += payCrowdfundingCoin - remainderCrowdfundingCoin;
    }
    
    remainderThriceCoin = remainderThriceCoin /ThriceExchangeRate * ThriceExchangeRate;
    if (payThriceCoin > remainderThriceCoin) {
        int thriceCoin = payThriceCoin - remainderThriceCoin;
        cnyCount += thriceCoin/ ThriceExchangeRate;
    }
    
    return cnyCount;
}

// 是否有充足的夺宝币、欢乐豆
- (BOOL)hasEnoughCoins
{
    int cny = [self payCNY];
    
    return cny == 0;
}

- (int)rebatedCoinFromCoupon
{
    int value = 0;
    if (_selectedCoupon) {
        value = _selectedCoupon.ticket_value;
    }
    
    return value;
}

- (int)costedThriceCoin
{
    NSDictionary *dict = _data;

    NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = [self amountThriceCoin:thriceArray];
    int exchangedCrowdfundingCoin = [self exchangeCorwdfundingCoin];
    int exchangedThriceCoin = exchangedCrowdfundingCoin * ThriceExchangeRate;
    int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
    int payThriceCoin = thriceBettingCount + exchangedThriceCoin;
    
    remainderThriceCoin = remainderThriceCoin / ThriceExchangeRate * ThriceExchangeRate;
    
    int costedThriceCoin = payThriceCoin <= remainderThriceCoin ? payThriceCoin : remainderThriceCoin;

    return costedThriceCoin;
}

- (NSString *)selectedCouponName
{
    NSString *str = @"无可用红包";
    if (_selectedCoupon) {
        str = _selectedCoupon.ticket_name;
    }
    
    return str;
}

- (NSMutableDictionary *)payResultsDictionray:(NSDictionary *)data
{
    NSDictionary *dict = _data;
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = [self amountThriceCoin:thriceArray];
    int rebatedCoinFromCoupon = _selectedCoupon.ticket_value;
    int exchangedCrowdfundingCoin = [self exchangeCorwdfundingCoin];
    int exchangedThriceCoin = exchangedCrowdfundingCoin * ThriceExchangeRate;
    int remainderCrowdfundingCoin = [ShareManager shareInstance].userinfo.user_money;
    int remainderThriceCoin = [ShareManager shareInstance].userinfo.happy_bean_num;
    int payCrowdfundingCoin = crowdfundingBettingAmount - exchangedCrowdfundingCoin - rebatedCoinFromCoupon;
    int payThriceCoin = thriceBettingCount + exchangedThriceCoin;
    int payCNY = [self payCNY];
    NSString *goods_fight_ids = [dict objectForKey:@"id"];
    NSString *good_name = [dict objectForKey:@"good_name"];
    NSString *good_period = [dict objectForKey:@"good_period"];
    NSString *ticket_send_id = _selectedCoupon.id;
    NSString *goods_ids = [dict objectForKey:@"good_id"];
    NSString *is_shop_cart = _is_shop_cart;

    // 夺宝币余额中支付的部分
    int costedCrowdfundingCoin = payCrowdfundingCoin <= remainderCrowdfundingCoin ? payCrowdfundingCoin : remainderCrowdfundingCoin;
    
    // 欢乐豆余额中支付的部分
    int costedThriceCoin = [self costedThriceCoin];
    
    
    NSMutableDictionary *payResultsDictionary = [NSMutableDictionary dictionary];
    
    // RMB购买可能存在返币,
    int unusedCrowdfunding = 0;
    int unusedThriceCoint = 0;
    
    // 包尾和预计数额不一致
    int purchasedCrowdfundingCoin = crowdfundingBettingAmount;
    int purchasedThriceCoin = thriceBettingCount;
    
    
    if (data ) {
        int inventory = [[data objectForKey:@"has_inventory"] intValue];
        NSString *orderID = [data objectForKey:@"order_id"];
        NSString *all_price = [data objectForKey:@"all_price"];             // 本次购买夺宝币总额
        NSString *all_sapei_beans = [data objectForKey:@"all_sapei_beans"]; // 本次购买欢乐豆总额
        NSArray *array = [data objectForKey:@"results"];
        
        // 服务器返回支付结果
        BOOL result = NO;
        NSDictionary *resultDict = nil;
        if ([array isKindOfClass:[NSArray class]]) {
            NSDictionary *object = [array firstObject];
            if ([object isKindOfClass:[NSDictionary class]]) {
                resultDict = object;
                result = YES;
            }
        }
        
        NSString *not_fight_num = [resultDict objectForKey:@"not_fight_num"];
        NSString *not_fight_counts = [resultDict objectForKey:@"not_fight_counts"];
        NSString *fight_num = [resultDict objectForKey:@"fight_num"];
        
        // orderID不等于空，数据是服务器push过来的，属于RMB参与购买
        if (result == YES) {
   
            unusedCrowdfunding = [not_fight_num intValue];
            unusedThriceCoint = [not_fight_counts intValue];
            purchasedCrowdfundingCoin = [fight_num intValue];
        } else if (orderID.length > 0) {
            
            unusedCrowdfunding = [all_price intValue];
            unusedThriceCoint = [all_sapei_beans intValue];
        }
        
        // 返回原因
        NSString *unusedCrowdfundingReason = @"剩余人次不足";
        [payResultsDictionary setObject:unusedCrowdfundingReason?:@"" forKey:@"unusedCrowdfundingReason"];
    }
    
    
    if (unusedCrowdfunding > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", unusedCrowdfunding] forKey:@"unusedCrowdfunding"];
    }
    if (unusedThriceCoint > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", unusedThriceCoint] forKey:@"unusedThriceCoint"];
    }
    if (purchasedCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", purchasedCrowdfundingCoin] forKey:@"purchasedCrowdfundingCoin"];
    }
    if (purchasedThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", purchasedThriceCoin] forKey:@"purchasedThriceCoin"];
    }
    if (payCNY > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", payCNY] forKey:@"payCNY"];
    }
    if (payCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", payCrowdfundingCoin] forKey:@"payCrowdfundingCoin"];
    }
    if (payThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", payThriceCoin] forKey:@"payThriceCoin"];
    }
    if (costedCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", costedCrowdfundingCoin] forKey:@"costedCrowdfundingCoin"];
    }
    if (costedThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", costedThriceCoin] forKey:@"costedThriceCoin"];
    }
    if (crowdfundingCardinalNumber < 1) {
        crowdfundingCardinalNumber = 1;
    }
    
    [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", crowdfundingCardinalNumber] forKey:@"crowdfundingCardinalNumber"];
    [payResultsDictionary setObject:good_name?:@"" forKey:@"good_name"];
    [payResultsDictionary setObject:good_period?:@"" forKey:@"good_period"];
    
    if (thriceArray) {
        [payResultsDictionary setObject:thriceArray forKey:@"thriceArray"];
    }
    
    return payResultsDictionary;
}


@end
