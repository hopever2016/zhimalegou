//
//  ArticleDetailViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZengQianInfo.h"

@interface ArticleDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@property (strong, nonatomic) NSString *urlStr;

@property (strong, nonatomic) ZengQianInfo *taskInfo;

- (IBAction)clickShareButtonAction:(id)sender;
@end
