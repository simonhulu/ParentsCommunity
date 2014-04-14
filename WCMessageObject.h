//
//  WCMessageObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentsCommunity-Prefix.pch"
#import "ASIFormDataRequest.h"
#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"
#define kMESSAGE_ID @"messageId"
#define MESSAGEPAGECOLUMS 10
enum kWCMessageType {
    kWCMessageTypePlain = 0,
    kWCMessageTypeImage = 1,
    kWCMessageTypeVoice =2,
    kWCMessageTypeLocation=3,
    kWCMessageTypeDateTip = 4,
    kWCMessageTypeNotification =5
};

enum kWCMessageCellStyle {
    kWCMessageCellStyleMe = 0,
    kWCMessageCellStyleOther = 1,
    kWCMessageCellStyleMeWithImage=2,
    kWCMessageCellStyleOtherWithImage=3,
    kWCMessageCellStyleTip = 4 
};


enum kWCMessageStatus
{
    kWCMessageSending =0 ,
    kWCMessageDone =1,
    kWCMessageFailed =2
};

enum kWCMessageReadStatus
{
    kWCMessageReadStatusUnRead =0,
    kWCMessageReadStatusRead = 1
};


@interface WCMessageObject : NSObject
{
    ASIFormDataRequest *historyRequest;
}
//记录的是nickname
@property (nonatomic,retain) NSString *messageFrom;
@property (nonatomic,retain) NSString *messageTo;
@property (nonatomic,retain) NSString *messageContent;
@property (nonatomic,retain) NSDate *messageDate;
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,retain) NSString *messageId;
@property (nonatomic,strong) NSString *messageRoom;
@property (nonatomic,strong) NSString *headimg;
//记录的是发送者的xmppid
@property(nonatomic,strong)  NSString *messageSendXMPPid;
@property (nonatomic,strong) NSString *imageLocalPath;
@property(nonatomic,strong)  NSString *imageURLPath;
//发送状态
@property(nonatomic,assign)  NSInteger messageStatus;
//是否读过
@property(nonatomic,assign) NSInteger messageReadFlag;

+(WCMessageObject *)sharedInstance;
+(WCMessageObject *)messageWithType:(int)aType;




//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WCMessageObject*)messageFromDictionary:(NSDictionary*)aDic;

//数据库增删改查
+(BOOL)save:(WCMessageObject*)aMessage;
+(BOOL)deleteMessageById:(NSNumber*)aMessageId;
+(BOOL)merge:(WCMessageObject*)aMessage;

//获取某联系人聊天记录
+(NSMutableArray *)fetchMessageListWithUser:(NSString *)userId byPage:(int)pageIndex;

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex;

+(NSMutableArray*)fetchMessageListWithUserAndRoom:(NSString *)userId roomName:(NSString *)roomName byPage:(int)pageIndex;
+(BOOL)updateMessageById:(WCMessageObject *)aMessage;
-(void)getRemoteHistoryMsg;
+(WCMessageObject *)getLastMessageByRoom:(NSString *)roomName;
+(NSString *)convertXESemojiSymbol:(NSString *)string;
@end
