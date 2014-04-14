//
//  UserInfoCompleteViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "UserInfoCompleteViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "RegionViewController.h"
#import "GradeViewController.h"
#import "SelectRoleViewController.h"
#import "ItestViewController.h"
#import "AppDelegate.h"

@interface UserInfoCompleteViewController ()
{
    NSMutableDictionary *_subNameDic;
    NSMutableDictionary *_gradeDic;
    NSMutableDictionary *_cityDic;
    NSMutableDictionary *_areaDic;
    MBProgressHUD *HUD;
}

@end

@implementation UserInfoCompleteViewController
@synthesize grade_tips;
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
    _subNameDic = [[NSMutableDictionary alloc]init];
    _gradeDic = [[NSMutableDictionary alloc]init];
    _cityDic = [[NSMutableDictionary alloc]init];
    _areaDic = [[NSMutableDictionary alloc]init];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 44)];
    [titleName setFont:[UIFont systemFontOfSize:18]];
    titleName.text = @"您的身份";
    [titleName sizeToFit];
    [self.view addSubview:titleName];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    UIImage *arrowImage = [UIImage imageNamed:@"graynarrow"];
    [nickNammeTextField setTextColor:[UIColor colorWithRed:0.639f green:0.639f blue:0.639f alpha:1]];
    nickNammeTextField = [[UITextField alloc]initWithFrame:CGRectMake(4, 8, 142, 28)];
    [nickNammeTextField setFont:[UIFont systemFontOfSize:16]];
    nickNammeTextField.placeholder = @"孩子的名字";
    

    
    UIView *nickNameBgView = [[UIView alloc]initWithFrame:CGRectMake(10, titleName.frame.origin.y +titleName.frame.size.height+5, 150, 44)];
    nickNameBgView.layer.borderWidth = 1.0f ;
    nickNameBgView.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    [nickNameBgView addSubview:nickNammeTextField];
    [self.view addSubview:nickNameBgView];
    
    UIView *subNameView = [[UIView alloc]initWithFrame:CGRectMake(167, titleName.frame.origin.y +titleName.frame.size.height+5, 143, 44)];
    subNameView.layer.borderWidth = 1.0f ;
    subNameView.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    subNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 8, 142, 28)];
    [subNameLabel setFont:[UIFont systemFontOfSize:16]];
    [subNameLabel setTextColor:[UIColor colorWithRed:0.639f green:0.639f blue:0.639f alpha:1]];
    subNameLabel.textAlignment = NSTextAlignmentLeft;
    subNameLabel.text = @"身份:如爸爸";
    [subNameView addSubview:subNameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:arrowImage];
    arrowImageView.frame= CGRectMake(124, 15, arrowImage.size.width, arrowImage.size.height) ;
    [subNameView addSubview:arrowImageView];
    [self.view addSubview:subNameView];
    UITapGestureRecognizer *subNameTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSubName:)];
    [subNameView addGestureRecognizer:subNameTapGesture];

    UILabel *cityTitleName = [[UILabel alloc]initWithFrame:CGRectMake(10, subNameView.frame.origin.y+subNameView.frame.size.height+10, 300, 44)];
    [cityTitleName setFont:[UIFont systemFontOfSize:18]];
    cityTitleName.text = @"您的城市";
    [cityTitleName sizeToFit];
    [self.view addSubview:cityTitleName];
    
    UIView *cityView = [[UIView alloc]initWithFrame:CGRectMake(10, cityTitleName.frame.origin.y + cityTitleName.frame.size.height+5, 300, 44)];
    cityView.layer.borderWidth = 1.0f ;
    cityView.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 8, 300, 28)];
    [cityNameLabel setFont:[UIFont systemFontOfSize:16]];
    [cityNameLabel setTextColor:[UIColor colorWithRed:0.639f green:0.639f blue:0.639f alpha:1]];
    
    cityNameLabel.textAlignment = NSTextAlignmentLeft;
    cityNameLabel.text = @"选择省,市";
    [cityView addSubview:cityNameLabel];
    UIImageView *arrowImageView2 = [[UIImageView alloc]initWithImage:arrowImage];
    arrowImageView2.frame= CGRectMake(281, 15, arrowImage.size.width, arrowImage.size.height) ;
    [cityView addSubview:arrowImageView2];
    UITapGestureRecognizer *regionTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeRegion:)];
    [cityView addGestureRecognizer:regionTapGesture];
    [self.view addSubview:cityView];
    
    UILabel *gradeoff =  [[UILabel alloc]initWithFrame:CGRectMake(10, cityView.frame.origin.y+cityView.frame.size.height+10, 222, 21)];
    [self.view addSubview:gradeoff];
    if(grade_tips ==0)
    {
       gradeoff.text =    @"孩子今年1到6月所在年级";
    }else
    {
       gradeoff.text =    @"孩子今年6到12月所在年级";
    }
    
    UIView *gradeView = [[UIView alloc]initWithFrame:CGRectMake(10, gradeoff.frame.origin.y+gradeoff.frame.size.height+5, 300, 44)];
    gradeView.layer.borderWidth = 1.0f ;
    gradeView.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    
    gradeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 8, 142, 28)];
    [gradeNameLabel setFont:[UIFont systemFontOfSize:16]];
    [gradeNameLabel setTextColor:[UIColor colorWithRed:0.639f green:0.639f blue:0.639f alpha:1]];
    gradeNameLabel.textAlignment = NSTextAlignmentLeft;
    gradeNameLabel.text = @"选择年级";
    [gradeView addSubview:gradeNameLabel];
    UIImageView *arrowImageView3 = [[UIImageView alloc]initWithImage:arrowImage];
    arrowImageView3.frame= CGRectMake(281, 15, arrowImage.size.width, arrowImage.size.height) ;
    [gradeView addSubview:arrowImageView3];
    UITapGestureRecognizer *gradeTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeGrade:)];
    [gradeView addGestureRecognizer:gradeTapGesture];
    
    
    [self.view addSubview:gradeView];
