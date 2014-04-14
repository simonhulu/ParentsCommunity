//
//  WCUserObject.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCUserObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "AppDelegate.h"
@implementation WCUserObject
@synthesize userHead,userId,userNickname,friendFlag,password,cityName,gradeName,subName,grade_tips;


+(BOOL)saveNewUser:(WCUserObject*)aUser
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSError *error;
    NSManagedObject *messages = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:deletage.managedObjectContext];
    [messages setValue:aUser.userId forKey:@"userId"];
    [messages setValue:aUser.password forKey:@"password"];
    [messages setValue:aUser.userHead forKey:@"userHead"];
    [messages setValue:aUser.cityName forKey:@"cityName"];
    [messages setValue:aUser.gradeName forKey:@"gradeName"];
    [messages setValue:aUser.userNickname forKey:@"userNickname"];
    [messages setValue:aUser.subName forKey:@"subName"];
    [messages setValue:[NSNumber numberWithInt: aUser.grade_tips] forKey:@"grade_tips"];
    if(![deletage.managedObjectContext save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}


+(WCUserObject *)getLoginAccount
{
    NSString *userId = [WCUserObject getLoginUserId];
    WCUserObject *user = [self getUserById:userId];
    return user;
}

+(WCUserObject *)getUserById:(NSString *)userId
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(userId == %@)",userId];
    fetch.predicate = preTemplate;
    [fetch setEntity:[NSEntityDescription entityForName:@"Users" inManagedObjectContext:deletage.managedObjectContext]];
    NSError *error;
    NSArray *fetchObjects = [deletage.managedObjectContext executeFetchRequest:fetch error:&error];
    if([fetchObjects count]>0)
    {
        NSManagedObject *obj = fetchObjects[0];
        WCUserObject *user = [[WCUserObject alloc]init];
        user.userId = [obj valueForKey:@"userId"];
        user.userNickname = [obj valueForKey:@"userNickname"];
        user.userHead = [obj valueForKey:@"userHead"];
        user.subName = [obj valueForKey:@"subName"];
        user.password = [obj valueForKey:@"password"];
        user.gradeName = [obj valueForKey:@"gradeName"];
        user.cityName = [obj valueForKey:@"cityName"];
        user.grade_tips = [[obj valueForKey:@"grade_tips"] intValue];
        return user;
    }
    return nil;
   }

+(BOOL)haveSaveUserById:(NSString*)userId
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return YES;
    };
    [WCUserObject checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select count(*) from wcUser where userId=?",userId];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
    
}
+(BOOL)deleteUserById:(NSNumber*)userId
{
    return NO;

}
+(BOOL)updateUser:(WCUserObject*)newUser
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(userId == %@)",newUser.userId];
    fetch.predicate = preTemplate;
    NSError *error;
    [fetch setEntity:[NSEntityDescription entityForName:@"Users" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if( [fetchObjects count]>0)
    {
        NSManagedObject *obj = fetchObjects[0];
        [delegate.managedObjectContext deleteObject:obj];
         return [WCUserObject saveNewUser:newUser];
    }else{
        return [WCUserObject saveNewUser:newUser];
    }
    return NO;
}



//+(NSMutableArray*)fetchAllFriendsFromLocal
//{
//    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return resultArr;
//    };
//    [WCUserObject checkTableCreatedInDb:db];
//    
//    FMResultSet *rs=[db executeQuery:@"select * from wcUser where friendFlag=?",[NSNumber numberWithInt:1]];
//    while ([rs next]) {
//        WCUserObject *user=[[WCUserObject alloc]init];
//        user.userId=[rs stringForColumn:kUSER_ID];
//        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
//        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
//        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
//        user.friendFlag=[NSNumber numberWithInt:1];
//        [resultArr addObject:user];
//    }
//    [rs close];
//    return resultArr;
//    
//}
//
//+(WCUserObject*)userFromDictionary:(NSDictionary*)aDic
//{
//    WCUserObject *user=[[WCUserObject alloc]init];
//    [user setUserId:[[aDic objectForKey:kUSER_ID]stringValue]];
//    [user setUserHead:[aDic objectForKey:kUSER_USERHEAD]];
//    [user setUserDescription:[aDic objectForKey:kUSER_DESCRIPTION]];
//    [user setUserNickname:[aDic objectForKey:kUSER_NICKNAME]];
//    return user;
//}
//
//-(NSDictionary*)toDictionary
//{
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userId,kUSER_ID,userNickname,kUSER_NICKNAME,userDescription,kUSER_DESCRIPTION,userHead,kUSER_USERHEAD,friendFlag,kUSER_FRIEND_FLAG, nil];
//    return dic;
//}


+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'wcUser' ('userId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'userNickname' VARCHAR, 'userDescription' VARCHAR, 'userHead' VARCHAR,'friendFlag' INT)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;

}

+(NSString *)getLoginUserId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID];
    return userId;
}

+(NSString *)getLoginUserPasswd
{
    NSString *passwd = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD];
    return passwd;
}

+(NSString *)getLoginUserNickName
{
    NSString *nickName = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_NICKNAME];
    return nickName;
}

+(BOOL)updateLoginUserNickName:(NSString *)nickName
{
    [[NSUserDefaults standardUserDefaults]setObject:nickName forKey:kMY_USER_NICKNAME];
    WCUserObject *user = [WCUserObject getLoginAccount];
    user.userNickname = nickName;
    [WCUserObject updateUser:user];
    [[NSNotificationCenter defaultCenter]postNotificationName:refreshUserNickName object:nil];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)updateLoginUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:kMY_USER_ID];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)updateLoginUserPasswd:(NSString *)passwd
{
    [[NSUserDefaults standardUserDefaults]setObject:passwd forKey:kMY_USER_PASSWORD];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getLoginUserHead
{
    NSString *userHead = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head];
    return userHead;
}

+(BOOL)updateLoginUserHead:(NSString *)head
{
    [[NSUserDefaults standardUserDefaults]setObject:head forKey:kMY_USER_Head];
    WCUserObject *user = [WCUserObject getLoginAccount];
    user.userHead = head;
    [WCUserObject updateUser:user];
    [[NSNotificationCenter defaultCenter]postNotificationName:refreshUserHead object:nil];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getRoleStr:(NSInteger)roleindex
{
    NSDictionary *regions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"i" ofType:@"plist"]];
    return [[regions objectForKey:@"roles"] objectAtIndex:roleindex];
}



@end
