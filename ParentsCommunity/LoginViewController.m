//
//  LoginViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "LoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "LoginTableViewCell.h"
#import "PasswdTableViewCell.h"
#import "RegisterViewController.h"
#import "UserInfoCompleteViewController.h"
#import "ErrorMsgView.h"
#import "AppDelegate.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"
@interface LoginViewController ()
{
    __weak UITextField *accountTextField;
    __weak UITextField *passwdTextField;
}

@end

@implementation LoginViewController
@synthesize loginForm;
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
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
    loginForm.layer.borderWidth = 1.0f;
    loginForm.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    if ([loginForm respondsToSelector:@selector(setSeparatorInset:)]) {
        [loginForm setSeparatorInset:UIEdgeInsetsZero];
    }
    loginForm.scrollEnabled = NO;
    loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 122, 300, 44)];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:0.353f green:0.565f blue:0.886f alpha:1]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRegistePage)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"登录家长会";
    [self.navigationItem setTitleView:label];
}


-(void)gotoRegistePage
{
    RegisterViewController *registerView = [[RegisterViewController alloc]init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    [self.navigationController pushViewController:registerView animated:YES];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---business---
-(void)loginAction
{
    
    NSString *account = accountTextField.text;
    NSString *passwd = passwdTextField.text;
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:loginApi]];
    __weak ASIFormDataRequest *request = _request;
    [request setPostValue:account forKey:@"username"];
    [request setPostValue:passwd forKey:@"password"];
    NSUUID *identifier = [UIDevice currentDevice].identifierForVendor ;
    [request setPostValue:[identifier UUIDString] forKey:@"clientId"];
    [request setPostValue:@"ios" forKey:@"clientType"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *resultDic = [parser objectWithString:responseString];
        [self showWaitingCompleteIndicator];
        if([[[resultDic objectForKey:@"result"]valueForKey:@"status"]intValue] == 0)
        {
            DDLogInfo(@"%@",[[resultDic objectForKey:@"result"]valueForKey:@"data"]);


            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[[resultDic objectForKey:@"result"]valueForKey:@"data"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }else
        {

            //登录成功
            [WCUserObject updateLoginUserId:account];
            [WCUserObject updateLoginUserPasswd:passwd];
            [WCXMPPManager sharedInstance];
            NSDictionary *userInfo = [[resultDic objectForKey:@"result"]valueForKey:@"data"];
            if([[userInfo valueForKey:@"grade"] isEqualToString:@""])
            {
                //去完善资料
                WCUserObject *user = [[WCUserObject alloc]init];
                user.userId = account;
                user.password = passwd;
                [WCUserObject saveNewUser:user];
                UserInfoCompleteViewController *userInfoView = [[UserInfoCompleteViewController alloc]init];
                [self.navigationController pushViewController:userInfoView animated:YES];
            }else{
                
                //准备用户 去群组页面
                //从数据库中搜索出用户
                WCUserObject *olduser=nil;
                
                olduser = [WCUserObject getUserById:account];
                //如果为空则把用户写进数据库
                WCUserObject *user = [[WCUserObject alloc]init];
                user.userId = account;
                NSString *cityName =[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"cityname"];
                NSString *areaName = [[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"areaname"];
                user.cityName = [NSString stringWithFormat:@"%@%@",areaName,cityName];
                user.gradeName = [[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"gradename"];
                user.password = passwd;
                NSInteger inde =[[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"sex"] intValue];
                user.subName = [WCUserObject getRoleStr:inde];
                user.userHead =[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"himg"];
                user.userNickname =[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"nickname"];
                user.grade_tips = [[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"grade_tips"]intValue];
                if(!olduser)
                {
                    [WCUserObject saveNewUser:user];
                    
                }else{
                    [WCUserObject updateUser:user];
                }
                [WCUserObject updateLoginUserNickName:user.userNickname];
                [WCUserObject updateLoginUserHead:user.userHead];
                [[NSNotificationCenter defaultCenter]postNotificationName:gotoMainGroupPageNotification object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:loginSuccessNotification object:nil];
            }
        }
    }];
    [request setFailedBlock:^{
        [self showWaitingCompleteIndicator];
        NSError *error = [request error];
        NSLog(@"%@",[error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"网络错误 " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }];
    [request startAsynchronous];
    [self.view endEditing:YES];
    [self showLoading];
}

-(void)showLoading
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.dimBackground = YES;
    //Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void)showWaitingCompleteIndicator
{
    if(HUD ==nil)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    [NSThread sleepForTimeInterval:1];
    
}
#pragma mark -----tableview delegate------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"normal";
    UITableViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.textLabel.text = @"123";
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    if(indexPath.row == 0)
    {
        static NSString *identifier = @"username";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [LoginTableViewCell cellFromNibNamed:@"LoginTableViewCell"];
            accountTextField = ((LoginTableViewCell *)cell).loginTextField;
        }
    }else if(indexPath.row ==1)
    {
        static NSString *passIdentifier = @"passwd";
        cell = [tableView dequeueReusableCellWithIdentifier:passIdentifier];
        if(!cell)
        {
            cell = [PasswdTableViewCell cellFromNibNamed:@"PasswdTableViewCell"];
            passwdTextField = ((PasswdTableViewCell *)cell).passwdTextField;
        }
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