//    [gradeNameButton setFrame:CGRectMake(10, 260, 300, 44)];
//    gradeNameButton.layer.borderWidth = 1.0f;
//    gradeNameButton.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
//    [gradeNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [gradeNameButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
//    [gradeNameButton setTitle:@"选择年级" forState:UIControlStateNormal];
//    [gradeNameButton setTitleColor:[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1] forState:UIControlStateNormal];
//    [gradeNameButton setImage:[UIImage imageNamed:@"graynarrow"] forState:UIControlStateNormal];
//    [gradeNameButton setImageEdgeInsets:UIEdgeInsetsMake(15.0f, gradeNameButton.frame.size.width-20, 10.0f, 0.0f) ];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(completeEdit)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    UIView *fff = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    [fff setBackgroundColor:[UIColor colorWithRed:0.996f green:0.933f blue:0.933f alpha:1]];
    [self.view addSubview:fff];
    UILabel *sssLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width-10, 45)];
    sssLabel.textAlignment = NSTextAlignmentLeft;
    [sssLabel setFont:[UIFont systemFontOfSize:14]];
    [sssLabel setText:@"如果资料错误,我们将无法给您提供合适的服务。一旦确认后不可更改,请谨慎填写"];
    sssLabel.numberOfLines = 0 ;
    sssLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [sssLabel sizeToFit];
    [fff addSubview:sssLabel];
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"完善个人资料";
    [self.navigationItem setTitleView:label];
}


#pragma mark ---触摸关闭键盘---
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //变成第一响应
    [self.view endEditing:YES];
}

#pragma ---business---

