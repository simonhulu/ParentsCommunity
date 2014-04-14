//
//  ApplyGroupViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-16.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
@interface ApplyGroupViewController : UIViewController<MBProgressHUDDelegate,ASIHTTPRequestDelegate>
{
    
    MBProgressHUD *HUD;
}
@property(nonatomic,strong)IBOutlet UITextField *dTextField;

@property(nonatomic,strong)NSString *rid;
@end
