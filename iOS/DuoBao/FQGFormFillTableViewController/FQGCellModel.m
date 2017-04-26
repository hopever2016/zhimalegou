//
//  FQGCellModel.m
//  BoyacxClient
//
//  Created by clove on 7/12/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import "FQGCellModel.h"

@implementation FQGCellModel

+ (FQGCellModel *)testModel
{
    FQGCellModel *model = [[FQGCellModel alloc] init];
    model.key = @"key";
    model.title = @"Title";
    model.value = @"value";
    model.placeholder = @"placeholder";
    model.type = FQGCellTypeTextInput;
    
    return model;
}

+ (FQGCellModel *)testModelPicker
{
    FQGCellModel *model = [[FQGCellModel alloc] init];
    model.key = @"key";
    model.title = @"Title";
    model.value = @"value";
    model.placeholder = @"placeholder";
    model.type = FQGCellTypePicker;
    
    return model;
}

+ (FQGCellModel *)modelWithTitle:(NSString *)title placeholder:(NSString *)placeholder type:(FQGCellType)type key:(NSString *)key value:(NSString *)value  
{
    FQGCellModel *model = [[FQGCellModel alloc] init];
    model.key = key;
    model.title = title;
    model.value = value;
    model.placeholder = placeholder;
    model.type = type;
    
    return model;
}

@end