-(void)completeEdit
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"如果资料错误,我们将无法给您提供合适的服务,资料一旦确认后不可更改,确认资料无误?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //检查
        if([_subNameDic valueForKey:@"name"] && [_cityDic valueForKey:@"name"] && [_gradeDic valueForKey:@"name"])
        {
            NSString *username = [WCUserObject getLoginUserId];
            NSString *nickname = nickNammeTextField.text;
            NSString *subName = [_subNameDic valueForKey:@"code"];
            NSString *grade = [_gradeDic valueForKey:@"code"];
            NSString *area = [_areaDic valueForKey:@"code"];
            NSString *city = [_cityDic valueForKey:@"code"];
            ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:completeUerInfoApi]];
            __weak ASIFormDataRequest *request = _request;
            [request setPostValue:username forKey:@"username"];
            [request setPostValue:nickname forKey:@"nickname"];
            [request setPostValue:subName forKey:@"sex"];
            [request setPostValue:grade forKey:@"grade"];
            [request setPostValue:area forKey:@"area"];
            [request setPostValue:city forKey:@"city"];
            [request setCompletionBlock:^{
                [self showWaitingCompleteIndicator];
                NSString *responseString = [request responseString];
                SBJsonParser *parser = [[SBJsonParser alloc]init
                                        ];
                NSDictionary *userDic = [parser objectWithString:responseString];
                
                WCUserObject *user = [[WCUserObject alloc]init];
                NSDictionary *userDataDic = [[userDic objectForKey:@"result"] objectForKey:@"data"];
                user.cityName = [userDataDic valueForKey:@"cityname"];
                user.gradeName = [userDataDic valueForKey:@"gradename"];
                user.password =  [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD ];
                NSDictionary *regions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"i" ofType:@"plist"]];
                
                user.subName = [[regions objectForKey:@"roles"] objectAtIndex:[[userDataDic valueForKey:@"sex"]isEqualToString:@""]?0:[[userDataDic valueForKey:@"sex"]intValue]];
                user.userHead = [userDataDic valueForKey:@"himg"];
                user.userId = [WCUserObject getLoginUserId];
                user.userNickname = [userDataDic valueForKey:@"nickname"];
                if([WCUserObject updateUser:user])
                {
                    
                    [WCUserObject updateLoginUserNickName:user.userNickname];
                    [WCUserObject updateLoginUserHead:user.userHead];
                    [[NSNotificationCenter defaultCenter]postNotificationName:gotoMainGroupPageNotification object:nil];

                }
                //保存用户
            }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@"%@",error);
                NSLog(@"%@",[[request url] debugDescription]);
            }];
            [request startAsynchronous];
            [self showLoading];
        }

    }else if(buttonIndex == 0)
    {
        
    }
}

-(void)showLoading
{
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
    }
}

-(void)showWaitingCompleteIndicator
{
    if(HUD ==nil)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
    }
    HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
    [NSThread sleepForTimeInterval:1];
    
}


-(void)changeSubName:(UITapGestureRecognizer *)recognizer
{
        [self.view endEditing:YES];
    NSDictionary *regions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"i" ofType:@"plist"]];
    SelectRoleViewController *rolessView = [[SelectRoleViewController alloc]init];
    [rolessView setTableSource:[regions objectForKey:@"roles"]];
    [self.navigationController pushViewController:rolessView animated:YES];

}

-(void)changeGrade:(UITapGestureRecognizer *)recognizer
{
        [self.view endEditing:YES];
    NSDictionary *regions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"i" ofType:@"plist"]];
    GradeViewController *gradesView = [[GradeViewController alloc]init];
    [gradesView setTableSource:[regions objectForKey:@"grades"]];
    [self.navigationController pushViewController:gradesView animated:YES];
}

-(void)backToViewControllerInStatck:(UIViewController *)viewController
{
    if(!viewController)
    {
        [self.navigationController popToViewController:self animated:YES];
    }else{
        [self.navigationController popToViewController:viewController animated:YES];
    }
}
-(void)changeRegion:(UITapGestureRecognizer *)recognizer
{
        [self.view endEditing:YES];
    NSArray *regions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"]];
    RegionViewController *regionsView = [[RegionViewController alloc]init];
    [regionsView setRegions:regions];
    [self.navigationController pushViewController:regionsView animated:YES];
}

-(void)setCityName:(NSString *)cityName code:(NSString *)code
{
    [_cityDic setValue:cityName forKey:@"name"];
    [_cityDic setValue:code forKey:@"code"];
    NSString *fullCityName = [NSString stringWithFormat:@"%@%@",[_areaDic objectForKey:@"name"],cityName];
    [cityNameLabel setTextColor:[UIColor blackColor]];
    [cityNameLabel setText:fullCityName];
}
-(void)setGrade:(NSString *)grade code:(NSString *)code
{
    [_gradeDic setValue:grade forKey:@"name"];
    [_gradeDic setValue:code forKey:@"code"];
    [gradeNameLabel setTextColor:[UIColor blackColor]];
    [gradeNameLabel setText:grade];
}

-(void)setSubName:(NSString *)subName code:(NSString *)code
{
    [_subNameDic setValue:subName forKey:@"name"];
    [_subNameDic setValue:code forKey:@"code"];
    [subNameLabel setTextColor:[UIColor blackColor]];
    [subNameLabel setText:subName];
}

-(void)setArea:(NSString *)areaName code:(NSString *)code
{
    [_areaDic setValue:areaName forKey:@"name"];
    [_areaDic setValue:code forKey:@"code"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
