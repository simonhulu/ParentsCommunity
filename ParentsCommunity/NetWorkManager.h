//
//  NetWorkManager.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-29.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface NetWorkManager : NSObject
{
    Reachability *hostReachability;
    Reachability *internetReachability;
    Reachability *wifiReachability;
}
+(NetWorkManager *)sharedInstance;
+(id)allocWithZone:(struct _NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
-(void)startMoniter;
@property(nonatomic,assign)BOOL connectionReachable;
@end
