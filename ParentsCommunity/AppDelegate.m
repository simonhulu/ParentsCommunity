
//
//  AppDelegate.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ChatViewController.h"
#import "SendMessageViewController.h"
#import "GroupsViewController.h"
#import "MainTabViewController.h"
#import "ProfileViewController.h"
#import "MHTabBarController.h"
#import "ABTabBarController.h"
#import  "WCXMPPManager.h"
#import  "INavigationViewController.h"
#import "LoginViewController.h"
#import "UserInfoCompleteViewController.h"
#import "PersonalViewController.h"
#import "SystemNotificationObject.h"
#import "NetWorkManager.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"
#import "RequestManager.h"
@implementation AppDelegate
@synthesize managedObjectContext=_managedObjectContext;//session

@synthesize managedObjectModel=_managedObjectModel;
@synthesize navigationController = _navigationController;
@synthesize topTabBarController = _topTabBarController;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize groupsRecord = _groupsRecord;
@synthesize loginSuccessFlag,itoken;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    loginSuccessFlag = NO;
    [[NetWorkManager sharedInstance] startMoniter];
    [[NSUserDefaults standardUserDefaults] setObject:@"beta" forKey:iappVersion];
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"ls" ofType:@"m4af"];
    NSURL *audioURLPath = [NSURL fileURLWithPath:audioPath isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioURLPath, &mySound);
    //设置用户默认属性 立刻保存信息

    INavigationViewController *rootNavi = [[INavigationViewController alloc]init];
    [rootNavi.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    rootNavi.navigationBar.translucent = NO ;
    _navigationController = rootNavi;
    _navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.window.rootViewController =rootNavi ;
    
    [self.window makeKeyAndVisible]; //让设备知道我们想要收到推送通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoGroupPage) name:gotoMainGroupPageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNewNotification) name:newNotificationCome object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginhaveSuccess) name:loginSuccessNotification object:nil];
    [self autoLogin];
    NSLog(@"\n ===> 程序开始 !");
    return YES;
}

-(void)loginhaveSuccess
{
    loginSuccessFlag = YES;
   // [WCMessageObject getRemoteHistoryMsg];
    //发送token
    if(itoken)
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:submitItoken]];
        [request setPostValue:itoken forKey:@"token"];
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [[RequestManager sharedInstance] addRequest:request];
    }
}

-(void)toLoginPage
{
    LoginViewController *loginView = [[LoginViewController alloc]init];
    [_navigationController pushViewController:loginView animated:YES];
}
-(void)autoLogin
{
    NSString *account = [WCUserObject getLoginUserId] ;
    NSString *passwd = [WCUserObject getLoginUserPasswd];
    if(account!=nil &&passwd!=nil)
    {
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
            if([[[resultDic objectForKey:@"result"]valueForKey:@"status"]intValue] == 0)
            {
                //去登录界面
                [self toLoginPage];
            }else
            {
                
                //登录成功
                //发送token
                [WCXMPPManager sharedInstance];
                NSDictionary *userInfo = [[resultDic objectForKey:@"result"]valueForKey:@"data"];
                if([[userInfo valueForKey:@"grade"] isEqualToString:@""])
                {
                    //去完善资料
                    UserInfoCompleteViewController *userInfoView = [[UserInfoCompleteViewController alloc]init];
                    userInfoView.grade_tips = [[[[resultDic objectForKey:@"result"] objectForKey:@"data"] valueForKey:@"grade_tips"]intValue];
                    [_navigationController pushViewController:userInfoView animated:YES];

                }else{
                    
                    //准备用户 去群组页面
                    //从数据库中搜索出用户
                    WCUserObject *olduser=nil;
                    
                    olduser = [WCUserObject getUserById:account];

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
                    //如果为空则把用户写进数据库
                    if(!olduser)
                    {
                        
                        [WCUserObject saveNewUser:user];
                        
                    }
                    //否则则更新用户数据到数据库
                    else
                    {
                        [WCUserObject updateUser:user];
                    }
                    [WCUserObject updateLoginUserNickName:[userInfo valueForKey:@"nickname"]];
                    [WCUserObject updateLoginUserHead:user.userHead];
                    //去群组页面
                    [self gotoGroupPage];
                    //登录成功
                    [[NSNotificationCenter defaultCenter]postNotificationName:loginSuccessNotification object:nil];
                }
            }
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"%@",[error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }];
        [request startSynchronous];
    }else{
        [self toLoginPage];
    }
}


-(void)playNewNotification
{
     AudioServicesPlaySystemSound(mySound);
    //添加小圆点
    [_topTabBarController setMessageCircle];
}

