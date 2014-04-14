//
//  NetWorkProblemTipView.m
//  ParentsCommunity
//
//  Created by qizhang on 14-4-9.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "NetWorkProblemTipView.h"

@implementation NetWorkProblemTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"errorIcon"]];
        [errorImageView setFrame:CGRectMake(30, 6, 20, 20)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(errorImageView.frame.origin.x+errorImageView.frame.size.width+20, 5, 100, 30)];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setText:@"网络连接异常"];
        [tipLabel sizeToFit];
        [self addSubview:tipLabel];
        [self addSubview:errorImageView];
        [self setBackgroundColor:[UIColor colorWithRed:0.996f green:0.933 blue:0.933f alpha:1]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
