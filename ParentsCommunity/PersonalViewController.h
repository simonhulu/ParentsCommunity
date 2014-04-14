//
//  PersonalViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-19.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "INavigationViewController.h"
#import "ASIHttpRequest/ASIHTTPRequest.h"
@interface PersonalViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIProgressDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,INavigationViewControllerDelegate>

@end
