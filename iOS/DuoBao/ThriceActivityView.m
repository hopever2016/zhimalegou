
//
//  ThriceActivityView.m
//  DuoBao
//
//  Created by clove on 4/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ThriceActivityView.h"
#import "ServerProtocol.h"

@implementation ThriceActivityView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _progressView.background = [UIColor colorFromHexString:@"560d17"];
    _progressView.color = [UIColor colorFromHexString:@"FFFB93"];
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _progressView.type = LDProgressSolid;
    _progressView.animate = @NO;
    
    
//    UIImage *image = [UIImage imageNamed:@"thrice_bg.jpg"];
//    image = [image stretchableImageWithLeftCapWidth:ScreenWidth/2 * UIAdapteRate topCapHeight:2344/3 * UIAdapteRate];
//    _backgroundImageView.image = image;
//    _backgroundImageView.height += 150 * UIAdapteRate;

    
    NSString *content = @"参与三赔商品夺宝，即可参加三赔玩法猜幸运号码尾数。选择ABCD任意一组，等待三赔商品开奖揭晓。所买足内任一一个好吗与该期商品营运好吗的末尾数字一致为中奖。ABC三组中奖概率均为30%，中奖将获得3倍的欢乐豆。D组数字0的中奖概率为10%，中奖将获得8倍的欢乐豆！";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5 * UIAdapteRate;// 字体的行间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName: [UIFont systemFontOfSize:14 * UIAdapteRate],
                                 NSForegroundColorAttributeName:[UIColor colorFromHexString:@"F6E3A6"]
                                 };
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
//    content = @"你敢猜我就敢陪";
//    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5 * UIAdapteRate;// 字体的行间距
//    attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
//                                 NSFontAttributeName: [UIFont systemFontOfSize:14 * UIAdapteRate],
//                                 NSForegroundColorAttributeName:[UIColor colorFromHexString:@"F6E3A6"]
//                                 };
//    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
//    [attr appendAttributedString:attr2];
    
    float textViewWidth = ScreenWidth - (16 + 10) * UIAdapteRate;
    UITextView *textView = _textView;
    textView.attributedText = attr;
    textView.width = textViewWidth;
    [textView sizeToFit];
    textView.top = _ruleTitleLabel.bottom - 3;
//    textView.left = _ruleTitleLabel.left - 4;
    
    _ruleTitleLabel.font = [UIFont systemFontOfSize:20 * UIAdapteRate];

    [self UIAdapte];
    
    textView.width = textViewWidth;
    textView.height = textView.contentSize.height;
    _lookupRuleButton.top = textView.bottom + 24 * UIAdapteRate;
    
    float fontSize = _goodsTitleLabel.font.pointSize;
    _goodsTitleLabel.font = [UIFont systemFontOfSize:fontSize * UIAdapteRate];
    
    fontSize = _amountLable.font.pointSize;
    _amountLable.font = [UIFont systemFontOfSize:fontSize * UIAdapteRate];
    _remainderLabel.font = [UIFont systemFontOfSize:fontSize * UIAdapteRate];
    
    _remainderLabel.right = [_remainderLabel superview].width;
}

- (void)UIAdapte
{
    float rate = UIAdapteRate;
    
    for (UIView *view in self.subviews) {
        view.width *= rate;
        view.height *= rate;
        view.left *= rate;
        view.top *= rate;
        
        UIView *containerView = view;
        for (UIView *view in containerView.subviews) {
            view.width *= rate;
            view.height *= rate;
            view.left *= rate;
            view.top *= rate;
            
            UIView *containerView = view;
            for (UIView *view in containerView.subviews) {
                
                view.width *= rate;
                view.height *= rate;
                view.left *= rate;
                view.top *= rate;
            }
        }
    }
    
    
    
    
}

- (void)reloadWithData:(NSDictionary *)dict
{
    
    NSString *needAmount = [dict objectForKey:@"need_people"];
    NSString *needRemainder = [dict objectForKey:@"now_people"];
    NSString *goodsImage = [dict objectForKey:@"good_header"];
    NSString *goodsTitle = [ServerProtocol periodAndGoodsName:dict];
    float progress = [ServerProtocol progress:dict];
    int remainderCrowdfundingTimes = [ServerProtocol remainderCrowdfundingTimes:dict];
    
    NSString *needAmountStr = [NSString stringWithFormat:@"总需%@人次", needAmount];
    NSString *needRemainderStr = [NSString stringWithFormat:@"还需%d", remainderCrowdfundingTimes];
    
    self.progressView.progress = progress;
    self.amountLable.text = needAmountStr;
    self.remainderLabel.text = needRemainderStr;
    _goodsTitleLabel.text = goodsTitle;
    
    __weak typeof(self) wself = self;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:PublicImage(@"default") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType == SDImageCacheTypeNone && image) {
            [UIView transitionWithView:wself.goodsImageView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                wself.goodsImageView.image = image;
                            } completion:^(BOOL finished) {
                                
                            }];
            
            [wself.goodsImageView setNeedsLayout];
        }
    }];
}

@end
