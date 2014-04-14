//
//  INavigationViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-3-10.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol INavigationViewControllerDelegate<NSObject>
@optional
-(void)navigationWillShowTheView;
@end
@interface INavigationViewController : UINavigationController

@end
