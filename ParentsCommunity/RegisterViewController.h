//
//  RegisterViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TTTAttributedLabel/TTTAttributedLabel.h"
@interface RegisterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>
{
    UITableView *registeForm;
    UIButton *showPassWordBtn;
    UITextField *accountTextField;
    UITextField *passwdTextField;
    UITextField *phoneNumberTextField;
}





-(void)toRegiste;
@end
