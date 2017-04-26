//
//  FriendsInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "FriendsInfo.h"

@implementation FriendsInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

@end
