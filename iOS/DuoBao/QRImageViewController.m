//
//  QRImageViewController.m
//  DuoBao
//
//  Created by clove on 12/18/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "QRImageViewController.h"

@interface QRImageViewController ()

@end

@implementation QRImageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的二维码";
    
    float width = 240 * UIAdapteRate;
    
    NSString *link = [Tool inviteFriendToRegisterAddress:[ShareManager userID]];
    UIImage *image = [Tool encodeQRImageWithContent:link size:CGSizeMake(width, width)];
    //    UIImage *image = PublicImage(@"defaultImage");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.left = (ScreenWidth - width) / 2;
    imageView.top = 100 * UIAdapteRate;
    
    [self.view addSubview:imageView];

    [self setLeftBarButtonItemArrow];
}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
