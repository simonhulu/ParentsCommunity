//
//  ItestViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-3-10.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItestViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)IBOutlet UITableView *groups;
@end
