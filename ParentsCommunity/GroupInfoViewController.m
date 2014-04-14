//
//  GroupInfoViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-16.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "ApplyGroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface GroupInfoViewController ()
{
    UIImageView *roomIcon;
    UIView *infoView;
    UILabel *adminNameLabel;
    GroupObject *group;
}

@end

@implementation GroupInfoViewController
//@synthesize roomIcon;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    groupName =[[UILabel alloc]initWithFrame:CGRectMake(74, 10, 100, 44)];
    groupName.text = group.name;
    [groupName sizeToFit];
    totalPeopleNum = [[UILabel alloc]initWithFrame:CGRectMake(74, 32, 100, 44)];
    totalPeopleNum.text = [NSString stringWithFormat:@"%d",group.roomMember];
    [totalPeopleNum sizeToFit];
    [self.view addSubview:groupName];
    [self.view addSubview:totalPeopleNum];
    roomIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 46, 46)];
    [self.view addSubview:roomIcon];
    [roomIcon setImageWithURL:[NSURL URLWithString:group.roomIconUrl]];
    infoView = [[UIView alloc]initWithFrame:CGRectMake(10, 79, 300, 128)];
    infoView.layer.borderColor =    [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    infoView.layer.borderWidth = 1.0f ;
    [self.view addSubview:infoView];
    adminNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, 200, 44)];
    adminNameLabel.text = group.roomAdmin;
    adminNameLabel.textColor = [UIColor colorWithRed:0.651f green:0.651f blue:0.651f alpha:1];
    [self.view addSubview:adminNameLabel];
    UILabel *adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(19, 80, 100, 44)];
    adminLabel.text = @"群主";
    [self.view addSubview:adminLabel];
    
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(19, 120, 100, 44)];
    descriptionLabel.text = @"简介";
    [self.view addSubview:descriptionLabel];
    
    UILabel *descriptionInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 130, 180, 300)];
    descriptionInfoLabel.text = group.roomIntroduction;
    descriptionInfoLabel.textAlignment = NSTextAlignmentLeft;
    descriptionInfoLabel.textColor = [UIColor colorWithRed:0.651f green:0.651f blue:0.651f alpha:1];

    [descriptionInfoLabel setNumberOfLines:0];
    [descriptionInfoLabel sizeToFit];
    [self.view addSubview:descriptionInfoLabel];
    [infoView setFrame:CGRectMake(10, 79, 300, descriptionInfoLabel.frame.size.height+descriptionInfoLabel.frame.origin.y+5 - 79)];
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0.0, 65.0)];
//    [path addLineToPoint:CGPointMake(320.0f, 65.0)];
//  Create a CAShapeLayer that uses that UIBezierPath:
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = [path CGPath];
//    shapeLayer.strokeColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];;
//    shapeLayer.lineWidth = 1.0;
//    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//  Add that CAShapeLayer to your view's layer:
//    [self.view.layer addSublayer:shapeLayer];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(10.0, 120.0)];
    [path1 addLineToPoint:CGPointMake(310.0f, 120.0)];
    //  Create a CAShapeLayer that uses that UIBezierPath:
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = [path1 CGPath];
    shapeLayer1.strokeColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];;
    shapeLayer1.lineWidth = 1.0;
    shapeLayer1.fillColor = [[UIColor clearColor] CGColor];
    //  Add that CAShapeLayer to your view's layer:
    [self.view.layer addSublayer:shapeLayer1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"群资料";
    [self.navigationItem setTitleView:label];
    
    if(group.isAlreadyIn==0)
    {
        if(group.isNeedVerify==0)
        {
            UIButton *appleButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 286, 300, 44)];
            [appleButton addTarget:self action:@selector(joinGroup) forControlEvents:UIControlEventTouchUpInside];
            appleButton.backgroundColor = [UIColor colorWithRed:0.345f green:0.671f blue:0.122 alpha:1];
            [appleButton setTitle:@"加入" forState:UIControlStateNormal];
            [self.view addSubview:appleButton];
        }else{
            UIButton *appleButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 286, 300, 44)];
            
            appleButton.backgroundColor = [UIColor colorWithRed:0.345f green:0.671f blue:0.122 alpha:1];
            [appleButton setTitle:@"申请加入" forState:UIControlStateNormal];
            [appleButton addTarget:self action:@selector(toApplyPage) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:appleButton];
        }
    }else{
        if(group.grouptype == NormalGroup)
        {
            UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 286, 300, 44)];
            
            exitButton.backgroundColor = [UIColor colorWithRed:0.961f green:0.200f blue:0.192f alpha:1];
            [exitButton setTitle:@"退出分舵" forState:UIControlStateNormal];
            [exitButton addTarget:self action:@selector(exitGroup) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:exitButton];
        }

    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showApplyMsg) name:sendApplyMsg object:nil];
    // Do any additional setup after loading the view from its nib.
}


