
//
//  PaySelectedController.m
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySelectedController.h"
#import "PaySelectedCell.h"
#import "PayManager.h"
#import "SPayManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "YYKitMacro.h"


@interface PaySelectedController ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) SPayManager *spayManager;
@property (nonatomic, strong) PayManager *mustpayManager;

@property (nonatomic) BOOL purchaseFlag; // 包含夺宝币购买选项

@property (nonatomic, strong) RACSignal *racSignal;

@end

@implementation PaySelectedController

- (void)dealloc
{
    XLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithPurchaseGoods
{
    self = [self initWithNibName:@"PaySelectedController" bundle:nil];
    if (self) {
        _purchaseFlag = YES;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configurePaySelectedData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
    UINib *nib = [UINib nibWithNibName:@"PaySelectedCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PaySelectedCell"];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 13)];
//    imageView.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableFooterView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurePaySelectedData
{
    NSArray *configureArray = [ShareManager shareInstance].configureArray;
    
    _array = [NSMutableArray array];
    if (configureArray.count > 0) {
        _array = [NSMutableArray arrayWithArray:configureArray];
    }

    // App store审核期间隐藏支付
    if ([ShareManager shareInstance].isInReview == YES) {
        [_array removeAllObjects];
    }
    
    if (_purchaseFlag == YES) {
        
        double allUserMoney = [ShareManager shareInstance].userinfo.user_money;
        
        PaySelectedData *data = [[PaySelectedData alloc] init];
        data.pay_channel_name = [NSString stringWithFormat:@"夺宝币支付（账户余额: %.0f 夺宝币）", allUserMoney];
        data.isSelected = YES;
        [_array insertObject:data atIndex:0];
    }
    
    // 清除所有已选项，默认选择第一个支付方式
    [self cleanSelected];
    PaySelectedData *firstObject = [_array firstObject];
    firstObject.isSelected = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = _array.count * 44;
    self.tableView.width = ScreenWidth;
    self.tableView.height = height;
    
    // App store审核期间隐藏支付
    if ([ShareManager shareInstance].isInReview == YES) {
        self.tableView.height = 0;
        height = 0;
    }
}

- (CGFloat)height
{
    CGFloat height = _array.count * 44;
    
    // App store审核期间隐藏支付
    if ([ShareManager shareInstance].isInReview == YES) {
        self.tableView.height = 0;
        height = 0;
    }
    
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaySelectedCell *cell = (PaySelectedCell *)[tableView dequeueReusableCellWithIdentifier:@"PaySelectedCell" forIndexPath:indexPath];
    
    PaySelectedData *data = [_array objectAtIndex:indexPath.row];
    [cell relaodWithData:data];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self cleanSelected];
    
    PaySelectedData *data = [_array objectAtIndex:indexPath.row];
    data.isSelected = YES;
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - Pay


- (void)rechargeCrowdfundingCoin:(int)payCNY
                completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self rechargeCoin:payCNY orderType:@"充值" completion:completion];
}

- (void)rechargeThriceCoin:(int)payCNY
                completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self rechargeCoin:payCNY orderType:@"欢乐豆" completion:completion];
}

- (void)rechargeCoin:(int)payCNY
                 orderType:(NSString *)order_type
          completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __block typeof(self) wself = self;
    
    [helper getOrderWithGoods:nil
                    orderType:order_type
                        count:0
               thricePurchase:nil
                       coupon:nil
             costedThriceCoin:0
                   totalPrice:payCNY
                     cutPrice:payCNY
              payCrowdfunding:0
                      success:^(NSDictionary *dictionary) {
                          
                          NSString *status = [dictionary objectForKey:@"status"];
                          NSString *description = [dictionary objectForKey:@"desc"];
                          NSString *orderNo = [dictionary objectForKey:@"data"];
                          
                          if ([status isEqualToString:@"0"] == NO) {
                              
                              if (completion) {
                                  NSDictionary *dict = [wself dictionaryWithKeyValue:description description:description data:nil];
                                  completion(NO, description, dict);
                              }
                          } else {
                              
                              PayManager *payManager = [self selectedPayManager];
                              [payManager payWithOrderNo:orderNo
                                              order_type:order_type
                                                   money:payCNY
                                              completion:^(BOOL result, NSString *description, NSDictionary *dictionary) {
                                                  
                                                  XLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                                                  
                                                  if (result) {
                                                      
                                                      NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                                                      if (completion) {
                                                          completion(YES, description, dict);
                                                      }
                                                  } else {
                                                      
                                                      NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                                                      if (completion) {
                                                          completion(NO, description, dict);
                                                      }
                                                  }
                                              }];

                          }
                          
                      } failure:^(NSString *description) {
                          
                          if (completion) {
                              NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器生成订单失败" description:description data:nil];
                              completion(NO, description, dict);
                          }
                          
                          XLog(@"%@", description);
                      }];
}

