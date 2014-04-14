//
//  AboutViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-29.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.navigationItem.title = @"关于家长会";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    UIImage *image = [UIImage imageNamed:@"logo-120-120.png"];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(self.view.bounds.size.width/2 - 60, 28, 120, 120)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"家长会";
    [label setFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+10, self.view.bounds.size.width, 20)];
    [label setFont:[UIFont systemFontOfSize:20]];
    label.textAlignment = NSTextAlignmentCenter ;
    [self.view addSubview:label];
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:iappVersion];
    [versionLabel setFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height+6, self.view.bounds.size.width, 14)];
    versionLabel.textAlignment = NSTextAlignmentCenter ;
    [self.view addSubview:versionLabel];
    // Do any additional setup after loading the view.
    UIButton *rateBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-33.75, self.view.bounds.size.height -130, 68, 33)];
    [rateBtn setBackgroundImage:[UIImage imageNamed:@"rateIcon"] forState:UIControlStateNormal];
    [self.view addSubview:rateBtn];
    [rateBtn addTarget:self action:@selector(toRate) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleViewlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    titleViewlabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleViewlabel.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    titleViewlabel.textColor = [UIColor whiteColor]; // change this color
    titleViewlabel.text = @"关于家长会";
    [self.navigationItem setTitleView:titleViewlabel];
}

-(void)toRate
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
