//
//  IconTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "IconTableViewCell.h"
#import "IconListCollectionViewCell.h"

@implementation IconTableViewCell

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
    [_collectView registerClass:[IconListCollectionViewCell class] forCellWithReuseIdentifier:@"IconListCollectionViewCell"];
    
    
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconListCollectionViewCell *cell = (IconListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"IconListCollectionViewCell" forIndexPath:indexPath];
    
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    cell.selectedBackgroundView = selectedBGView;
    
    // 去掉积分提现功能
    NSInteger index = indexPath.row;
    index = index > 4 ? ++index: index;
    switch (index) {
        case 0:
        {
            cell.titleLabel.text = @"夺宝记录";
            cell.iconImage.image = [UIImage imageNamed:@"1.png"];
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"中奖记录";
            cell.iconImage.image = [UIImage imageNamed:@"2.png"];
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"我的晒单";
            cell.iconImage.image = [UIImage imageNamed:@"3.png"];
        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"邀请好友";
            cell.iconImage.image = [UIImage imageNamed:@"4.png"];
        }
            break;
        case 4:
        {
            cell.titleLabel.text = @"积分兑换";
            cell.iconImage.image = [UIImage imageNamed:@"5.png"];
        }
            break;
        case 5:
        {
            cell.titleLabel.text = @"积分提现";
            cell.iconImage.image = [UIImage imageNamed:@"11.png"];
        }
            break;
        case 6:
        {
            cell.titleLabel.text = @"红包";
            cell.iconImage.image = [UIImage imageNamed:@"7.png"];
        }
            break;
//        case 7:
//        {
//            cell.titleLabel.text = @"大转盘";
//            cell.iconImage.image = [UIImage imageNamed:@"10.png"];
//        }
//            break;
//        case 8:
//        {
//            cell.titleLabel.text = @"任务";
//            cell.iconImage.image = [UIImage imageNamed:@"9.png"];
//        }
//            break;
        case 7:
        {
            cell.titleLabel.text = @"联系客服";
            cell.iconImage.image = [UIImage imageNamed:@"8.png"];
        }
            break;
        case 8:
        {
            cell.titleLabel.text = @"设置";
            cell.iconImage.image = [UIImage imageNamed:@"6.png"];
        }
            break;
            
            
        default:
            break;
    }
   
    return cell;
    
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/3,78);
    
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
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(selectIconInfo:)])
    {
        // 去掉积分提现功能
        NSInteger index = indexPath.row;
        index = index > 4 ? ++index : index;
        
        [self.delegate selectIconInfo:index];
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
