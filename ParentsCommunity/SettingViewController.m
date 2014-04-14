//
//  SettingViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-17.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "INavigationViewController.h"
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "RequestManager.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-44-40-44, 300, 44)];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    exitButton.backgroundColor = [UIColor colorWithRed:0.961f green:0.200f blue:0.192f alpha:1];
    [exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self ;
    [tableView setFrame:CGRectMake(10, 160, 300, 88)];
    tableView.layer.borderWidth = 1.0f;
    tableView.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)] || IS_OS_7_OR_LATER) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view from its nib.
    UIView *infoview = [[UIView alloc]initWithFrame:CGRectMake(10, 23, 300, 44)];
    [self.view addSubview:infoview];
    [infoview setBackgroundColor:[UIColor whiteColor]];
    infoview.layer.borderWidth = 1.0f;
    infoview.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    UILabel *infoLabel = [[UILabel alloc]init];
    [infoLabel setFrame:CGRectMake(25, 0, 250, 44)];
    infoLabel.text = @"新消息/系统通知提醒";
    UILabel *isOn = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, 100, 44)];
    isOn.textColor = [UIColor colorWithRed:0.804f green:0.804f blue:0.804f alpha:1];
    isOn.text = @"已开启";
    [infoview addSubview:infoLabel];
    [infoview addSubview:isOn];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 44)];
    [tipLabel setFont:[UIFont systemFontOfSize:14]];
    tipLabel.text = @"如果你要关闭或开启新消息的通知,请在手机的\"设置\"-\"通知\"功能中,找到应用程序\"家长会\"进行更改";
    tipLabel.numberOfLines = 0 ;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [tipLabel sizeToFit];
    [self.view addSubview:tipLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"设置";
    [self.navigationItem setTitleView:label];
    
};

-(void)exit
{
//    LoginViewController *loginView = [[LoginViewController alloc]init];
//    INavigationViewController *rootNavi = [[INavigationViewController alloc]initWithRootViewController:loginView];
//    [rootNavi.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
//    rootNavi.navigationBar.translucent = NO ;
//    [self presentViewController:rootNavi animated:YES completion:^{
//        
//    }];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *viewController=nil;
    for (id obj in delegate.navigationController.viewControllers) {
        if([obj isKindOfClass:[LoginViewController class]])
            {
                viewController = obj;
                [delegate.navigationController popToViewController:obj animated:YES];
            }
    }
    if(!viewController)
    {
        [delegate.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:userLoginOutApi]];
    [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
    [[RequestManager sharedInstance] addRequest:request];
    //[[WCXMPPManager sharedInstance] disconnect];
    //[[WCXMPPManager sharedInstance] teardownStream];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(indexPath.row ==0 )
    {
        cell.textLabel.text = @"关于家长会";
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"检查更新";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                       target:nil
                                       action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController pushViewController:[[AboutViewController alloc]init] animated:YES];
    }else
    {
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



@end
