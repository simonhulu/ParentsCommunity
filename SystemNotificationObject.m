//
//  SystemNotificationObject.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "SystemNotificationObject.h"
#import "AppDelegate.h"
@implementation SystemNotificationObject
+(BOOL)save:(SystemNotificationObject*)aMessage
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSError *error;
    NSManagedObject *messages = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"SystemNotifications" inManagedObjectContext:deletage.managedObjectContext];
    [messages setValue:aMessage.userId forKey:@"userId"];
    [messages setValue:aMessage.content forKey:@"content"];
    [messages setValue:[[NSNumber alloc]initWithInt:aMessage.notificationType]forKey:@"notificationType"];
    [messages setValue:aMessage.notificationDate forKey:@"notificationDate"];
    [messages setValue:aMessage.roomId forKey:@"roomId"];
    [messages setValue:[[NSNumber alloc]initWithInt:aMessage.notificationStatus] forKey:@"notificationStatus"];
    [messages setValue:aMessage.notificationFrom forKey:@"notificationFrom"];
    [messages setValue:aMessage.notificationHead forKey:@"notificationHead"];
    [messages setValue:aMessage.notificationId forKey:@"notificationId"];
    if (![deletage.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }else
    {
        //更新最新的消息时间
        [[NSUserDefaults standardUserDefaults]setObject:aMessage.notificationDate forKey:kLastMessageDate];
        //发送全局通知 有新邮件
        [[NSNotificationCenter defaultCenter]postNotificationName:newNotificationCome object:nil];
        return YES;
    }
}

+(NSMutableArray*)fetchNotificationByOwnId:(NSString *)ownId
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSError *error;
//    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(ownId == %@)",ownId];
//    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"notificationDate" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetch setEntity:[NSEntityDescription entityForName:@"SystemNotifications" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    NSMutableArray *notificationList=[[NSMutableArray alloc]init];
    for (id obj in fetchObjects) {
        SystemNotificationObject *notification = [[SystemNotificationObject alloc]init];
        notification.notificationType = [[obj valueForKey:@"notificationType"]intValue];
        notification.notificationDate = [obj valueForKey:@"notificationDate"];
        notification.notificationStatus = [[obj valueForKey:@"notificationStatus"]intValue];
        notification.content = [obj valueForKey:@"content"];
        notification.roomId = [obj valueForKey:@"roomId"];
        notification.userId = [obj valueForKey:@"userId"];
        notification.notificationFrom = [obj valueForKey:@"notificationFrom"];
        notification.notificationHead = [obj valueForKey:@"notificationHead"];
        notification.notificationId = [obj valueForKey:@"notificationId"];
        [notificationList addObject:notification];
    }
    return notificationList;
}

+(NSMutableArray*)fetchUnReadNotificationByOwnId:(NSString *)ownId
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSError *error;
//    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(ownId == %@)",ownId];
//    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"notificationDate" ascending:NO];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetch setEntity:[NSEntityDescription entityForName:@"SystemNotifications" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    NSMutableArray *notificationList=[[NSMutableArray alloc]init];
    for (id obj in fetchObjects) {
        if([[obj valueForKey:@"notificationStatus"]intValue] ==kWCSystmNotificationUnRead)
        {
            SystemNotificationObject *notification = [[SystemNotificationObject alloc]init];
            notification.notificationType = [[obj valueForKey:@"notificationType"]intValue];
            notification.notificationDate = [obj valueForKey:@"notificationDate"];
            notification.notificationStatus = [[obj valueForKey:@"notificationStatus"]intValue];
            notification.content = [obj valueForKey:@"content"];
            notification.roomId = [obj valueForKey:@"roomId"];
            notification.userId = [obj valueForKey:@"userId"];
            notification.notificationFrom = [obj valueForKey:@"notificationFrom"];
            notification.notificationHead = [obj valueForKey:@"notificationHead"];
            notification.notificationId = [obj valueForKey:@"notificationId"];
            [notificationList addObject:notification];
        }
    }
    return notificationList;
}


+(SystemNotificationObject*)getLastSystemNotification:(NSString *)ownId
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSError *error;
//    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(ownId == %@)",ownId];
//    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"notificationDate" ascending:NO];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetch setEntity:[NSEntityDescription entityForName:@"SystemNotifications" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if([fetchObjects count]>0)
    {
        SystemNotificationObject *notification = [[SystemNotificationObject alloc]init];
        NSManagedObject *obj = fetchObjects[0];
        notification.notificationType = [[obj valueForKey:@"notificationType"]intValue];
        notification.notificationDate = [obj valueForKey:@"notificationDate"];
        notification.notificationStatus = [[obj valueForKey:@"notificationStatus"]intValue];
        notification.content = [obj valueForKey:@"content"];
        notification.roomId = [obj valueForKey:@"roomId"];
        notification.userId = [obj valueForKey:@"userId"];
        notification.notificationFrom = [obj valueForKey:@"notificationFrom"];
        notification.notificationHead = [obj valueForKey:@"notificationHead"];
        return notification;
    }
    return nil;
}


+(BOOL)changeNotificationReadStatus:(NSInteger)status
{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSError *error;
//    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(ownId == %@)",[WCUserObject getLoginUserId]];
//    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"notificationDate" ascending:NO];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetch setEntity:[NSEntityDescription entityForName:@"SystemNotifications" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    NSMutableArray *notificationList=[[NSMutableArray alloc]init];
    for (NSManagedObject *obj in fetchObjects) {
        if([[obj valueForKey:@"notificationStatus"]intValue] ==kWCSystmNotificationUnRead)
        {
            [obj setValue:[NSNumber numberWithInt:status]forKeyPath:@"notificationStatus"];

        }
    }
    return [delegate.managedObjectContext save:&error];
}
@end
