
//
//  PurchaseViewController.m
//  DuoBao
//
//  Created by clove on 12/21/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "PurchaseViewController.h"
#import "SelectGoodsNumberView.h"

@interface PurchaseViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation PurchaseViewController

- (void)loadView
{
    [super loadView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    _backgroundImageView = imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
