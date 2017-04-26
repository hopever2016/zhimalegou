//
//  FQGTableViewCell.h
//  BoyacxClient
//
//  Created by clove on 7/12/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FQGCellModel, FQGTableViewCell;

@protocol FQGTableViewCellDelegate <NSObject>

- (void)cellValueChanged:(FQGTableViewCell *)cell;
- (void)cellDidBeginEditing:(FQGTableViewCell *)cell;
- (void)cellDidEndEditing:(FQGTableViewCell *)cell;

@end


@interface FQGTableViewCell : UITableViewCell

@property (nonatomic, weak) id delegate;
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL isInputing;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) FQGCellModel *model;

- (void)updateWithModel:(FQGCellModel *)model;
- (void)setup;

@end
