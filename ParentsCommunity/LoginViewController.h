//
//  LoginViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate>
{
    	MBProgressHUD *HUD;
        UIButton *loginBtn;
}

@property(nonatomic,strong)IBOutlet UITableView *loginForm;
@end
