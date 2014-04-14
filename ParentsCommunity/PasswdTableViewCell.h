//
//  PasswdTableViewCell.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswdTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UITextField *passwdTextField;
+(PasswdTableViewCell *)cellFromNibNamed:(NSString *)nibName;
@end
