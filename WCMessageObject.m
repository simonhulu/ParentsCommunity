//
//  WCMessageObject.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCMessageObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import  "AppDelegate.h"
#import "GroupObject.h"
#import "RequestManager.h"
#import "SystemNotificationObject.h"
@implementation WCMessageObject
__strong static WCMessageObject *instance = nil ;
@synthesize messageContent,messageDate,messageFrom,messageTo,messageType,messageId,messageRoom,headimg,messageSendXMPPid,imageLocalPath,imageURLPath,messageStatus,messageReadFlag;

+(WCMessageObject *)sharedInstance
{
    static dispatch_once_t pred = 0 ;
    dispatch_once(&pred, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


+(WCMessageObject *)messageWithType:(int)aType{
    
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageType:aType];
    return  msg;
}
+(WCMessageObject*)messageFromDictionary:(NSDictionary*)aDic
{
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageFrom:[aDic objectForKey:kMESSAGE_FROM]];
    [msg setMessageTo:[aDic objectForKey:kMESSAGE_TO]];
    [msg setMessageContent:[aDic objectForKey:kMESSAGE_CONTENT]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_DATE]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_TYPE]];
    return  msg;
}


//将对象转换为字典
-(NSDictionary*)toDictionary
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:messageId,kMESSAGE_ID,messageFrom,kMESSAGE_FROM,messageTo,kMESSAGE_TO,messageContent,kMESSAGE_TYPE,messageDate,kMESSAGE_DATE,messageType,kMESSAGE_TYPE, nil];
    return dic;
    
}

//增删改查

+(BOOL)save:(WCMessageObject*)aMessage
{

    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    NSError *error;
    WCMessageObject *lastMessage = [WCMessageObject getLastMessageByRoom:aMessage.messageRoom];
    if(lastMessage && lastMessage.messageType != kWCMessageTypeDateTip)
    {
        NSManagedObject *messageNMObject = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:deletage.managedObjectContext];
        NSDate *lastMessageDate = lastMessage.messageDate;
        NSTimeInterval lastTimeInterval = [lastMessageDate timeIntervalSince1970];
        NSTimeInterval currentTimeInterval = [aMessage.messageDate timeIntervalSince1970];
        long long lastTime = [[NSNumber numberWithDouble:lastTimeInterval]longLongValue];
        long long currentTime = [[NSNumber numberWithDouble:currentTimeInterval]longLongValue];
        if((currentTime - lastTime)>=300)
        {
            //生产tip消息
            WCMessageObject *tipmessage = [[WCMessageObject alloc]init];
            tipmessage.messageType = kWCMessageTypeDateTip;
            tipmessage.messageDate  = aMessage.messageDate;
            tipmessage.messageRoom = aMessage.messageRoom;
            [messageNMObject setValue:[NSNumber numberWithInteger:tipmessage.messageType] forKey:@"messageType"];
            [messageNMObject setValue:tipmessage.messageDate forKeyPath:@"messageDate"];
            [messageNMObject setValue:tipmessage.messageRoom forKeyPath:@"messageRoom"];
            if (![deletage.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                //return NO;
            }
        }
    }
    NSManagedObject *messages = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:deletage.managedObjectContext];
    [messages setValue:aMessage.messageFrom forKey:@"messageFrom"];
    [messages setValue:aMessage.messageTo forKey:@"messageTo"];
    [messages setValue:aMessage.messageContent forKey:@"messageContent"];
    [messages setValue:aMessage.messageDate forKey:@"messageDate"];
    [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageType] forKey:@"messageType"];
    [messages setValue:aMessage.messageId forKey:@"messageId"];
    [messages setValue:aMessage.messageRoom forKey:@"messageRoom"];
    [messages setValue:aMessage.messageSendXMPPid forKey:@"messageSendXMPPid"];
    [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageStatus] forKey:@"messageStatus"];
    [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageReadFlag ] forKeyPath:@"messageReadFlag"];
    [messages setValue:aMessage.imageLocalPath forKeyPath:@"imageLocalPath"];
    [messages setValue:aMessage.imageURLPath forKey:@"imageURLPath"];
        [messages setValue:aMessage.headimg forKey:@"headimg"];
    if (![deletage.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }else
    {
        //更新最新的消息时间
        [[NSUserDefaults standardUserDefaults]setObject:aMessage.messageDate forKey:kLastMessageDate];
        //发送全局通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:aMessage];
        return YES;
    }
}




//获取某联系人聊天记录
+(NSMutableArray*)fetchMessageListWithUser:(NSString *)userId byPage:(int)pageInde
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    
    NSString *queryString=@"select * from wcMessage where messageFrom=? or messageTo=? order by messageDate";
    
    FMResultSet *rs=[db executeQuery:queryString,userId,userId];
    while ([rs next]) {
        WCMessageObject *message=[[WCMessageObject alloc]init];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[[rs objectForColumnName:kMESSAGE_TYPE]intValue]];
        [ messageList addObject:message];
        
    }
    return  messageList;
    
}


