//
//  SelectRoleViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectRoleViewController : UIViewController
@property(nonatomic,strong)IBOutlet UITableView *tableView;
-(void)setTableSource:(NSArray *)array;
@end
