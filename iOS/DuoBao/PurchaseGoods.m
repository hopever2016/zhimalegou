//
//  PurchaseGoods.m
//  DuoBao
//
//  Created by clove on 11/28/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "PurchaseGoods.h"

@implementation PurchaseGoods

#pragma mark - Http

- (void)httpGetGoodsDetailInfo
{
    __weak typeof(self) weakSelf = self;

    GoodsDetailInfo *goodsInfo = weakSelf.goodsInfo;
    UIView *onView = weakSelf.viewController.view;
    
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper loadGoodsDetailInfoWithGoodsId:goodsInfo.id
                                    userId:userIdStr
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:onView];
                                       }
                                       
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:onView];
                                   }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
//    GoodsDetailInfo *goodsInfo = _goodsInfo;

    NSDictionary *dic = [resultDic objectForKey:@"data"];
    //商品信息
    GoodsDetailInfo *goodsInfo = [[dic objectForKey:@"goodsFightMap"] objectByClass:[GoodsDetailInfo class]];
    int isJiexiao = 2;
    
    if([goodsInfo.status isEqualToString:@"已揭晓"])
    {
        isJiexiao = 2;
    }else if([goodsInfo.status isEqualToString:@"倒计时"]){
        
        isJiexiao = 1;
        
    }else{
        isJiexiao = 0;
    }
    
//    [dic objectForKey:@"myFightList"];
}



@end
