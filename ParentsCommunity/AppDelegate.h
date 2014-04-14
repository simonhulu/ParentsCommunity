//
//  AppDelegate.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTabBarController.h"
#import "AudioToolBox/AudioToolbox.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    SystemSoundID mySound;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) ABTabBarController *topTabBarController;
@property(nonatomic,strong)NSArray *groupsRecord;
@property (nonatomic,assign) BOOL loginSuccessFlag;
@property(nonatomic,strong)NSData *itoken;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
