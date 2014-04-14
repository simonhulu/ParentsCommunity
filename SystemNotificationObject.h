//
//  SystemNotificationObject.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <Foundation/Foundation.h>
enum kWCSystmNotificationType {
    kWCSystmNotificationPlain = 0,
    kWCSystmNotificationBan = 1,
    kWCSystmNotificationUnBan =2,
    kWCSystmNotificationPass=3,
    kWCSystmNotificationKick=4
};
enum kWCSystmNotificationTypeStatus
{
    kWCSystmNotificationUnRead =0 ,
    kWCSystmNotificationRead =1
};

@interface SystemNotificationObject : NSObject
// 如果踢人的话 会有该属性 代表谁被踢了
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)NSInteger notificationType;
@property(nonatomic,strong)NSString *roomId;
@property(nonatomic,strong)NSDate *notificationDate;
@property(nonatomic,assign)NSInteger notificationStatus;
//这条消息属于谁 一般是自己
@property(nonatomic,strong)NSString *notificationFrom;
@property(nonatomic,strong)NSString *notificationHead;
@property(nonatomic,strong)NSString *notificationId;
+(BOOL)save:(SystemNotificationObject*)aMessage;
+(NSMutableArray*)fetchNotificationByOwnId:(NSString *)ownId;
+(NSMutableArray*)fetchUnReadNotificationByOwnId:(NSString *)ownId;
+(SystemNotificationObject*)getLastSystemNotification:(NSString *)ownId;
+(BOOL)changeNotificationReadStatus:(NSInteger)status;
@end
