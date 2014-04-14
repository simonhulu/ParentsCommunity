//
//  PersonalViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-19.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "PersonalViewController.h"
#import "MBProgressHUD.h"
#import "PersonalUITableViewCell.h"
#import "ModifyNameViewController.h"

#import "ASIHttpRequest/ASIFormDataRequest.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface PersonalViewController ()
{
    MBProgressHUD *HUD;
    UIImageView *headImage;
    UITableView *_tableView;
    WCUserObject *user;
    
}

@end

@implementation PersonalViewController

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
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 300, 100)];
    button.layer.borderColor =  [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    button.layer.borderWidth =1.0f;
    UIImageView *narrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"graynarrow"]];
    CGRect narrowFrame = narrowImageView.frame;
    narrowFrame.origin.y = 40;
    narrowFrame.origin.x = button.frame.size.width - 12 - narrowFrame.size.width;
    narrowImageView.frame = narrowFrame;
    [button addSubview:narrowImageView];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,35, 100, 44)];
    headLabel.text = @"头像";
    [headLabel sizeToFit];
    [button addSubview:headLabel];
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake(200, 20, 60, 60)];
    [button addSubview:headImage];
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = self.view.bounds.size.width/2 - buttonFrame.size.width/2;
    button.frame = buttonFrame;
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(modifyHeadImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderWidth =1.0f;
    _tableView.layer.borderColor =  [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    button.layer.borderWidth =1.0f;
    CGRect tableviewFrame = _tableView.frame;
    tableviewFrame.origin.x =10 ;
    tableviewFrame.origin.y = 134.0F;
    tableviewFrame.size.width = 300 ;
    tableviewFrame.size.height =175 ;
    _tableView.frame = tableviewFrame;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    user = [WCUserObject getLoginAccount];
    
    
}

-(void)modifyHeadImg
{
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger imageSourceType;
    switch (buttonIndex) {
        case 0:
            imageSourceType = UIImagePickerControllerSourceTypeCamera ;
            break;
        case 1:
            imageSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            return ;
            break;
        default:
            return ;
            break;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    [imgPicker setSourceType:imageSourceType];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [self.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}


#pragma mark delegate progress
-(void)setProgress:(float)newProgress
{
    NSLog(@"value: %f",newProgress);
}

#pragma mark ---图片选择完成---
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        UIImage *compressImage = [self compressForUpload:chosedImage scale:0.125f];
        [self uploadHeadImage:compressImage];
    }];
}

-(void)uploadHeadImage:(UIImage *)image
{
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:uploadHeadImageApi]];
    __weak ASIFormDataRequest *request = _request;
    [request setUploadProgressDelegate:self];
    NSString *userId = [WCUserObject getLoginUserId];
    [request setPostValue:userId forKey:@"username"];
    [request setData:UIImagePNGRepresentation(image) forKey:@"img"];
    [request setCompletionBlock:^{
        [self showWaitingCompleteIndicator];
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *result = [parser objectWithString:responseString];
        if([[result objectForKey:@"result"] valueForKey:@"status"]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            //设置新头像
            NSString *userHead = [[[result objectForKey:@"result"]objectForKey:@"data"]valueForKey:@"himg"];
            [WCUserObject updateLoginUserHead:userHead];
            
            [self setHeadImage];
        }

        
    }];
    [request setFailedBlock:^{
        if(HUD ==nil)
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
        }
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"上传失败";
        HUD.margin = 10.f;
        HUD.yOffset = 150.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        [NSThread sleepForTimeInterval:1];
    }];
    [request startAsynchronous];
    [self showLoading];
}

-(void)showLoading
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
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




-(void)setHeadImage
{
    NSString *userHead = [WCUserObject getLoginUserHead];
    if(userHead && ![userHead isEqualToString:@""])
    {
        [headImage setImageWithURL:[NSURL URLWithString:userHead ]];
    }else{
        [headImage setImage:[UIImage imageNamed:@"defaultUserHead"]];
    }
}


#pragma ---UITableView Delegate---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    PersonalUITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[PersonalUITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.639f green:0.639f blue:0.639f alpha:1]];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"孩子的名字";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"家长的身份";
                break;
            case 2:
                cell.textLabel.text = @"就读的地区";
                break;
            case 3:
                cell.textLabel.text = @"孩子的年纪";
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)] || IS_OS_7_OR_LATER) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    switch (indexPath.row) {
        case 0:
            [cell setPersonalInfo:[WCUserObject getLoginUserNickName]];
            break;
        case 1:
            [cell setPersonalInfo:user.subName];
            break;
        case 2:
            [cell setPersonalInfo:user.cityName];
            break;
        case 3:
            [cell setPersonalInfo:user.gradeName];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(indexPath.row == 0 )
     {
         ModifyNameViewController *myController =nil;
//         NSInteger count = [self.navigationController.viewControllers count];
//         for (int i=0; i< count; i++) {
//             UIViewController *viewController = [self.navigationController.viewControllers  objectAtIndex:i];
//             if([viewController isKindOfClass:[ModifyNameViewController class]])
//             {
//                 myController = viewController;
//             }
//         }
         if(!myController)
         {
             myController = [[ModifyNameViewController alloc]init];
         }
         [myController setName:user.userNickname];
         UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@""
                                        style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
         self.navigationItem.backBarButtonItem = backButton;
         [self.navigationController pushViewController:myController animated:YES];
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

#pragma ---INavigationControllerDelegate---
-(void)navigationWillShowTheView
{
    //重新设置头像
    [self setHeadImage];
    [_tableView reloadData];
}

@end
