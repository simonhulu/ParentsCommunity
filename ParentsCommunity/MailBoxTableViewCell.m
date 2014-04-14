//
//  MailBoxTableViewCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-22.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "MailBoxTableViewCell.h"

@implementation MailBoxTableViewCell
@synthesize headImag,infoLabel,timeLabel,adminLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        headImag = [[UIImageView alloc]initWithFrame:CGRectMake(13, 15, 46, 46)];
        adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(77, 18, 100, 100)];
        adminLabel.font = [UIFont systemFontOfSize:18];
        [adminLabel setText:@"总舵主"];
        [adminLabel sizeToFit];
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, 100, 44)];
        [timeLabel setTextColor:[UIColor colorWithRed:0.651f green:0.651f blue:0.651f alpha:1]];
        infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(77, 48, 210, 100)];
        [infoLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [infoLabel setTextColor:[UIColor colorWithRed:0.651f green:0.651f blue:0.651f alpha:1]];
        [infoLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [infoLabel setTextAlignment:NSTextAlignmentLeft];
        infoLabel.numberOfLines = 0;
        [self addSubview:headImag];
        [self addSubview:adminLabel];
        [self addSubview:timeLabel];
        [self addSubview:infoLabel];
        [self setBackgroundColor:[UIColor whiteColor]];
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
