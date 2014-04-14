//
//  ProfileViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-25.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTabBarController.h"
#import "INavigationViewController.h"
@interface ProfileViewController : UIViewController<ABTaBarControllerDelegate,INavigationViewControllerDelegate>
-(void)setWCuser:(WCUserObject *)user;
@end
