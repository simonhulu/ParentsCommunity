//
//  SelectRoleViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "SelectRoleViewController.h"
#import "UserInfoCompleteViewController.h"
@interface SelectRoleViewController ()
{
    NSArray *_tableSource;
}

@end

@implementation SelectRoleViewController
@synthesize tableView;
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
    tableView.delegate = self;
    tableView.dataSource = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---tableview---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_tableSource)
    {
        return [_tableSource count];
    }else{
        return  0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"fff";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = [_tableSource objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma ---business---
-(void)setTableSource:(NSArray *)array
{
    _tableSource = array;
    [tableView reloadData];
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
        [myController setSubName:[_tableSource objectAtIndex:indexPath.row] code:[NSString stringWithFormat:@"%d",indexPath.row]];
        [self.navigationController popToViewController:myController animated:YES];
    
}

@end
