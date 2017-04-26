//
//  GoodsViewTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@protocol GoodsViewTableViewCellDelegate <NSObject>
@optional
- (void)selectGoodsInfo:(NSInteger)index;
- (void)clickAddShopCarButtonWithIndex:(NSInteger)index;
@end


@interface GoodsViewTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) id<GoodsViewTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;

- (void)initImageCollectView;

@end
