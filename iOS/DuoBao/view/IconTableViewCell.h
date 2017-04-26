//
//  IconTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@protocol IconTableViewCellDelegate <NSObject>
@optional
- (void)selectIconInfo:(NSInteger)index;

@end

@interface IconTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) id<IconTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;


- (void)initImageCollectView;

@end
