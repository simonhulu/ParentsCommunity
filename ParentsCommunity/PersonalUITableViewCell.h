//
//  PersonalUITableViewCell.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-21.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalUITableViewCell : UITableViewCell
{
    UILabel *infoLabel ;
    UILabel *nameLabel;
}


-(void)setPersonalInfo:(NSString *)info;
@end
