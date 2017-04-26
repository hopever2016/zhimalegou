//
//  JFTextFieldTableCell.m
//  Picks
//
//  Created by Joe Fabisevich on 3/23/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//

#import "FQGTableViewCell.h"
#import "FQGCellModel.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

CGFloat const JFTextFieldTableCellLeftViewWidth = 15.0f;



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface FQGTableViewCell ()<UITextFieldDelegate>

//@property (readwrite) UITextField *textField;

@property (nonatomic, copy) void (^nextTextFieldBlock)(UITextField *);
@property (nonatomic, copy) void (^textFieldBeganEditingBlock)(UITextField *);

@property UIView *editStateIndicatorView;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation FQGTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected == NO) {
        [self.textField resignFirstResponder];
    }
    
    NSLog(@"type = %lu %d", (unsigned long)_model.type, selected);
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout subviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(LeftMargin, 0, 100, self.height);
    _textField.frame = CGRectMake(_titleLabel.right, 0, self.width-_titleLabel.right, self.height);
    
//    CGFloat const left = CGRectGetMinX(self.contentView.bounds)+self.textFieldInsets.left;
//    CGFloat const top = CGRectGetMinY(self.contentView.bounds)+self.textFieldInsets.top;
//    CGFloat const width = CGRectGetWidth(self.contentView.bounds)-CGRectGetWidth(self.actionButton.frame)-self.textFieldInsets.left-self.textFieldInsets.right;
//    CGFloat const height = CGRectGetHeight(self.contentView.bounds)-self.textFieldInsets.top-self.textFieldInsets.bottom;
//    
//    self.textField.frame = CGRectMake(left, top, width, height);
//    if (CGRectEqualToRect(self.textField.leftView.frame, CGRectZero))
//    {
//        self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftViewWidth, CGRectGetHeight(self.textField.frame))];
//    }
//    
//    self.editStateIndicatorView.frame = CGRectMake(0, 0, _leftViewWidth/3, CGRectGetHeight(self.textField.frame));
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup

- (void)setup
{
    self.layer.opaque = YES;
    self.contentView.layer.opaque = YES;
    self.backgroundView.opaque = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsZero;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:label];
    _titleLabel = label;
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.textColor = [UIColor blackColor];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_textField];
    
    

//    _editStateIndicatorView = [[UIView alloc] init];
//    _editStateIndicatorView.alpha = 0.0f;
//    [_textField addSubview:_editStateIndicatorView];
    
//    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.contentView addSubview:_actionButton];
    
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegation - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setSelected:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setSelected:NO];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    _model.value = textField.text;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cellValueChanged:)]) {
        [self.delegate cellValueChanged:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)updateWithModel:(FQGCellModel *)model
{
    _model = model;
    
    _titleLabel.text = model.title;
    _textField.text = model.value;
    _textField.placeholder = model.placeholder;
}

- (void)flashIndicatorViewWithColor:(UIColor *)color
{
    UIColor *originalBackgroundColor = self.editStateIndicatorView.backgroundColor;
    CGFloat originalAlpha = self.editStateIndicatorView.alpha;
    
    self.editStateIndicatorView.backgroundColor = color;
    self.editStateIndicatorView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.55f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse animations:^{
        self.editStateIndicatorView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.editStateIndicatorView.backgroundColor = originalBackgroundColor;
            self.editStateIndicatorView.alpha = originalAlpha;
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Prepare for Reuse

- (NSString *)reuseIdentifier
{
    return NSStringFromClass(self.class);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textField.text = @"";
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Margins

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
