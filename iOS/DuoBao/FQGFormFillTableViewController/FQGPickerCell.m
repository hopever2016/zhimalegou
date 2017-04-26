//
//  FQGPickerCell.m
//  BoyacxClient
//
//  Created by clove on 7/13/16.
//  Copyright © 2016 com.boyacx. All rights reserved.
//

#import "FQGPickerCell.h"
#import "JMWhenTapped.h"

@implementation FQGPickerCell

- (void)setup
{
    [super setup];
    
    self.textField.enabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xl"]];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.width += LeftMargin;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = imageView;
    
    [self.textField whenTapped:^{
        [self setSelected:YES];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cellDidBeginEditing:)]) {
            [self.delegate cellDidBeginEditing:self];
        }
    }
    
    [super setSelected:selected animated:animated];
}



@end
