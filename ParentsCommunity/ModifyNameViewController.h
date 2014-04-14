//
//  ModifyNameViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-21.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ModifyNameViewController : UIViewController<MBProgressHUDDelegate>


-(void)setName:(NSString *)name;
@end