- (void)payWithGoods:(NSString *)goods_fight_ids
           orderType:(NSString *)order_type            // 订单/充值/欢乐豆
               count:(int)goodsCount
      thricePurchase:(NSArray *)thricePurchaseArray
              coupon:(NSString *)ticket_send_id
    costedThriceCoin:(int)costedThriceCoin
          totalPrice:(int)totalPrice
            cutPrice:(int)cutPrice
     payCrowdfunding:(int)payCrowdfunding
          completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    __block BOOL hasRetured = NO;
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __block typeof(self) wself = self;
    
    [helper getOrderWithGoods:goods_fight_ids
                    orderType:order_type
                        count:goodsCount
               thricePurchase:thricePurchaseArray
                       coupon:ticket_send_id
             costedThriceCoin:costedThriceCoin
                   totalPrice:totalPrice
                     cutPrice:cutPrice
              payCrowdfunding:payCrowdfunding
                      success:^(NSDictionary *dictionary) {
                          
                          NSString *status = [dictionary objectForKey:@"status"];
                          NSString *description = [dictionary objectForKey:@"desc"];
                          NSString *orderNo = [dictionary objectForKey:@"data"];
                          
                          if ([status isEqualToString:@"0"] == NO) {
                              
                              if (completion) {
                                  NSDictionary *dict = [wself dictionaryWithKeyValue:description description:description data:nil];
                                  completion(NO, description, dict);
                              }
                          } else {
                              
                              @weakify(self);
                              RACSignal *payChannelSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                  @strongify(self);
                                  
                                  PayManager *payManager = [self selectedPayManager];
                                  [payManager payWithOrderNo:orderNo
                                                  order_type:order_type
                                                       money:cutPrice
                                                  completion:^(BOOL result, NSString *description, NSDictionary *dictionary) {
                                                      
                                                      XLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                                                      
                                                      if (result) {
                                                          
                                                          [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                                                              
                                                              NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                                                              [subscriber sendNext:dict];
                                                              [subscriber sendCompleted];
                                                          }];
                                                          
                                                          NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                                                          [subscriber sendNext:dict];
                                                          //                                                      [subscriber sendCompleted];
                                                      } else {
                                                          
                                                          NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                                                          [subscriber sendNext:dict];
                                                          [subscriber sendCompleted];
                                                      }
                                                  }];
                                  
                                  return nil;
                              }];
                              
                              RACSignal *serverPayNofitySignal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                  @strongify(self);
                                  
                                  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPayNotification object:nil] subscribeNext:^(NSNotification *notify) {
                                      
                                      XLog(@"rac notify %@", [notify.userInfo my_description]);
                                      NSDictionary *dict = [notify userInfo];
                                      if (dict) {
                                          NSDictionary *data = [dict objectForKey:@"data"];
                                          NSString *status = [dict objectForKey:@"status"];
                                          
                                          if ([status isEqualToString:@"0"] && data) {
                                              
                                              NSString *returnedOrderID = [data objectForKey:@"order_id"];
                                              if (orderNo != nil && [returnedOrderID isEqualToString:orderNo]) {
                                                  NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器返回充值结果" description:nil data:data];
                                                  [subscriber sendNext:dict];
                                                  [subscriber sendCompleted];
                                              }
                                          }
                                      }
                                  }];
                                  
                                  return nil;
                              }];
                              
                              RACSignal *signUpActiveSignal = [RACSignal  merge:@[payChannelSignal, serverPayNofitySignal]];
                              
                              [signUpActiveSignal subscribeNext:^(NSDictionary *dictionary) {
                                  
                                  XLog(@"finally = %@", [dictionary my_description]);
                                  
                                  NSString *str = [dictionary objectForKey:@"key"];
                                  
                                  if ([str isEqualToString:@"服务器返回充值结果"]) {
                                      
                                      if (hasRetured == NO) {
                                          completion(YES, str, dictionary);
                                      }
                                      hasRetured = YES;
                                  }
                                  if ([str isEqualToString:@"超时"]) {
                                      
                                      if (hasRetured == NO) {
                                          completion(NO, str, dictionary);
                                      }
                                      hasRetured = YES;
                                  }
                                  if ([str isEqualToString:@"支付渠道返回充值成功"]) {
                                      
                                      
                                  }
                                  if ([str isEqualToString:@"支付渠道充值失败"]) {
                                      
                                      if (hasRetured == NO) {
                                          completion(NO, str, dictionary);
                                      }
                                      hasRetured = YES;
                                  }
                              }];
                              
                              _racSignal = signUpActiveSignal;
                              
                          }
                          
                      } failure:^(NSString *description) {
                          
                          if (completion) {
                              NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器生成订单失败" description:description data:nil];
                              completion(NO, description, dict);
                          }
                          
                          XLog(@"%@", description);
                      }];
}

- (PaySelectedData *)selectedTheWayOfPayment
{
    PaySelectedData *data = nil;
    for (PaySelectedData *object in _array) {
        if (object.isSelected) {
            data = object;
            break;
        }
    }
    
    return data;
}

- (void)cleanSelected
{
    for (PaySelectedData *object in _array) {
        object.isSelected = NO;
    }
}

- (PaymentType)selectedPaymentType
{
    PaySelectedData *selectedPayment = [self selectedTheWayOfPayment];
    return selectedPayment.paymentType;
}

- (NSString *)paymentPermission:(int)startPrice
{
    NSString *str = @"";
    
    PaySelectedData *selectedPayment = [self selectedTheWayOfPayment];
    if (selectedPayment) {
        str = [selectedPayment paymentPermissionAtStartPrice:startPrice];
    }
    
    return str;
}

- (PayManager *)selectedPayManager
{
    
    PaymentType paymentType = [self selectedPaymentType];
    PayManager *payManager = _mustpayManager;
    
    switch (paymentType) {
        case PaymentTypeMustpay:
        {
            _mustpayManager = [[PayManager alloc] init];
            payManager = _mustpayManager;
        }
            break;
        case PaymentTypeSpay:
        {
            _spayManager = [[SPayManager alloc] initWithViewController:self];
            payManager = _spayManager;
            
            break;
        }
            
        default:
            break;
    }
    
    return payManager;
}

- (NSDictionary *)dictionaryWithKeyValue:(NSString *)keyValue description:(NSString *)description data:(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (keyValue) {
        [dict setObject:keyValue forKey:@"key"];
    }
    if (dictionary) {
        [dict setObject:dictionary forKey:@"data"];
    }
    if (description) {
        [dict setObject:description forKey:@"description"];
    }
    
    return dict;
}


@end
