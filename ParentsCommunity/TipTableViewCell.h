//
//  TipTableViewCell.h
//  ParentsCommunity
//
//  Created by qizhang on 14-4-3.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipTableViewCell : UITableViewCell
{
        UILabel *tipLabel;
}
-(void)setMessageDate:(NSDate *)date;
-(void)setTipText:(NSString *)tipText;
@end
