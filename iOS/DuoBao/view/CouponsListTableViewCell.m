//
//  CouponsListTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CouponsListTableViewCell.h"
#import "CouponsListInfo.h"
#import "UIImage+Color.h"


@implementation CouponsListTableViewCell


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    
    UIColor *color = [UIColor colorWithWhite:0. alpha:0.38];
    UIImageView *imageView = _maskImageView;
    imageView.image = [UIImage imageFromContextWithColor:color size:imageView.size];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_mask.png"]];
    maskImageView.frame = imageView.bounds;
    
    imageView.layer.mask = maskImageView.layer;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self layoutIfNeeded];
}

- (void)relaodWithData:(CouponsListInfo *)data
{
    _timeLabel.attributedText = nil;
    _maskView.hidden = YES;
    
    if (![data isGoIntoEffect] && [data isUsable]) {
        _maskView.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"生效日期 %@", data.effct_time];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
        _timeLabel.attributedText = str2;
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"有效期至 %@",data.valid_date];
    }
    
    // 三赔赠送欢乐券
    _thriceBackgroundView.hidden = YES;
    _bgImage.hidden = NO;
    if ([data isThriceCoupon]) {
        _thriceBackgroundView.hidden = NO;
        _bgImage.hidden = YES;
    }
    
    _thriceCouponCountLabel.text = [NSString stringWithFormat:@"%@张", data.tickt_num];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    
}

@end
