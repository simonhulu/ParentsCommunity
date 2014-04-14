//
//  RegionViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoCompleteViewController.h"
@interface RegionViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>
@property(nonatomic,strong)id<UNavigationControllerBackDelegate>delegate;
@property(nonatomic,strong)IBOutlet UITableView *regionTableView;
-(void)setRegions:(NSDictionary *)regions;
@end
