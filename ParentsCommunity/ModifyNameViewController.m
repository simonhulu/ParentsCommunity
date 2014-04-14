//
//  ModifyNameViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-21.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ModifyNameViewController.h"
#import "WCUserObject.h"
@interface ModifyNameViewController ()
{
    UITextField *nameField ;
    MBProgressHUD *HUD;
}

@end

@implementation ModifyNameViewController

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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    nameField = [[UITextField alloc]init];
    [nameField setFrame:CGRectMake(10, 27, 300, 44)];
    nameField.layer.borderWidth = 1.0f ;
    nameField.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    nameField.placeholder = @"孩子的名字";
    nameField.text = [WCUserObject getLoginUserNickName];
    [self.view addSubview:nameField];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(modifyName)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)modifyName
{
    if([nameField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"孩子名字不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:completeUerInfoApi]];
        __weak ASIFormDataRequest *request = _request;
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [request setPostValue:nameField.text forKey:@"nickname"];
        
        [request setCompletionBlock:^{
            [self showWaitingCompleteIndicator];
            NSString *reponseString = [request responseString];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *dic = [parser objectWithString:reponseString];
            if([[dic objectForKey:@"result"] valueForKey:@"status"]==0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else{
                NSString *newNickName = [[[dic objectForKey:@"result"] objectForKey:@"data"]valueForKey:@"nickname"];
                [WCUserObject updateLoginUserNickName:newNickName];
                [self resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
        [request startAsynchronous];
        [self showLoading];
    }
}
-(void)setName:(NSString *)name
{
   // nameField.text = name;
    if(nameField)
    {
        nameField.text = name;
    }
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

-(void)showLoading
{
    if(!HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES] ;
        HUD.delegate = self;
    }

}
-(void)showWaitingCompleteIndicator
{
   if(!HUD)
   {
       
   }
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
