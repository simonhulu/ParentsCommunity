//
//  ViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"
#import "SendMessageViewController.h"
#import "GroupsViewController.h"
#import "MainTabViewController.h"
#import "ProfileViewController.h"
#import "MHTabBarController.h"
#import "ABTabBarController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

}

-(void)viewDidAppear:(BOOL)animated
{
    

    
//    SendMessageViewController *sendMsgView = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
//    [self presentViewController:sendMsgView animated:YES completion:^{
//        
//    }];


    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
