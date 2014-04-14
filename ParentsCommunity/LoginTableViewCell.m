//
//  TableViewCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell
@synthesize loginTextField;
- (void)awakeFromNib
{
    // Initialization code
    self.textLabel.text = @"账号";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(LoginTableViewCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    LoginTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[LoginTableViewCell class]]) {
            customCell = (LoginTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

@end
