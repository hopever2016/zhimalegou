//
//  SettingViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SettingViewController.h"
#import "UesrInfoListTableViewCell.h"
#import "SafariViewController.h"
#import "ButtonTableViewCell.h"
#import "LoginViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"设置";
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


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickQuitButtonAction:(id)sender
{
    [Tool saveUserInfoToDB:NO];
    [_myTableView reloadData];
    //退出登录
    [[NSNotificationCenter defaultCenter] postNotificationName:kQuitLoginSuccess object:nil];
    
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([ShareManager shareInstance].userinfo.islogin) {
        return 6;
    }
    return 5;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 80;
    }
    return 45;
    
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        ButtonTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ButtonTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        cell.btn.layer.masksToBounds =YES;
        cell.btn.layer.cornerRadius = 4;

        [cell.btn addTarget:self action:@selector(clickQuitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    UesrInfoListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"UesrInfoListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UesrInfoListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.detailLabel.text = @"";
    cell.rightImage.hidden = NO;
    cell.lineLabel.hidden = NO;
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.detailLabel.textColor  = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
    cell.rightImageWidth.constant = 14;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"关于我们";
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"免责声明";
        }
            break;
        case 2:
        {
            
             cell.titleLabel.text = @"服务协议";
        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"消费者保障协议";
            
        }
            break;
        default:
        {
            cell.titleLabel.text = @"隐私协议";
            cell.lineLabel.hidden = YES;
        }
            break;
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"关于我们";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=1&is_show_message=y",URL_Server,Wap_AboutDuobao];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 1:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"免责声明";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=5&is_show_message=y",URL_Server,Wap_AboutDuobao];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"服务协议";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=6&is_show_message=y",URL_Server,Wap_AboutDuobao];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"消费者保障协议";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=7&is_show_message=y",URL_Server,Wap_AboutDuobao];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"隐私协议";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=8&is_show_message=y",URL_Server,Wap_AboutDuobao];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
    
}

@end
