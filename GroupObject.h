//
//  GroupObject.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-26.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <Foundation/Foundation.h>
//
 enum GroupType
{
    NetworkProblemTipGroup = 0,
    TopGroup  = 1,
    GapGroup = 2,
    NormalGroup = 3
};
enum GroupCellStyle
{
    GroupCellNetworkProblemTipStyle = 0 ,
    GroupCellTopStyle = 1,
    GroupCellGapTipStyle = 2,
    GroupCellNormalStyle = 3
};
@interface GroupObject : NSObject

@property(nonatomic,strong)NSString *roomXMPPid;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *roomIconUrl;
@property(nonatomic,strong)NSString *roomIntroduction;
@property(nonatomic,assign)NSInteger roomMember;
//0为不在 1为在 群
@property(nonatomic,assign)NSInteger isAlreadyIn;
@property(nonatomic,assign)NSInteger isNeedVerify;
//是以加入群主群还是附属群
@property(nonatomic,assign)NSInteger grouptype;
@property(nonatomic,strong)NSString *roomAdmin;
@property(nonatomic,assign)NSInteger speakstate;
//数据库的增删改查
+(BOOL)save:(NSArray*)groups refreshdate:(NSInteger)refreshdate;
//获取群列表
+(NSArray *)fetchGroupsWithUser;
+(NSArray *)fetchJoinedGroupsWithUser;
+(BOOL)save:(GroupObject *)group;
+(void)deleteAllGroup;
+(void)deleteGroupById:(NSString *)roomXMPPid;
+(void)banSpeak:(NSString *)roomId;
+(void)reCoverSpeak:(NSString *)roomId;
+(GroupObject *)getGroupByid:(NSString *)roomXMPPid;
+(BOOL )updateGroup:(GroupObject *)newGroup;
@end
