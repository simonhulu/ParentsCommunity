//
//  MailCenterViewController.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-22.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "MailCenterViewController.h"
#import "SystemNotificationObject.h"
#import "MailBoxTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#define minnisizeCellHeight 60
@interface MailCenterViewController ()
{
    UITableView *_tableView;
    NSMutableArray *notifications;
}

@end

@implementation MailCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // self.view.backgroundColor =  [UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1];

            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1];
    if(IS_OS_7_OR_LATER)
    {
     _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-25)];
    }else{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height-10)];
    }

    [_tableView setBackgroundColor:[UIColor colorWithRed:0.976f green:0.976f blue:0.976f alpha:1]];
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    [self.view addSubview:_tableView];
    notifications = [SystemNotificationObject fetchNotificationByOwnId:[WCUserObject getLoginUserId]];
    // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // _tableView.separatorColor = [UIColor redColor];
    //更新系统消息至已读
    [SystemNotificationObject changeNotificationReadStatus:kWCSystmNotificationRead];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"收件箱";
    [self.navigationItem setTitleView:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma  ---mark---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [notifications count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sss";
    MailBoxTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[MailBoxTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor colorWithRed:0.878f green:0.878f blue:0.878f alpha:1]CGColor];
    }

    SystemNotificationObject *notification = [notifications objectAtIndex:indexPath.section];
    if(notification.notificationHead !=nil &&![notification.notificationHead isEqualToString:@""])
    {
        [cell.headImag setImageWithURL:[NSURL URLWithString:notification.notificationHead ]];
    }else {
          [cell.headImag setImage:[UIImage imageNamed:@"defaultUserHead"]];
    }

    NSDate *date = notification.notificationDate;
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString* dateString = [fmt stringFromDate:date];
    [cell.timeLabel setText:dateString];
    [cell.timeLabel sizeToFit];
    [cell.infoLabel setFrame:CGRectMake(77, 48, 210, 100)];
    [cell.infoLabel setText:notification.content];
    [cell.adminLabel setText:notification.notificationFrom];
    [cell.adminLabel sizeToFit];
  //  [cell.infoLabel setText:@"你在[网校测试群]被群主禁言1天"];
    [cell.infoLabel sizeToFit];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)] ;
//    if (section == integerRepresentingYourSectionOfInterest)
//        [headerView setBackgroundColor:[UIColor redColor]];
//    else
        [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumSize = CGSizeMake(200, 9999);
   SystemNotificationObject *notification = (SystemNotificationObject *)[notifications objectAtIndex:indexPath.section];
    NSString *dateString = notification.content;
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize dateStringSize = [dateString sizeWithFont:dateFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"%ld",(long)indexPath.section);
    NSLog(@"%@",notification.content);

    float theight = dateStringSize.height + 48 + 10;
    if(theight<60)
    {
        theight = 70 ;
    }
    NSLog(@"%f",theight);
   // NSAssert([dateString isEqualToString:@"你在[网校测试群]被群主禁言1天"], @"%f",theight);
    return theight;
}

#pragma ---UINavigationControllerDelegate---
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

@end
