//
//  RecoverAddressListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecoverAddressListInfo : NSObject

@property (nonatomic, strong) NSString *province_id;
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *detail_address;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *user_tel;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *create_time;


- (NSString *)address;

@end
