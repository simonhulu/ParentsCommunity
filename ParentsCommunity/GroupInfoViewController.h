//
//  GroupInfoViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-16.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupObject.h"
#import "MBProgressHUD.h"
@interface GroupInfoViewController : UIViewController<UIAlertViewDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    UILabel *groupName;
    UILabel *totalPeopleNum;
}
-(void)setGroup:(GroupObject *)groupinfo;
@end