//获取某联系人聊天记录
+(NSMutableArray*)fetchMessageListWithUserAndRoom:(NSString *)userId roomName:(NSString *)roomName byPage:(int)pageIndex
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(messageRoom == %@)",roomName];
    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"messageDate" ascending:NO];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetch setFetchLimit:MESSAGEPAGECOLUMS];
    [fetch setFetchOffset:pageIndex*MESSAGEPAGECOLUMS];
    NSError *error;
    [fetch setEntity:[NSEntityDescription entityForName:@"Messages" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    for (id obj in fetchObjects) {
        WCMessageObject *message = [[WCMessageObject alloc]init];
        [message setMessageId:[obj valueForKey:@"messageId"]];
        [message setMessageType:[[obj valueForKey:@"messageType"]intValue]];
        [message setMessageContent:[obj valueForKey:@"messageContent"]];
        [message setMessageFrom:[obj valueForKey:@"messageFrom"]];
        [message setMessageTo:[obj valueForKey:@"messageTo"]];
        [message setMessageRoom:[obj valueForKey:@"messageRoom"]];
        [message setMessageDate:[obj valueForKey:@"messageDate"]];
        [message setMessageSendXMPPid:[obj valueForKey:@"messageSendXMPPid"]];
        [message setHeadimg:[obj valueForKey:@"headimg"]];
        //状态
        [message setMessageStatus:[[obj valueForKey:@"messageStatus"]intValue]];
        //图片路径
        [message setImageLocalPath:[obj valueForKey:@"imageLocalPath"]];
        [message setImageURLPath:[obj valueForKey:@"imageURLPath"]];
        [messageList addObject:message];
    }
    return messageList;
}

+(WCMessageObject *)getLastMessageByRoom:(NSString *)roomName
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(messageRoom == %@)",roomName];
    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"messageDate" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error;
    [fetch setEntity:[NSEntityDescription entityForName:@"Messages" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    for (id obj in fetchObjects) {
        WCMessageObject *message = [[WCMessageObject alloc]init];
        [message setMessageId:[obj valueForKey:@"messageId"]];
        [message setMessageType:[[obj valueForKey:@"messageType"]intValue]];
        [message setMessageContent:[obj valueForKey:@"messageContent"]];
        [message setMessageFrom:[obj valueForKey:@"messageFrom"]];
        [message setMessageTo:[obj valueForKey:@"messageTo"]];
        [message setMessageRoom:[obj valueForKey:@"messageRoom"]];
        [message setMessageDate:[obj valueForKey:@"messageDate"]];
        [message setMessageSendXMPPid:[obj valueForKey:@"messageSendXMPPid"]];
        [message setHeadimg:[obj valueForKey:@"headimg"]];
        //状态
        [message setMessageStatus:[[obj valueForKey:@"messageStatus"]intValue]];
        //图片路径
        [message setImageLocalPath:[obj valueForKey:@"imageLocalPath"]];
        [message setImageURLPath:[obj valueForKey:@"imageURLPath"]];
        [messageList addObject:message];
    }
    return [messageList lastObject];
}

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
//    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
//    if (![db open]) {
//        NSLog(@"数据打开失败");
//        return messageList;
//    }
//    
//    NSString *queryString=@"select * from wcMessage as m ,wcUser as u where u.userId<>? and ( u.userId=m.messageFrom or u.userId=m.messageTo ) group by u.userId  order by m.messageDate desc limit ?,10";
//    FMResultSet *rs=[db executeQuery:queryString,[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID],[NSNumber numberWithInt:pageIndex-1]];
//    while ([rs next]) {
//        WCMessageObject *message=[[WCMessageObject alloc]init];
//        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
//        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
//        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
//        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
//        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
//        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
//        
//        WCUserObject *user=[[WCUserObject alloc]init];
//        [user setUserId:[rs stringForColumn:kUSER_ID]];
//        [user setUserNickname:[rs stringForColumn:kUSER_NICKNAME]];
//        [user setUserHead:[rs stringForColumn:kUSER_USERHEAD]];
//        [user setUserDescription:[rs stringForColumn:kUSER_DESCRIPTION]];
//        [user setFriendFlag:[rs objectForColumnName:kUSER_FRIEND_FLAG]];
//        
//        WCMessageUserUnionObject *unionObject=[WCMessageUserUnionObject unionWithMessage:message andUser:user ];
//        
//        [ messageList addObject:unionObject];
//        
//    }
    return  messageList;

}

+(BOOL)updateMessageById:(WCMessageObject *)aMessage
{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"(messageId == %@)",aMessage.messageId];
    fetch.predicate = preTemplate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"messageDate" ascending:YES];
    [fetch setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSError *error;
    [fetch setEntity:[NSEntityDescription entityForName:@"Messages" inManagedObjectContext:delegate.managedObjectContext]];
    NSArray *fetchObjects = [delegate.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if([fetchObjects count]==1)
    {
        NSManagedObject *messages = fetchObjects[0];
        [messages setValue:aMessage.messageFrom forKey:@"messageFrom"];
        [messages setValue:aMessage.messageTo forKey:@"messageTo"];
        [messages setValue:aMessage.messageContent forKey:@"messageContent"];
        [messages setValue:aMessage.messageDate forKey:@"messageDate"];
        [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageType] forKey:@"messageType"];
        [messages setValue:aMessage.messageId forKey:@"messageId"];
        [messages setValue:aMessage.messageRoom forKey:@"messageRoom"];
        [messages setValue:aMessage.messageSendXMPPid forKey:@"messageSendXMPPid"];
        [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageStatus] forKey:@"messageStatus"];
        [messages setValue:[[NSNumber alloc]initWithInt:aMessage.messageReadFlag ] forKeyPath:@"messageReadFlag"];
        [messages setValue:aMessage.imageLocalPath forKeyPath:@"imageLocalPath"];
        [messages setValue:aMessage.imageURLPath forKey:@"imageURLPath"];
        [messages setValue:aMessage.headimg forKey:@"headimg"];
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            return NO;
        }else
        {
            return YES;
        }

    }
    return NO;
}

