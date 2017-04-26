//
//  GoodsViewTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsViewTableViewCell.h"
#import "GoodsListCollectionViewCell.h"
#import "GoodsListInfo.h"

@implementation GoodsViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initImageCollectView
{
    [_collectView registerClass:[GoodsListCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsListCollectionViewCell"];    
}

- (void)clickAddButonAction:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(clickAddShopCarButtonWithIndex:)])
    {
        [self.delegate clickAddShopCarButtonWithIndex:btn.tag];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListCollectionViewCell *cell = (GoodsListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListCollectionViewCell" forIndexPath:indexPath];
    
    cell.processView.layer.masksToBounds =YES;
    cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
    
    GoodsListInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    
    cell.processLabelWidth.constant = ((collectionView.frame.size.width)/2- 58 - 3*8 + 2)*([info.progress doubleValue]/100.0);
//    cell.processLabelWidth.constant = cell.processView.width * ([info.progress doubleValue]/100.0);
    
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = info.good_name;
    cell.processNumLabel.text = [NSString stringWithFormat:@"%@％",info.progress];
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(clickAddButonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.priceButton.hidden = YES;
    cell.priceButton.frame = CGRectMake(10 * UIAdapteRate, 0, 28* UIAdapteRate, 31 * UIAdapteRate);
    
    if (info.good_single_price.intValue == 10) {
        cell.priceButton.hidden = NO;
        [cell.priceButton setBackgroundImage:[UIImage imageNamed:@"cont_ten_flag.png"] forState:UIControlStateNormal];
        [cell.priceButton setBackgroundImage:[UIImage imageNamed:@"cont_ten_flag.png"] forState:UIControlStateSelected];
    }
    
    NSString *str = info.part_sanpei;
    if ([str isEqualToString:@"y"]) {
        cell.priceButton.hidden = NO;
        [cell.priceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateNormal];
        [cell.priceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateSelected];
        float rate = 0.8 * UIAdapteRate;
        cell.priceButton.frame = CGRectMake(8 * UIAdapteRate, 4 * UIAdapteRate, 61 * rate, 37 * rate);
    }
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/2,200);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectGoodsInfo:)])
    {
        [self.delegate selectGoodsInfo:indexPath.row];
    }
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}



@end
