//
//  GroupsViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-25.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTabBarController/ABTabBarController.h"
@interface GroupsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,ABTaBarControllerDelegate>
{
    NSMutableArray *_groupRecords;
}

//@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
-(void)setGroupRecords:(NSArray*)groupRecords;
@end
