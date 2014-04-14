//
//  WCUserObject.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kUSER_ID @"userId"
#define kUSER_NICKNAME @"userNickname"
#define kUSER_DESCRIPTION @"userDescription"
#define kUSER_USERHEAD @"userHead"
#define kUSER_FRIEND_FLAG @"friendFlag"


@interface WCUserObject : NSObject
//账号名字
@property (nonatomic,retain) NSString* userId;
@property (nonatomic,strong)  NSString *password;
@property(nonatomic,strong)  NSString *userHead;
//城市名
@property(nonatomic,strong)  NSString *cityName;
//年级
@property(nonatomic,strong)  NSString *gradeName;
//孩子昵称
@property (nonatomic,retain) NSString* userNickname;
@property (nonatomic,strong) NSString *subName;
@property (nonatomic,retain) NSNumber* friendFlag;
@property (nonatomic,assign) NSInteger grade_tips;
//数据库增删改查
+(BOOL)saveNewUser:(WCUserObject*)aUser;
+(BOOL)deleteUserById:(NSNumber*)userId;
+(BOOL)updateUser:(WCUserObject*)newUser;
+(BOOL)haveSaveUserById:(NSString*)userId;
+(WCUserObject *)getUserById:(NSString *)userId;
+(NSMutableArray*)fetchAllFriendsFromLocal;
+(WCUserObject *)getLoginAccount;
//将对象转换为字典
-(NSDictionary*)toDictionary;
+(WCUserObject*)userFromDictionary:(NSDictionary*)aDic;
+(NSString *)getLoginUserId;
+(NSString *)getLoginUserPasswd;
+(BOOL)updateLoginUserNickName:(NSString *)nickName;
+(BOOL)updateLoginUserId:(NSString *)userId;
+(BOOL)updateLoginUserPasswd:(NSString *)passwd;
+(NSString *)getLoginUserNickName;
+(BOOL)updateLoginUserHead:(NSString *)head;
+(NSString *)getLoginUserHead;
+(NSString *)getRoleStr:(NSInteger)roleindex;

-(void)loginAction:(NSString *)account passwd:(NSString *)passwd;

@end
