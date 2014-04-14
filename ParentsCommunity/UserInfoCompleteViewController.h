//
//  UserInfoCompleteViewController.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-15.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//Delegate Declaration
@protocol UNavigationControllerBackDelegate <NSObject>

@optional //These methods need to be implemented
-(void) backToViewControllerInStatck:(UIViewController*)viewController;
@end
@interface UserInfoCompleteViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate,UNavigationControllerBackDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UITextField *nickNammeTextField;
    UILabel *subNameLabel;
    UILabel *cityNameLabel;
    UILabel *gradeNameLabel;
}
@property(nonatomic,assign)NSInteger grade_tips;
-(void)setCityName:(NSString *)cityName code:(NSString *)code;
-(void)setGrade:(NSString *)grade code:(NSString *)code;;
-(void)setSubName:(NSString *)subName code:(NSString *)code;
-(void)setArea:(NSString *)areaName code:(NSString *)code;
@end
