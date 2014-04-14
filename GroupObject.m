//
//  GroupObject.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-26.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "GroupObject.h"
#import "AppDelegate.h"
@implementation GroupObject

+(BOOL)save:(NSArray *)groups refreshdate:(NSInteger)refreshdate
{
//    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
//    if(![db open])
//    {
//        NSLog(@"数据库打开失败");
//        return NO;
//    }
//    NSString *createStr = @"CREATE  TABLE  IF NOT EXISTS 'groups' ('groupId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE ,'roomXMPPid' VARCHAR,'name' VARCHAR,'roomIconUrl' VARCHAR,'roomIntroduction' VARCHAR,'roomMember' INTEGER,'isAlreadyIn' INTEGER,'isNeedVerify' INTEGER,'isShowRedFlag' INTEGER,'newMessageNumer' INTEGER,'roomAdmin' VARCHAR,'refreshdate' INTEGER,'grouptype' INTEGER)";
//    BOOL worked = [db executeUpdate:createStr];
//    FMDBQuickCheck(worked);
//    
//    NSString *insertStr = @"INSERT INTO 'groups' ('roomXMPPid','name','roomIconUrl','roomIntroduction','roomMember','isAlreadyIn','isNeedVerify','isShowRedFlag','newMessageNumer','roomAdmin','refreshdate','grouptype')VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
//    int i = 0 ;
//    for (GroupObject *group in groups) {
//        NSLog(@"%@",group.roomXMPPid);
//        NSLog(@"%@",group.name);
//        NSLog(@"%@",group.roomIconUrl);
//        NSLog(@"%@",group.roomIntroduction);
//        NSLog(@"%ld",(long)group.roomMember);
//        NSLog(@"%d",group.isAlreadyIn);
//        NSLog(@"%d",group.isNeedVerify);
//        NSLog(@"%d",group.isShowRedFlag);
//        NSLog(@"%d",group.newMessageNumer);
//        NSLog(@"%@",group.roomAdmin);
//        NSLog(@"%d",refreshdate);
//        NSLog(@"%d",group.grouptype);
//
//        
//        worked = [db executeUpdate:insertStr,group.roomXMPPid,group.name,group.roomIconUrl,group.roomIntroduction,group.roomMember,group.isAlreadyIn,group.isNeedVerify,
//                  group.isShowRedFlag,group.newMessageNumer,group.roomAdmin,refreshdate,group.grouptype];
//        FMDBQuickCheck(worked);
//        i++;
//    }
//
//    [db close];
//    
//    //发送全局通知
    
    return YES;
}


+(NSArray *)fetchGroupsWithUser
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
    NSError *error;
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    NSArray *groupRecords = [[NSArray alloc]init];
    for (id obj in fetchObjects) {
        GroupObject *group = [[GroupObject alloc]init];
        group.roomXMPPid = [obj valueForKey:@"roomXMPPid"];
        group.roomIconUrl = [obj valueForKey:@"roomIconUrl"];
        group.roomIntroduction = [obj valueForKey:@"roomIntroduction"];
        group.roomMember = [[obj valueForKey:@"roomMember"] intValue];
        group.isAlreadyIn = [[obj valueForKey:@"isAlreadyIn"] intValue];
        group.isNeedVerify = [[obj valueForKey:@"isNeedVerify"] intValue];
        group.grouptype = [[obj valueForKey:@"grouptype"] intValue];
        group.roomAdmin = [obj valueForKey:@"roomAdmin"];
        group.name = [obj valueForKey:@"name"];
        group.speakstate = [[obj valueForKey:@"speakstate"] intValue];
        groupRecords=  [groupRecords arrayByAddingObject:group];
        //如果该群已加入
    }
    return groupRecords;
}


