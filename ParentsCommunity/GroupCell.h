//
//  GroupCell.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-28.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupObject.h"
#define GROUPCELLHEIGHT 63
@interface GroupCell : UITableViewCell
{
        UIView *circleView  ;
        UILabel *totalNum;
}


@property(nonatomic,strong)GroupObject *groupObj;
@property(nonatomic,strong) UIImageView *groupImageView;
@property(nonatomic,strong) UILabel *preViewLabel;
@property(nonatomic,strong) UILabel *groupNameLabel;
-(void)setMessageCircle;
-(void)removeMessageCircle;
-(void)setPeopleNum:(NSString *)num;
@end
