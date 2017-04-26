//
//  ZengQianViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZengQianViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWitdth;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UILabel *recommendLine;
@property (weak, nonatomic) IBOutlet UIButton *zxButton;
@property (weak, nonatomic) IBOutlet UILabel *zxLine;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UILabel *hotLine;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UILabel *helpLine;

@property (weak, nonatomic) IBOutlet UITableView *myTabelView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)clickRecommedButtonAction:(id)sender;
- (IBAction)clickZXButtonAction:(id)sender;
- (IBAction)clickHotButtonAction:(id)sender;
- (IBAction)clickHelpButtonAction:(id)sender;

@end