-(void)getRemoteHistoryMsg
{
    //在这里获取离线消息

        ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:getHistoryApi]];
        NSDate *date  = [[NSUserDefaults standardUserDefaults] objectForKey:kLastMessageDate];
        if(!date)
        {
            date = [NSDate dateWithTimeIntervalSince1970:0];
        }

        __weak ASIFormDataRequest *request = _request;
        NSArray *groups = [GroupObject fetchJoinedGroupsWithUser];
        NSString *groupStr = [[NSString alloc]init];
        NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000;
        long long inter = [[NSNumber numberWithDouble:timeInterval] longLongValue];
        for (GroupObject *group in groups) {
            if([groupStr isEqualToString:@""])
            {
                groupStr =  [groupStr stringByAppendingString:[NSString stringWithFormat:@"%@:%llu",group.roomXMPPid,inter]];
            }else
            {
                groupStr = [groupStr stringByAppendingString:[NSString stringWithFormat:@",%@:%llu",group.roomXMPPid,inter]];
            }
        }
        NSString *users = [NSString stringWithFormat:@"%@:%llu",[WCUserObject getLoginUserId], inter];
        [request setPostValue:groupStr forKey:@"rooms"];
        [request setPostValue:users forKey:@"users"];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            SBJsonParser *json = [[SBJsonParser alloc]init];
            NSDictionary *root = [json objectWithString:responseString];
            NSDictionary *historyMsgs = [[[root objectForKey:@"result"] objectForKey:@"data"] objectForKey:@"historyMsg"];
            if ([historyMsgs count]>0) {
                NSArray *keyArr = [historyMsgs allKeys];
                for (NSString *key in keyArr) {
                    NSArray *historyMsgArr = historyMsgs[key];
                    NSLog(@"%@",historyMsgArr);
                    for (NSString *msg in historyMsgArr) {
                        NSLog(@"%@",msg);
                        //生成消息
                        NSArray *infos = [msg componentsSeparatedByString:@"<-.->"];
                        NSString *roomid = infos[0];
                        NSString *sendeName = infos[1];
                        NSString *nickName = infos[2];
                        NSString *sendHeadimg = infos[3];
                        NSString *messageId = infos[4];
                        //用户还是系统消息
                        //NSString *msgType = infos[5];
                        NSString *contentType = infos[6];
                        NSString *dateStr = infos[7];
                        NSString *content = infos[8];
                        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                        [f setNumberStyle:NSNumberFormatterDecimalStyle];
                        NSNumber * myNumber = [f numberFromString:dateStr];
                        NSTimeInterval da = [myNumber doubleValue]/1000;
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:da];
                        
                        WCMessageObject *message = [[WCMessageObject alloc]init];
                        if([contentType isEqualToString:@"text"])
                        {
                            [message setMessageContent:content];
                            [message setMessageDate:date];
                            [message setMessageFrom:nickName];
                            [message setMessageId:messageId];
                            [message setMessageReadFlag:kWCMessageReadStatusUnRead];
                            [message setMessageRoom:roomid];
                            [message setMessageStatus:kWCMessageDone];
                            [message setMessageType:kWCMessageTypePlain];
                            [message setHeadimg:sendHeadimg];
                            [WCMessageObject save:message];
                        }else if ([contentType isEqualToString:@"group"])
                        {
                            //踢人
//                            SystemNotificationObject *notification = [[SystemNotificationObject alloc]init];
//                            notification.notificationType = kWCSystmNotificationKick;
                            [message setMessageContent:content];
                            [message setMessageDate:date];
                            [message setMessageFrom:nickName];
                            [message setMessageId:messageId];
                            [message setMessageReadFlag:kWCMessageReadStatusUnRead];
                            [message setMessageRoom:roomid];
                            [message setMessageStatus:kWCMessageDone];
                            [message setMessageType:kWCMessageTypeNotification];
                            [message setHeadimg:sendHeadimg];
                            [WCMessageObject save:message];
                            
                        }else if([contentType isEqualToString:@"img"])
                        {
                            NSArray *images = [content componentsSeparatedByString:@"<:>"];
                            NSString *localImage = images[0];
                            NSString *bigImage = images[1];
                            [message setImageLocalPath:localImage];
                            [message setImageURLPath:bigImage];
                            [message setMessageDate:date];
                            [message setMessageFrom:nickName];
                            [message setMessageId:messageId];
                            [message setMessageReadFlag:kWCMessageReadStatusUnRead];
                            [message setMessageRoom:roomid];
                            [message setMessageStatus:kWCMessageDone];
                            [message setMessageType:kWCMessageTypeImage];
                            [WCMessageObject save:message];
                        }
                    }
                }
            }
            NSDictionary *systemMsgs = [[[root objectForKey:@"result"] objectForKey:@"data"] objectForKey:@"systemMsg"];
            NSArray *systemMsgKeyArr = [systemMsgs allKeys];
            for (NSString *systenMsgKey in systemMsgKeyArr) {
                NSArray *msgs = systemMsgs[systenMsgKey];
                if([msgs count]>0)
                {
                    SystemNotificationObject *notification = [[SystemNotificationObject alloc]init];
                    for (NSString *systemMsg in msgs) {
                        NSArray *infos = [systemMsg componentsSeparatedByString:@"<-.->"];
                        notification.notificationFrom = infos[0];
                        notification.notificationHead = infos[1];
                        notification.notificationId= infos[2];
                        NSString *contentType = infos[4];
                        NSString *dateStr = infos[5];
                        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                        [f setNumberStyle:NSNumberFormatterDecimalStyle];
                        NSNumber * myNumber = [f numberFromString:dateStr];
                        NSTimeInterval da = [myNumber doubleValue]/1000;
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:da];
                        notification.notificationDate = date;
                        notification.content = infos[6];
                        notification.notificationStatus = kWCMessageReadStatusUnRead;
                        if ([contentType isEqualToString:@"ban"]) {
                            //禁言
                            notification.notificationType = kWCSystmNotificationBan;
                        }else if([contentType isEqualToString:@"unban"])
                        {
                            //解禁
                            notification.notificationType = kWCSystmNotificationUnBan;
                        }else if ([contentType isEqualToString:@"pass"])
                        {
                            //通过
                            notification.notificationType = kWCSystmNotificationPass;
                        }else if ([contentType isEqualToString:@"system"])
                        {
                            notification.notificationType = kWCSystmNotificationPlain;
                        }
                    }
                    [SystemNotificationObject save:notification];
                }
                
            }

        }];
        [request setFailedBlock:^{
            NSLog(@"%@",[[request error] localizedDescription]);
        }];
        //[request startAsynchronous];
        [[RequestManager sharedInstance] addRequest:request];
    }
+(NSString *)convertXESemojiSymbol:(NSString *)string
{
    if(string)
    {
        NSString *yourString = string;
        NSError *error = NULL;
        __block NSString *message =  string;
        NSLog(@"%@",yourString);
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[e\\](.*?)\\[/e\\]" options:NSRegularExpressionCaseInsensitive error:&error];
        
        
        [regex enumerateMatchesInString:yourString options:0 range:NSMakeRange(0, [yourString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            
            // detect
            NSString *insideString = [yourString substringWithRange:[match rangeAtIndex:1]];
            
            unsigned int outVal;
            NSScanner* scanner = [NSScanner scannerWithString:insideString];
            [scanner scanHexInt:&outVal];
            
            NSString *smiley = [[NSString alloc] initWithBytes:&outVal length:sizeof(outVal) encoding:NSUTF32LittleEndianStringEncoding];
            //print
            NSString *matchStirng = [NSString stringWithFormat:@"[e]%@[/e]",insideString];
            message = [message stringByReplacingOccurrencesOfString:matchStirng withString:smiley];
        }];
        return message;
    }
    return nil;
}

@end
