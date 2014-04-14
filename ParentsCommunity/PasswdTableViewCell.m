//
//  PasswdTableViewCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "PasswdTableViewCell.h"

@implementation PasswdTableViewCell
@synthesize  passwdTextField;
- (void)awakeFromNib
{
    // Initialization code
    self.textLabel.text = @"密码";
    passwdTextField.secureTextEntry = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(PasswdTableViewCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PasswdTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PasswdTableViewCell class]]) {
            customCell = (PasswdTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

@end