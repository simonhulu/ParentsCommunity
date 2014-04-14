//
//  ErrorMsgView.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-17.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ErrorMsgView.h"

@implementation ErrorMsgView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    UIImage *image = [UIImage imageNamed:@"plaintSymbol.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    [imageView setImage:image];
    [self addSubview:imageView];
    
    msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width+5,5, 100, 44)];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:msgLabel];
    
    return self;
}




-(void)setErrorMsg:(NSString *)errorMsg
{
    msg = errorMsg;
    msgLabel.text = errorMsg;
    [msgLabel sizeToFit];
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