+(GroupObject *)getGroupByid:(NSString *)roomXMPPid
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(roomXMPPid == %@)",roomXMPPid];
    fetch.predicate = preTemplate;
    [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
    NSError *error;
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    if([fetchObjects count]>0)
    {
        NSManagedObject *obj = fetchObjects[0];
        GroupObject *group = [[GroupObject alloc]init];
        group.roomXMPPid = [obj valueForKey:@"roomXMPPid"];
        group.roomIconUrl = [obj valueForKey:@"roomIconUrl"];
        group.roomIntroduction = [obj valueForKey:@"roomIntroduction"];
        group.roomMember = [[obj valueForKey:@"roomMember"] intValue];
        group.isAlreadyIn = [[obj valueForKey:@"isAlreadyIn"] intValue];
        group.isNeedVerify = [[obj valueForKey:@"isNeedVerify"] intValue];
        group.grouptype = [[obj valueForKey:@"grouptype"] intValue];
        group.roomAdmin = [obj valueForKey:@"roomAdmin"];
        group.name = [obj valueForKey:@"name"];
        group.speakstate = [[obj valueForKey:@"speakstate"] intValue];
        return group;
    }
    return nil;
}

+(void)deleteGroupById:(NSString *)roomXMPPid
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(roomXMPPid == %@)",roomXMPPid];
    fetch.predicate = preTemplate;
    [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
    NSError *error;
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    if([fetchObjects count]>0)
    {
        NSManagedObject *obj = fetchObjects[0];
        [deletage.managedObjectContext deleteObject:obj];
    }
}

+(BOOL )updateGroup:(GroupObject *)newGroup
{

    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(roomXMPPid == %@)",newGroup.roomXMPPid];
    fetch.predicate = preTemplate;
    [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
    NSError *error;
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    if([fetchObjects count]>0)
    {
        NSManagedObject *obj = fetchObjects[0];
        [deletage.managedObjectContext deleteObject:obj];
        return [GroupObject save:newGroup];
    }
    return NO;
}

+(NSArray *)fetchJoinedGroupsWithUser
{
    NSArray *groups = [self fetchGroupsWithUser];
    NSArray *joinedGroup = [[NSArray alloc]init];
    for (GroupObject *obj in groups) {
        if(obj.isAlreadyIn == 1)
        {
            joinedGroup = [joinedGroup arrayByAddingObject:obj];
        }
    }
    return joinedGroup;
}
+(void)deleteAllGroup
{
    NSError *error;
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    //先删除原来的group记录
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext]];
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    for (id obj in fetchObjects) {
        [deletage.managedObjectContext deleteObject:obj];
    }
}

+(BOOL)save:(GroupObject *)group
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSManagedObject *groups = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:deletage.managedObjectContext];
    NSError *error;
    [groups setValue:group.roomXMPPid forKey:@"roomXMPPid"];
    [groups setValue:group.name forKey:@"name"];
    [groups setValue:group.roomIconUrl forKey:@"roomIconUrl"];
    [groups setValue:group.roomIntroduction forKey:@"roomIntroduction"];
    [groups setValue:[NSNumber numberWithInt: group.roomMember]  forKey:@"roomMember"];
    [groups setValue:[NSNumber numberWithInt:group.isAlreadyIn] forKey:@"isAlreadyIn"];
    [groups setValue:[NSNumber numberWithInt:group.isNeedVerify] forKey:@"isNeedVerify"];
    [groups setValue:group.roomAdmin forKey:@"roomAdmin"];
    [groups setValue:[NSNumber numberWithInt:group.grouptype] forKey:@"grouptype"];
    [groups setValue:[NSNumber numberWithInt:group.speakstate] forKeyPath:@"speakstate"];
    if (![deletage.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }else{
        NSLog(@"name=%@   speakstate=%d",group.name,group.speakstate);
        return YES;
    }
    
}


+(void)banSpeak:(NSString *)roomId
{
    GroupObject *group = [GroupObject getGroupByid:roomId];
    group.speakstate = 1;
    [GroupObject updateGroup:group];
    [[NSNotificationCenter defaultCenter]postNotificationName:banSendMessage object:nil];
}
+(void)reCoverSpeak:(NSString *)roomId
{
    GroupObject *group = [GroupObject getGroupByid:roomId];
    group.speakstate = 0;
    [GroupObject updateGroup:group];
    [[NSNotificationCenter defaultCenter]postNotificationName:reCoverSendMessage object:nil];
}
@end
