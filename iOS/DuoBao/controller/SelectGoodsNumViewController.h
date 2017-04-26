//
//  SelectGoodsNumViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailInfo.h"

@protocol SelectGoodsNumViewControllerDelegate <NSObject>
@optional
- (void)selectGoodsNum:(int)num goodsInfo:(GoodsDetailInfo *)goodsInfo;
@end

@interface SelectGoodsNumViewController : UIViewController
@property (nonatomic, assign) id<SelectGoodsNumViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *blackImageView;

- (void)reloadDetailInfoOnce:(GoodsDetailInfo *)detailInfo;

@end
