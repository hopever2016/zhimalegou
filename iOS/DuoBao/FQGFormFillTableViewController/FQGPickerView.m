//
//  FQGPickerView.m
//  BoyacxClient
//
//  Created by clove on 7/13/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import "FQGPickerView.h"

@interface FQGPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *selectedValue;
@property (nonatomic, copy) NSArray *pickerOptions;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation FQGPickerView

- (instancetype)initWithKey:(NSString *)key
                      title:(NSString *)title
                      value:(NSString *)selectedValue
                    options:(NSArray *)pickerOptions
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 256)];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _selectedValue = selectedValue;
        _pickerOptions = pickerOptions;
        _title = title;
        
        [self loadToolbar];
        [self loadPicker];
    }
    
    return self;
}

- (void)loadToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.width = self.width;
    toolbar.height = 44;
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonItemAction:)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemAction:)];
    
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    hint.textAlignment = NSTextAlignmentCenter;
    hint.textColor = [UIColor darkGrayColor];
    hint.text = _title;
    hint.font = [UIFont systemFontOfSize:13];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:hint];
    toolbar.items = @[item0, item1, item2, item3, item4];
    
    [self addSubview:toolbar];
}

- (void)loadPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.height - 212, self.width, 212)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    _pickerView = pickerView;
}

- (void)leftBarButtonItemAction:(id)sender
{
    
}

- (void)rightBarButtonItemAction:(id)sender
{
    
}

#pragma mark - picker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerOptions.count;
}

#pragma mark - picker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _pickerOptions[row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView
//            viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component
//           reusingView:(UIView *)view
//{
//    UILabel *label = (UILabel*)view;
//    if (!label){
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 40.0)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//    }
//    
//    NSDictionary *optionConfig = [_pickerOptions objectAtIndex:row];
//    label.text = [optionConfig objectForKey:@"label"];
//    return label;
//}

@end
