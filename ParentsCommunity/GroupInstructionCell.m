//
//  GroupInstructionCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-4-7.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "GroupInstructionCell.h"

@implementation GroupInstructionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.794f green:0.794f blue:0.794f alpha:1]];
        NSLog(@"%f",self.bounds.size.height);
        [bgView setFrame:CGRectMake(self.bounds.size.width/2-46, 31.5-10, 92, 20)];
        bgView.layer.cornerRadius = 3.0f;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setText:@"可申请加入的群"];

        [label setTextAlignment:NSTextAlignmentLeft];
        [label sizeToFit];
        [label setFrame:CGRectMake(bgView.bounds.size.width/2-label.frame.size.width/2, bgView.bounds.size.height/2-label.frame.size.height/2, label.frame.size.width, label.frame.size.height)];
        [bgView addSubview:label];
        [self addSubview:bgView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
