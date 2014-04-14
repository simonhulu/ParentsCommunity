//
//  ABTabBarController.m
//  Enoda
//
//  Created by Alexander Blunck on 09.03.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ABTabBarController.h"

@implementation ABTabBarController

@synthesize tabBarItems=_tabBarItems, tabBarHeight=_tabBarHeight, backgroundImage=_backgroundImage,circleView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    tabBar = [[ABTabBar alloc] initWithTabItems:self.tabBarItems height:self.tabBarHeight backgroundImage:self.backgroundImage];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [tabBar loadDefaultView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeMessageCircle) name:newNotificationChecked object:nil];
}

//ABTabBarDelegate Methods
-(void) abTabBarSwitchView:(UIViewController *)viewController {
    //Remove Current active View by getting it via it's tag
    UIView *currentActiveView = [self.view viewWithTag:ACTIVE_ABTABBAR_VIEW];
    [currentActiveView removeFromSuperview];
    //Add New View and set it's tag to the new active view
    viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarHeight);
    viewController.view.tag = ACTIVE_ABTABBAR_VIEW;
    if([viewController respondsToSelector:@selector(abTabControllerWillAdd)])
    {
        [viewController performSelector:@selector(abTabControllerWillAdd) withObject:nil afterDelay:0.2];
    }
    [self.view insertSubview:viewController.view belowSubview:tabBar];
}

-(void)showViewControllerAtIndex:(NSInteger)index
{
    [tabBar showViewControllerAtIndex:index];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setMessageCircle
{
    if(!circleView)
    {
        NSLog(@"%f",self.view.bounds.size.width);
        NSLog(@"%f",tabBar.frame.origin.y);
        circleView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50, tabBar.frame.origin.y+10, 10, 10)];
        circleView.layer.cornerRadius = 5;
        circleView.backgroundColor = [UIColor colorWithRed:0.957f green:0.169f blue:0.188f alpha:1];
        [self.view addSubview:circleView];
    }
   
    
}


-(void)removeMessageCircle
{
    if(circleView)
    {
        [circleView removeFromSuperview];
        circleView = nil;
    }
}

-(void) dealloc {

}



#pragma ---UINavigationDlegate---
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController !=self)
    {
        if([viewController respondsToSelector:@selector(navigationWillShowTheView)])
        {
            [viewController performSelector:@selector(navigationWillShowTheView)];
        }
    }
}

@end
