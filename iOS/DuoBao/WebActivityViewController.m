//
//  InviteWebKitViewController.m
//  DuoBao
//
//  Created by clove on 1/14/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "WebActivityViewController.h"
#import "GoodsDetailInfoViewController.h"

@interface WebActivityViewController ()<UIWebViewDelegate, WKScriptMessageHandler>

@end

@implementation WebActivityViewController

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
    XLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name, message.body);
    NSString *str = [message.body objectForKey:@"body"];
    
    if ([str isEqualToString:@"getzige"]) {
        [self requestActive68];
    } else {
        NSString *goodsID = str;

        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper getGoodsFightID:goodsID success:^(NSDictionary *resultDic) {
            
            NSString *status = [resultDic objectForKey:@"status"];
            NSString *description = [resultDic objectForKey:@"desc"];
            NSDictionary *dict = [resultDic objectForKey:@"data"];
            if ([status isEqualToString:@"0"]) {
                
                NSString *goodsFightID = [dict objectForKey:@"id"];
                GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc] initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
                vc.goodId = goodsFightID;
//                [vc performSelector:@selector(clickJoinButtonAction:) withObject:nil afterDelay:0.5];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } fail:^(NSString *description) {
            [Tool showPromptContent:description];
        }];
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

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL         *url = navigationAction.request.URL;
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; //otherwise top of website is sometimes hidden under Navigation Bar
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

#pragma mark - 

- (void)requestActive68
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper requestAct68Activity:^(NSDictionary *resultDic) {
        
        NSString *status = [resultDic objectForKey:@"status"];
        NSString *description = [resultDic objectForKey:@"desc"];
        [Tool showPromptContent:description];
    } fail:^(NSString *description) {
        [Tool showPromptContent:description];
    }];
}


@end
