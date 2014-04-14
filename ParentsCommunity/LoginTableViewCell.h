//
//  TableViewCell.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UITextField * loginTextField;
+(LoginTableViewCell *)cellFromNibNamed:(NSString *)nibName;
@end
