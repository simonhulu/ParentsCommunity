//
//  ProfileViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-25.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "SystemNotificationObject.h"
#import "BTBadgeView.h"
#import "PersonalViewController.h"
#import "MailCenterViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface ProfileViewController ()
{
    WCUserObject *userInfo;
    BTBadgeView *badgeView;
    UIBarButtonItem *settingBarButtonItem ;
    UIImageView *headImage ;
    UILabel *nicknamelabel ;
    UILabel *userIdLabel ;
    UILabel *profileLabel;
}

@end

@implementation ProfileViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1];
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text =@"我";
    deletage.topTabBarController.navigationItem.titleView = label;
    headImage = [[UIImageView alloc]init];
    nicknamelabel = [[UILabel alloc]init];
    userIdLabel = [[UILabel alloc]init];

    [headImage setFrame:CGRectMake(20, 9, 46, 46)];
    NSString *userHead = [WCUserObject getLoginUserHead];
    if(userHead && ![userHead isEqualToString:@""])
    {
        [headImage setImageWithURL:[NSURL URLWithString:userHead]];
    }else{
        [headImage setImage:[UIImage imageNamed:@"defaultUserHead"]];
    }
    [self.view addSubview:headImage];
    [nicknamelabel setFrame:CGRectMake(74, 9, 100, 44)];
    NSString *nickName = [WCUserObject getLoginUserNickName];
    nicknamelabel.textAlignment = NSTextAlignmentLeft;
    nicknamelabel.text = nickName;
    [nicknamelabel sizeToFit];
    [self.view addSubview:nicknamelabel];
    
    UIImage *narrowImage = [UIImage imageNamed:@"graynarrow"];
    UIImageView *narrowImageView = [[UIImageView alloc]initWithImage:narrowImage];
    [narrowImageView setFrame:CGRectMake(self.view.bounds.size.width - 22 - narrowImageView.frame.size.width, 26, narrowImageView.frame.size.width, narrowImageView.frame.size.height)];
    [self.view addSubview:narrowImageView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 78)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(toPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    NSString *userId = [WCUserObject getLoginUserId];
    [userIdLabel setFrame:CGRectMake(74, 39, 100, 44)];
    userIdLabel.textAlignment = NSTextAlignmentLeft;
    userIdLabel.text = [NSString stringWithFormat:@"账号:%@",userId];
    [userIdLabel sizeToFit];
    [self.view addSubview:userIdLabel];
    
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(10, 70, 300, 90)];
    infoView.layer.borderColor =    [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    infoView.layer.borderWidth = 1.0f ;
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    
    [infoView addGestureRecognizer:tap];
    UILabel *titileLabel = [[UILabel alloc]init];
    profileLabel = [[UILabel alloc]init];
    titileLabel.textAlignment = NSTextAlignmentLeft;
    [titileLabel setFrame:CGRectMake(12.0f, 11.0f, 60, 30)];
    titileLabel.text =@"收件箱";
    [profileLabel setFrame:CGRectMake(12.0f, 44.0f, 260, 80)];
    profileLabel.textAlignment = NSTextAlignmentLeft;
    profileLabel.font = [UIFont systemFontOfSize:14];
    profileLabel.textColor = [UIColor colorWithRed:0.651f green:0.651f blue:0.651f alpha:1];
    NSMutableArray *notifications = [SystemNotificationObject fetchNotificationByOwnId:[WCUserObject getLoginUserId]];
    if(notifications)
    {
        if(notifications.count==0)
        {
            [profileLabel setText:@"信箱是空的,先去聊天吧"];
            
        }else
        {
            SystemNotificationObject *notification = [notifications lastObject];
            [profileLabel setText:notification.content];

        }
        
    }else{
     [profileLabel setText:@"信箱是空的,先去聊天吧"];
    }

    profileLabel.numberOfLines = 0 ;
    [profileLabel sizeToFit];
    [infoView addSubview:titileLabel];
    [infoView addSubview:profileLabel];
    
    UIImageView *narrowImageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"graynarrow"]];
    CGRect narrowFrame2 = narrowImageView2.frame;
    narrowFrame2.origin.y = 38;
    narrowFrame2.origin.x = infoView.frame.size.width - 12 - narrowFrame2.size.width;
    narrowImageView2.frame = narrowFrame2;
    [infoView addSubview:narrowImageView2];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 65.0f)];
    [path addLineToPoint:CGPointMake(320.0f, 65.0f)];
    //  Create a CAShapeLayer that uses that UIBezierPath:
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];;
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    //  Add that CAShapeLayer to your view's layer:
    [self.view.layer addSublayer:shapeLayer];
    
    settingBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(gotoSetting)];
    [deletage.topTabBarController.navigationItem setRightBarButtonItem:settingBarButtonItem];
    //[titileLabel sizeToFit];
    badgeView = [[BTBadgeView alloc]initWithFrame:CGRectMake(60, 0, 30, 30)];
    badgeView.shine = NO;
    badgeView.shadow = NO ;
    badgeView.value =@"";
    [infoView addSubview:badgeView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserHead) name:refreshUserHead object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserNickName) name:refreshUserNickName object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	   
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
        UILabel *label = (UILabel *)deletage.topTabBarController.navigationItem.titleView;
    label.text = @"我";
    deletage.topTabBarController.navigationItem.titleView = label;
    [deletage.topTabBarController.navigationItem setRightBarButtonItem:settingBarButtonItem];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //to Mail Center
    MailCenterViewController *viewController ;
        AppDelegate *delegate = [UIApplication sharedApplication].delegate ;
    for (UIViewController *tempViewController in self.navigationController.viewControllers) {
        if([tempViewController isKindOfClass:[MailCenterViewController class]])
        {
            viewController = tempViewController;
        }
    }

    if(!viewController)
    {
        viewController = [[MailCenterViewController alloc]init];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                       target:nil
                                       action:nil];
        delegate.topTabBarController.navigationItem.backBarButtonItem =backButton;
        [delegate.topTabBarController.navigationController pushViewController:viewController animated:YES];
    }else{
        [delegate.topTabBarController.navigationController popToViewController:viewController animated:NO];
    }
    badgeView.value = @"";
    //去除notification badge
    [[NSNotificationCenter defaultCenter]postNotificationName:newNotificationChecked object:nil];

}


