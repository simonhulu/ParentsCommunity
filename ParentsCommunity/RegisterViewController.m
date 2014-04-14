//
//  RegisterViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-14.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoCompleteViewController.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation RegisterViewController

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
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    registeForm = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, 132) style:UITableViewStylePlain];
    registeForm.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    registeForm.layer.borderWidth = 1.0f;
    registeForm.delegate = self;
    registeForm.dataSource = self;
    [self.view addSubview:registeForm];
    if ([registeForm respondsToSelector:@selector(setSeparatorInset:)] || IS_OS_7_OR_LATER) {
        [registeForm setSeparatorInset:UIEdgeInsetsZero];
    }
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(toRegiste)];
    
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    showPassWordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    showPassWordBtn.frame = CGRectMake(260, 7, 30, 30) ;
    [showPassWordBtn setTitle:@"显示" forState:UIControlStateNormal];
    [showPassWordBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
    [showPassWordBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
  //  [showPassWordBtn setBackgroundColor:[UIColor redColor]];
    UILabel *dd = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 44)];
    [dd setFont:[UIFont systemFontOfSize:12]];
    [dd setTextColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1]];
    [dd setText:@"点击注册表示已经阅读并同意"];
    [dd sizeToFit];
    [self.view addSubview:dd];
    UIButton *linkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [linkBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [linkBtn setTitle:@"用户服务协议" forState:UIControlStateNormal];
    linkBtn.frame = CGRectMake(151, 160, 100, 15);
    [linkBtn addTarget:self action:@selector(oprnUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:linkBtn];
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"注册学而思网校账号";
    [self.navigationItem setTitleView:label];
    // Do any additional setup after loading the view from its nib.
}


-(void)oprnUrl
{
    UIViewController *viewController = [[UIViewController alloc]init];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [viewController.view addSubview:webView];
    NSURL *url =[NSURL URLWithString:@"http://www.xueersi.com/article/detail/1316"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 键盘处理
#pragma mark ---触摸关闭键盘---
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //变成第一响应
    [self.view endEditing:YES];
}

#pragma mark --键盘高度变化---
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获得到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyboardBeginBounds CGRectValue];
    
    //获得到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    //拿到frame变化之后的origin.y变化之前的origin.y,其差值(带正负号)就是我们self.view的y方向上的增量
    NSLog(@"delatY:%f",deltaY);
    NSTimeInterval duration = 0.4f;
    [CATransaction begin];
    if(deltaY >0)
    {
        duration = 0.2f;
    }
    [UIView animateWithDuration:duration animations:^{
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
//        [msgRecordTable setContentInset:UIEdgeInsetsMake(msgRecordTable.contentInset.top-deltaY, 0, 0, 0)];
        
    } completion:^(BOOL finished) {
    }];
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = nil ;
    static NSString *identifier = @"RegisteEmailTableViewCell";
    if(indexPath.row == 0)
    {
        identifier = @"RegisteEmailTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 7, 230, 30)];
            cell.textLabel.text = @"账号";
            accountTextField.placeholder = @"必须填写邮箱";
            [cell.contentView addSubview:accountTextField];
        }
    }else if (indexPath.row == 1)
    {
        identifier = @"RegistePasswdTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            passwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 7, 230, 30)];
            cell.textLabel.text = @"密码";
            passwdTextField.placeholder = @"至少6个字符";
            [cell.contentView addSubview:passwdTextField];
            [cell.contentView addSubview:showPassWordBtn];
        }
        passwdTextField.secureTextEntry = YES;
        
    }else if (indexPath.row == 2)
    {
        identifier = @"PhoneTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 7, 230, 30)];
            cell.textLabel.text = @"手机";
            phoneNumberTextField.placeholder = @"用于找回密码";
            [cell.contentView addSubview:phoneNumberTextField];
        }
        
    }
    return cell;
}


#pragma mark -------business--------
-(void)showPassword
{
    if(passwdTextField.secureTextEntry)
    {
        passwdTextField.secureTextEntry = NO;
        [showPassWordBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    }else
    {
        passwdTextField.secureTextEntry = YES;
        [showPassWordBtn setTitle:@"显示" forState:UIControlStateNormal];
    }
}

-(void)toRegiste
{
    [self.view endEditing:YES];
    NSString *account = accountTextField.text;
    NSString *passwd = passwdTextField.text;
    NSString *phoneNumber = phoneNumberTextField.text;
    
    if([account isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"账号必须填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }else if([passwd isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"必须填写密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else if ([phoneNumber isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"必须填写手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:registeAccount]];
    
    __weak ASIFormDataRequest *request = _request;
    [request setPostValue:account forKey:@"username"];
    [request setPostValue:passwd forKey:@"password"];
    [request setPostValue:phoneNumber forKey:@"mobile"];
    [request setCompletionBlock:^{
        [self showWaitingCompleteIndicator];
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *resultDic = [parser objectWithString:responseString];
        if([[[resultDic objectForKey:@"result"]valueForKey:@"status"] intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[[resultDic objectForKey:@"result"]valueForKey:@"data"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            //创建新用户
            WCUserObject *userObj = [[WCUserObject alloc]init];
            userObj.userId = account;
            userObj.password = passwd;
            userObj.userHead = [[[resultDic objectForKey:@"result"]objectForKey:@"data"]valueForKey:@"himg"];
            userObj.userNickname = [[[resultDic objectForKey:@"result"]objectForKey:@"data"]valueForKey:@"nickname"];
            userObj.cityName = [[[resultDic objectForKey:@"result"]objectForKey:@"data"]valueForKey:@"cityname"];
            userObj.gradeName = [[[resultDic objectForKey:@"result"]objectForKey:@"data"]valueForKey:@"gradename"];
            userObj.subName = @"";
            [WCUserObject updateLoginUserId:userObj.userId];
            [WCUserObject updateLoginUserPasswd:userObj.password];
            [WCUserObject saveNewUser:userObj];
            if([userObj.userNickname isEqualToString:@""])
            {
                //如果资料为空跳转到用户资料页面
                UserInfoCompleteViewController *completeUserInfoView = [[UserInfoCompleteViewController alloc]init];
                [self.navigationController pushViewController:completeUserInfoView animated:YES];
            }
        }

    }];
    [request setFailedBlock:^{
        DDLogVerbose(@"%@:%@",THIS_FILE,THIS_METHOD);
    }];
    [request startAsynchronous];
    [self showLoading];
}

-(void)showLoading
{
	HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
	HUD.delegate = self;
}
-(void)showWaitingCompleteIndicator
{
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}



@end
