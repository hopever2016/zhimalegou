//
//  JFHeadTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/20.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@protocol JFHeadTableViewCellDelegate <NSObject>
@optional
- (void)selectJFValueIndex:(NSInteger)index value:(NSString *)valueStr;

@end

@interface JFHeadTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) id<JFHeadTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *valueArray;
@property (assign, nonatomic) NSInteger selectValue;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ljsyLabel;
@property (weak, nonatomic) IBOutlet UILabel *zrsyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *syLabeWidth;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (void)initValueCollectView;

@end
