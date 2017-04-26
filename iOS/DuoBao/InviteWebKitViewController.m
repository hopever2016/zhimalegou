
//
//  InviteWebKitViewController.m
//  DuoBao
//
//  Created by clove on 1/14/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "InviteWebKitViewController.h"
#import "InviteViewController.h"

@interface InviteWebKitViewController ()<UIWebViewDelegate, WKScriptMessageHandler>

@end

@implementation InviteWebKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftNavigationItem];
    
    self.webView.UIDelegate = self;
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"AppModel"];
}

//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    XLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    //JS调用 window.webkit.messageHandlers.closeMe.postMessage(null);
    InviteViewController *vc = [[InviteViewController alloc] initWithNibName:@"InviteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL         *url = navigationAction.request.URL;
    
    if (![self.webView.URL.absoluteString isEqualToString:navigationAction.request.URL.absoluteString?:@""]) {
        
        InviteWebKitViewController *vc = [[InviteWebKitViewController alloc] initWithAddress:navigationAction.request.URL.absoluteString];
        [self.navigationController pushViewController:vc animated:YES];
        vc.title = @"如何邀请好友";
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; //otherwise top of website is sometimes hidden under Navigation Bar
}

//3.显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}
//4.弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    
}
//5.显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}


@end
