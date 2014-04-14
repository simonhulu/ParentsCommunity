//
//  ABTabBarController.h
//  Enoda
//
//  Created by Alexander Blunck on 09.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTabBar.h"
#import "AbTabBarItem.h"

#define ACTIVE_ABTABBAR_VIEW 2222
@protocol ABTaBarControllerDelegate
@optional
-(void)abTabControllerWillAdd;
@end
@interface ABTabBarController : UIViewController <ABTabBarDelegate,UINavigationControllerDelegate> {
    ABTabBar *tabBar;

}

@property (nonatomic, strong) NSMutableArray *tabBarItems;
@property (nonatomic) float tabBarHeight;
@property (nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic,strong)    UIView *circleView;
-(void)showViewControllerAtIndex:(NSInteger)index;
-(void)setMessageCircle;
-(void)removeMessageCircle;
@end
