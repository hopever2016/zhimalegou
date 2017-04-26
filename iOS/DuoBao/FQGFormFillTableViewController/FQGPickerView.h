//
//  FQGPickerView.h
//  BoyacxClient
//
//  Created by clove on 7/13/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQGPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                      value:(NSString *)selectedValue
                    options:(NSArray *)pickerOptions;

@end
