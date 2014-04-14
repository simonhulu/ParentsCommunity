//
//  ErrorMsgView.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-17.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorMsgView : UIView
{
    NSString *msg;
    UILabel *msgLabel;
}
-(void)setErrorMsg:(NSString *)errorMsg;
@end