-(void)showApplyMsg
{
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
        HUD.delegate = self;
    }
   	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    HUD.labelText = @"申请成功";
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
}

-(void)exitGroup
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出群" message:@"您确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ---business---
-(void)setGroup:(GroupObject *)groupinfo
{
    group = groupinfo;
}
-(void)toApplyPage
{
    ApplyGroupViewController *applyView = [[ApplyGroupViewController alloc]init];
    applyView.rid = group.roomXMPPid;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:applyView animated:YES];
}
-(void)joinGroup
{
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:joinGroupApi]];
    __weak ASIFormDataRequest *request = _request;
    [request setPostValue:[WCUserObject getLoginUserId]  forKey:@"username"];
    [request setPostValue:group.roomXMPPid forKey:@"rid"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *result = [parser objectWithString:responseString];
        if([[result objectForKey:@"result"] valueForKey:@"status"]==0)
        {
            NSLog(@"%@",[[result objectForKey:@"result"] valueForKey:@"data"]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"加入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            [self showWaitingCompleteIndicator];
            [[NSNotificationCenter defaultCenter]postNotificationName:getRemoteGroupListNotification object:nil];
//            AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
//            NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
//            NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(roomXMPPid == %@)",group.roomXMPPid];
//            fetch.predicate = preTemplate;
//            [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
//            NSError *error;
//            NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
//            NSManagedObject *obj = fetchObjects[0];
//            
//            [obj setValue:[NSNumber numberWithInt:1] forKey:@"isAlreadyIn"];
//            if([deletage.managedObjectContext save:&error])
//            {
//                [self.navigationController popViewControllerAnimated:YES ];
//                [[NSNotificationCenter defaultCenter]postNotificationName:refreshGroupsNotification object:nil];
//            }else
//            {
//                DDLogInfo(@"%@",@"更新群组加入状态失败!");
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"加入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
        }
        
    }];
    [request setFailedBlock:^{
        
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

#pragma ---UIAlertViewDelegate---
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        //取消
        
    }else if (buttonIndex ==1)
    {
        //确定
        ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:exitGroupApi]];
        __weak ASIFormDataRequest *request = _request;
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [request setPostValue:group.roomXMPPid forKey:@"rid"];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *result = [parser objectWithString:responseString];
            [self showWaitingCompleteIndicator];
            if([[result objectForKey:@"result"] valueForKey:@"status"]==0)
            {
               
                HUD.mode = MBProgressHUDModeText;
                HUD.labelText =@"退出失败";
                [HUD hide:YES afterDelay:2];
                
            }else{
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
                HUD.mode = MBProgressHUDModeCustomView;
                [HUD hide:YES afterDelay:2];
                [self performSelector:@selector(sendNoti) withObject:nil afterDelay:1];

            }
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"%@",error);
            NSLog(@"%@",[[request url] debugDescription]);
        }];
        [request startAsynchronous];
        [self showLoading];
    }
}

-(void)sendNoti
{
                 [[NSNotificationCenter defaultCenter]postNotificationName:exitTheGroup object:group.roomXMPPid];
}

@end

