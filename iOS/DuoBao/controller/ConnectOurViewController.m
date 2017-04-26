//
//  ConnectOurViewController.m
//  YCSH
//
//  Created by linqsh on 15/12/17.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "ConnectOurViewController.h"
#import "SafariViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface ConnectOurViewController ()
{
}

@end

@implementation ConnectOurViewController

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
    self.title = @"联系我们";
    
    _bgWidth.constant = FullScreen.size.width;
    
    _textView.layer.masksToBounds =YES;
    _textView.layer.cornerRadius = 8;
    _textView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _textView.layer.borderWidth = .1f;
    
    _commitButton.layer.masksToBounds =YES;
    _commitButton.layer.cornerRadius = 6;
    
    if ( [ShareManager shareInstance].serverPhoneNum.length > 0 &&  ![[ShareManager shareInstance].serverPhoneNum isEqualToString:@"<null>"]) {
        _phoneLabel.text =  [ShareManager shareInstance].serverPhoneNum;
    }else{
        _phoneLabel.text =  @"";
        _phoneWarnLabel.hidden = YES;
        _phoneButton.hidden = YES;
    }
    
    
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

#pragma mark - http

- (void)httpAddFeedBook
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }else{
        userIdStr = @"";
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ConnectOurViewController *weakSelf = self;
    [helper putFeedBackWithUserId:userIdStr
                          content:_textView.text
                          success:^(NSDictionary *resultDic){
                              [HUD hide:YES];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadResult];
                              }else
                              {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              [HUD hide:YES];
                              [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
}

- (void)handleloadResult
{
    [Tool showPromptContent:@"提交成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}

#pragma mark - Action

- (void)clickLeftItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickPhoneButton:(id)sender
{
    [[ShareManager shareInstance] dialWithPhoneNumber:[ShareManager shareInstance].serverPhoneNum inView:self.view];
}
- (IBAction)clickCommitButton:(id)sender
{
    [Tool hideAllKeyboard];
    if (_textView.text.length < 1 || [_textView.text isEqualToString:@"请写下您的宝贵意见"]) {
        [Tool showPromptContent:@"请写下您的反馈意见" onView:self.view];
        return;
    }
    if(![Tool islogin])
    {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }

    [self httpAddFeedBook];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请写下您的宝贵意见"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"请写下您的宝贵意见";
        textView.textColor = [UIColor lightGrayColor];
    }
}

@end
