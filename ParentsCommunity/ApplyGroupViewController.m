//
//  ApplyGroupViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-16.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ApplyGroupViewController.h"

@interface ApplyGroupViewController ()

@end

@implementation ApplyGroupViewController
@synthesize dTextField,rid;
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
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendApply)];
    [self.navigationItem setRightBarButtonItem:barItem];
    dTextField.placeholder = @"请输入申请验证信息,最多16个字";
    dTextField.layer.borderWidth =1.0f;
    dTextField.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    UILabel *titleViewlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    titleViewlabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleViewlabel.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    titleViewlabel.textColor = [UIColor whiteColor]; // change this color
    titleViewlabel.text = @"关于家长会";
    [self.navigationItem setTitleView:titleViewlabel];

}

-(void)sendApply
{
    [dTextField resignFirstResponder];
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:applyGroupApi]];
    __weak ASIFormDataRequest *request = _request;
    [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
    [request setPostValue:rid forKey:@"rid"];
    [request setPostValue:dTextField.text forKey:@"applyInfo"];
    [request setCompletionBlock:^{

        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *result = [parser objectWithString:responseString];
        [self showWaitingCompleteIndicator];

        

        if([[result objectForKey:@"result"] valueForKey:@"status"]==0)
        {


        }else{
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:sendApplyMsg object:nil];
        }
    }];
    
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    [self showLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = nil ;
    if(HUD ==nil)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:HUD];
    }
   HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
   HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"提交成功";
    sleep(2);
    [HUD hide:YES afterDelay:4];
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;


}

@end
