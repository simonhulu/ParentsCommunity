//
//  ChatViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __strong NSMutableArray *_msgArr;
    __strong UITableView *_messageTable;
}
@property(nonatomic,strong)IBOutlet UITableView *messageTable;

@end
