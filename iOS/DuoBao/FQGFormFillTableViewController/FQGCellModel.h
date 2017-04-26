//
//  FQGCellModel.h
//  BoyacxClient
//
//  Created by clove on 7/12/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    FQGCellTypeTextInput,
    FQGCellTypePicker
} FQGCellType;

@interface FQGCellModel : NSObject

// default is nil
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic) FQGCellType type;

+ (FQGCellModel *)testModel;
+ (FQGCellModel *)testModelPicker;

+ (FQGCellModel *)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder type:(FQGCellType)type key:(NSString *)key value:(NSString *)value;

@end


@interface FQGCellModel(CellControl)



@end