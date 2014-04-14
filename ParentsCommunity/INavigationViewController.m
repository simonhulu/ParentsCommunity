//
//  INavigationViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-3-10.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "INavigationViewController.h"

@interface INavigationViewController ()
{
    UIView *noConnectionTip;
}

@end

@implementation INavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

//-(void)noConnection:(NSNotification *)notification
//{
//    if(!noConnectionTip)
//    {
//        self.navigationBar.
//        noConnectionTip = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, self.view.bounds.size.width, 34)];
//        [noConnectionTip setBackgroundColor:[UIColor colorWithRed:0.996f green:0.937f blue:0.937f alpha:1]];
//        [self.view addSubview:noConnectionTip];
//        NSLog(@"%@",self.parentViewController);
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