-(void)updateUserHead
{
    NSString *userHead = [WCUserObject getLoginUserHead];
    if(userHead && ![userHead isEqualToString:@""])
    {
        [headImage setImageWithURL:[NSURL URLWithString:userHead]];
    }else{
        [headImage setImage:[UIImage imageNamed:@"defaultUserHead"]];
    }
}

-(void)updateUserNickName
{
    NSString *nickName = [WCUserObject getLoginUserNickName];
    nicknamelabel.textAlignment = NSTextAlignmentLeft;
    nicknamelabel.text = nickName;
    [nicknamelabel sizeToFit];
}
-(void)toPersonalPage
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate ;
    PersonalViewController *viewController = [[PersonalViewController alloc]init];
    [ appdelegate.topTabBarController.navigationController pushViewController:viewController animated:YES];
}

#pragma ---mark---
-(void)setWCuser:(WCUserObject *)user
{
    userInfo = user;
}
-(void)gotoSetting
{
    SettingViewController *settingView = [[SettingViewController alloc]init];
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    [deletage.navigationController pushViewController:settingView animated:YES];
}

#pragma ---ABTabBarController---
-(void)abTabControllerWillAdd
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    UILabel *label = (UILabel *)deletage.topTabBarController.navigationItem.titleView;
    label.text = @"我";


    NSString *nickName = [WCUserObject getLoginUserNickName];
    nicknamelabel.textAlignment = NSTextAlignmentLeft;
    nicknamelabel.text = nickName;
    [nicknamelabel sizeToFit];
    NSString *userId = [WCUserObject getLoginUserId];
    userIdLabel.textAlignment = NSTextAlignmentLeft;
    userIdLabel.text = [NSString stringWithFormat:@"账号:%@",userId];
    [userIdLabel sizeToFit];
    NSMutableArray *notifications = [SystemNotificationObject fetchUnReadNotificationByOwnId:userId];
   if([notifications count]>0)
   {
       badgeView.value = [NSString stringWithFormat:@"%d",[notifications count] ];
       //badgeView.badgeTextFont = [UIFont boldSystemFontOfSize:18];
       SystemNotificationObject *notification = (SystemNotificationObject *)[notifications objectAtIndex:0];
       [profileLabel setText:notification.content];
        profileLabel.numberOfLines = 0 ;

   }
}

#pragma  mark ---INavigationViewControllerDelegate
-(void)navigationWillShowTheView
{
    [self abTabControllerWillAdd];
}

@end
