//
//  DiscoverTableViewController.m
//  DuoBao
//
//  Created by clove on 11/26/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "SafariViewController.h"
#import "ShaiDanViewController.h"
#import "CouponsViewController.h"
#import "FreeGoTableViewController.h"
#import "ThriceViewController.h"
#import "PayTableViewController.h"

@interface DiscoverTableViewController ()<UINavigationControllerDelegate>
@property (nonatomic, copy) NSArray *cellConfigureData;

@end

@implementation DiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"发现";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    NSArray *array = @[
//                       @{@"imageName":@"find_free_purchase",
//                         @"title":@"超级0元购",
//                         @"subtitle":@"每天2场，免费夺宝" },
                       
                       @{@"imageName":@"find_thrice",
                         @"title":@"三赔玩法",
                         @"subtitle":@"一元下注，三倍收入" },

                       @{@"imageName":@"find_show",
                         @"title":@"晒单送欢乐豆",
                         @"subtitle":@"哈哈！中奖啦！" },

//                       @{@"imageName":@"find_lucky",
//                         @"title":@"大转盘",
//                         @"subtitle":@"每天玩一玩，轻松赢大奖" },
                       
                       @{@"imageName":@"find_red_packege",
                         @"title":@"红包",
                         @"subtitle":@"超级返利！不玩虚的！" },
                       
                       @{@"imageName":@"find_question",
                         @"title":@"常见问题",
                         @"subtitle":@"有疑问，就点一点！" },
                       
                       ];
    _cellConfigureData = array;
    
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 1;
    if (section == 1) {
        num = 2;
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = 0;
    switch (indexPath.section) {
        case 0:
        {
            index = 0;
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                index = 1;
            } else if (indexPath.row == 1) {
                index = 2;
            }
            break;
        }
        case 2:
        {
            index = 3;
            break;
        }
            
        default:
            break;
    }
    
    NSDictionary *dict = [_cellConfigureData objectAtIndex:index];
    UIImage *image = [UIImage imageNamed:[dict objectForKey:@"imageName"]];
    NSString *title = [dict objectForKey:@"title"];
    NSString *subtitle = [dict objectForKey:@"subtitle"];
    subtitle = [NSString stringWithFormat:@"\n%@", subtitle];
    UIColor *subtitleColor = [UIColor lightGrayColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.lineSpacing = 5;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSForegroundColorAttributeName:subtitleColor,
                                                                                               NSParagraphStyleAttributeName:paragraphStyle,
                                                                                               NSFontAttributeName:[UIFont systemFontOfSize:11]                                                                                               }];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title];
    [attString appendAttributedString:str];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.imageView.image = image;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = [UIColor defaultColor474747];
    cell.textLabel.attributedText = attString;
//    cell.detailTextLabel.text = subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    
    cell.detailTextLabel.textColor = [UIColor colorFromHexString:@"eeeeee"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *GALabel = kGALabel_finder_tap_free;
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                GALabel = kGALabel_finder_tap_free;
                
                if (![Tool islogin]) {
                    [Tool loginWithAnimated:YES viewController:nil];
                    return;
                }
                
//                // 0元购
//                FreeGoTableViewController *vc = [[FreeGoTableViewController alloc]initWithNibName:@"FreeGoTableViewController" bundle:nil];
//                [self.navigationController pushViewController:vc animated:YES];
                
                ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
                [self.navigationController pushViewController:vc animated:YES];

                break;
                
            } else if (indexPath.row == 1) {
                
                GALabel = kGALabel_finder_tap_coupon;
                
                if (![Tool islogin]) {
                    [Tool loginWithAnimated:YES viewController:nil];
                    return;
                }
                ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
//        case 1:
//        {
//            // 晒单
//            ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
        case 1:
        {
            if (indexPath.row == 0) {
                
                GALabel = kGALabel_finder_tap_review;

                if (![Tool islogin]) {
                    [Tool loginWithAnimated:YES viewController:nil];
                    return;
                }
//                SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
//                vc.title = @"大转盘";
//                vc.urlStr = [NSString stringWithFormat:@"%@%@user_id=%@",URL_Server,Wap_RotaryGameUrl,[ShareManager shareInstance].userinfo.id];
//                vc.isRotaryGame = YES;
//                [self.navigationController pushViewController:vc animated:YES];
                
                // 晒单
                ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            // 红包
            } else if (indexPath.row == 1) {
                
                GALabel = kGALabel_finder_tap_coupon;

                if (![Tool islogin]) {
                    [Tool loginWithAnimated:YES viewController:nil];
                    return;
                }
                CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 2:
        {
            GALabel = kGALabel_finder_tap_FAQ;

            // 常见问题
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_CJWT];
            vc.title = @"常见问题";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    [GA reportEventWithCategory:kGACategoryTabbarTap
                         action:kGAAction_tabbar_tap_finder
                          label:GALabel
                          value:nil];
}




@end
