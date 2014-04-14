//
//  TipTableViewCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-4-3.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "TipTableViewCell.h"

@implementation TipTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:tipLabel];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)layoutSubviews
{
    [tipLabel setTextColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setFont:[UIFont systemFontOfSize:13]];
    [tipLabel sizeToFit];
    CGRect tipframe = tipLabel.frame;
    tipframe.origin.x = self.bounds.size.width/2 - tipframe.size.width/2 ;
    tipframe.origin.y = self.bounds.size.height/2 - tipframe.size.height/2;
    tipLabel.frame = tipframe;
    [self addSubview:tipLabel];
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

-(void)removeTipLabel
{
    if(tipLabel)
    {
        [tipLabel removeFromSuperview];
        tipLabel = nil;
    }
}

-(void)setMessageDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN" ]];
    [dateFormatter setAMSymbol:@"上午"];
    [dateFormatter setPMSymbol:@"下午"];
    [dateFormatter setDateFormat:@"MM月dd日 a h:mm"];
    tipLabel.text = [dateFormatter stringFromDate:date];
}

-(void)setTipText:(NSString *)tipText
{
    tipLabel.text = tipText;
}

@end
