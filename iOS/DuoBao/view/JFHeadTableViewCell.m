//
//  JFHeadTableViewCell.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/20.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "JFHeadTableViewCell.h"
#import "JFValueCollectionViewCell.h"

@implementation JFHeadTableViewCell
{
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initValueCollectView
{
    [_collectView registerClass:[JFValueCollectionViewCell class] forCellWithReuseIdentifier:@"JFValueCollectionViewCell"];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _valueArray.count;
}


- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFValueCollectionViewCell *cell = (JFValueCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"JFValueCollectionViewCell" forIndexPath:indexPath];
    
    cell.valueButton.layer.masksToBounds =YES;
    cell.valueButton.layer.cornerRadius = 3;
    
    
    [cell.valueButton setTitle:[_valueArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    if (_selectValue == indexPath.row) {
        cell.valueButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
        cell.valueButton.layer.borderWidth = 1.0f;
    }else{
        cell.valueButton.layer.borderColor = [[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] CGColor];
        cell.valueButton.layer.borderWidth = 1.0f;
    }
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/3,35);
    
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
    _selectValue = indexPath.row;
    [collectionView reloadData];
    
    if([self.delegate respondsToSelector:@selector(selectJFValueIndex:value:)])
    {
        [self.delegate selectJFValueIndex:indexPath.row value:[_valueArray objectAtIndex:indexPath.row]];
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
