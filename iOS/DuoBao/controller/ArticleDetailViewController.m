//
//  ArticleDetailViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()
{
    UIActivityIndicatorView* activityIndicator;
}

@end

@implementation ArticleDetailViewController

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
    self.title = @"文章详情";
    
    _shareButton.layer.masksToBounds =YES;
    _shareButton.layer.cornerRadius = 5;
    
    _webView.scrollView.bounces = NO;
    
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    NSLog(@"url == %@",request);
    
    [_webView loadRequest:request];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
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
    if (_webView.canGoBack) {
        [_webView goBack];//返回前一画面
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)clickShareButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    [ShareManager shareInstance].shareType = 1;
    [ShareManager shareInstance].shareContentId = _taskInfo.id;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_shareButton setUserInteractionEnabled:YES];
    [_shareButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]];
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    [Tool showPromptContent:@"网页加载失败" onView:self.view];
    
}

@end