-(void)gotoGroupPage
{
    if(_navigationController && _topTabBarController)
    {
        //重新登录
        __weak UIViewController *loginController = nil;
        for (UIViewController *tempViewController in _navigationController.viewControllers) {
            if (tempViewController == _topTabBarController) {
                loginController = _topTabBarController;

            }
        }
        if(loginController)
        {
            [_navigationController popToViewController:loginController animated:YES];
        }else{
            [_navigationController pushViewController:_topTabBarController animated:YES];
        }
            [_topTabBarController showViewControllerAtIndex:0];
        //切换账号 重新加载
        [WCXMPPManager sharedInstance];
        [[NSNotificationCenter defaultCenter]postNotificationName:getRemoteGroupListNotification object:nil];
    }else{
        NSMutableArray *tabBarItemsArray = [NSMutableArray new];
        GroupsViewController *groupsView = [[GroupsViewController alloc]initWithNibName:@"GroupsViewController" bundle:nil];
        
        groupsView.title = @"Tab 1";
        UIImage *defaultTabImage = [UIImage imageNamed:@"home_tab_default.png"];
        UIImage *selectedTabImage = [UIImage imageNamed:@"home_tab_selected.png"];
        AbTabBarItem *tabBarItem = [[AbTabBarItem alloc] initWithImage:defaultTabImage selectedImage:selectedTabImage viewController:groupsView];
        [tabBarItemsArray addObject:tabBarItem];
        ProfileViewController *profileView = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        profileView.title =@"Tab 2";
        UIImage *defaultTabImage2 = [UIImage imageNamed:@"me_tab_default.png"];
        UIImage *selectedTabImage2 = [UIImage imageNamed:@"me_tab_selected.png"];
        AbTabBarItem *tabBarItem2 = [[AbTabBarItem alloc] initWithImage:defaultTabImage2 selectedImage:selectedTabImage2 viewController:profileView];
        [tabBarItemsArray addObject:tabBarItem2];
        ABTabBarController *tabBarController = [[ABTabBarController alloc] init];
        tabBarController.tabBarHeight = 50;
        tabBarController.tabBarItems = tabBarItemsArray;
        tabBarController.backgroundImage = [UIImage imageNamed:@"tabbar_background.png"];
        _topTabBarController = tabBarController;
        // self.window.rootViewController =rootNavi ;
        _navigationController.delegate = tabBarController;
        [_navigationController pushViewController:tabBarController animated:YES];

    }
 
    NSMutableArray *notifications = [SystemNotificationObject fetchUnReadNotificationByOwnId:[WCUserObject getLoginUserId]];
    if([notifications count]>0)
    {
        //有未读消息
        [[NSNotificationCenter defaultCenter]postNotificationName:newNotificationCome object:nil];
    }
    
}

#pragma mark MHTabController delegate
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
    
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
    
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //挂起, 有电话或者home 或者切换到了其他程序
    NSLog(@"\n ===> 程序暂停 不激活状态!");
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:appResignActiveApi]];
    [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
    [[RequestManager sharedInstance] addRequest:request];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         NSLog(@"\n ===> 程序进入后台 !");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"\n ===> 挂起后重新进入 call程序进入前台!");
    if(loginSuccessFlag)
    {
        [[WCMessageObject sharedInstance] getRemoteHistoryMsg];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:appReactiveApp]];
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [[RequestManager sharedInstance] addRequest:request];
    }
    

}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //如果为在前台运行 则告诉服务器 我激活了
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [[WCMessageObject sharedInstance] getRemoteHistoryMsg];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:appReactiveApp]];
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [[RequestManager sharedInstance] addRequest:request];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"\n ===> 程序重新激活 !");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"\n ===> 程序意外退出 !");
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:appResignActiveApi]];
    [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
    [[RequestManager sharedInstance] addRequest:request];
}


//相当与持久化方法
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
//初始化context对象
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    //这里的URLForResource:@"lich" 的url名字（lich）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    //这个地方的lich.sqlite名字没有限制，就是一个数据库文件的名字
    NSString *userId = [WCUserObject getLoginUserId];
    NSString *sqlitename = [userId stringByAppendingString:@".sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:sqlitename];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    itoken = deviceToken;
    if(loginSuccessFlag)
    {
        ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:submitItoken]];
        __weak ASIFormDataRequest *request = _request;
        [request setPostValue:itoken forKey:@"token"];
        [request setPostValue:[WCUserObject getLoginUserId] forKey:@"username"];
        [[RequestManager sharedInstance] addRequest:request];
    }
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



@end
