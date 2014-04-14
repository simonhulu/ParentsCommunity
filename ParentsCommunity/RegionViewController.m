//
//  RegionViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "RegionViewController.h"
#import "UserInfoCompleteViewController.h"
@interface RegionViewController ()
{
    NSArray *_regions;
    MBProgressHUD *HUD;
}

@end

@implementation RegionViewController
@synthesize regionTableView,delegate;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---regionTable---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_regions)
    {
        NSLog(@"%d",[_regions count]);
        return [_regions count];
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"iii";
    UITableViewCell *cell = nil;
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSString *cityName = [[_regions objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.textLabel.text = cityName;
        if ([[_regions objectAtIndex:indexPath.row] objectForKey:@"items"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

-(void)setRegions:(NSArray *)regions
{
    _regions = regions;
    [regionTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCompleteViewController *myController =nil;
    NSInteger count = [self.navigationController.viewControllers count];
    for (int i=0; i< count; i++) {
        UIViewController *viewController = [self.navigationController.viewControllers  objectAtIndex:i];
        if([viewController isKindOfClass:[UserInfoCompleteViewController class]])
        {
            myController = viewController;
        }
    }
    if ([[_regions objectAtIndex:indexPath.row] objectForKey:@"items"]) {
        RegionViewController *regionsView = [[RegionViewController alloc]init];
        [regionsView setRegions:[[_regions objectAtIndex:indexPath.row] objectForKey:@"items"]];
        [myController setArea:[[_regions objectAtIndex:indexPath.row] objectForKey:@"name"] code:[[_regions objectAtIndex:indexPath.row] objectForKey:@"code"]];
        [self.navigationController pushViewController:regionsView animated:YES];
    }else{        
        [myController setCityName:[[_regions objectAtIndex:indexPath.row] valueForKey:@"name"] code:[[_regions objectAtIndex:indexPath.row] valueForKey:@"code"]];
        [self.navigationController popToViewController:myController animated:YES];
         
    }
}



@end
