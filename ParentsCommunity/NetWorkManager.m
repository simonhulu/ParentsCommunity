//
//  NetWorkManager.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-29.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "NetWorkManager.h"
#import "ParentsCommunity-Prefix.pch"
@implementation NetWorkManager

__strong static NetWorkManager *manager = nil ;

+(NetWorkManager *)sharedInstance
{
    static dispatch_once_t pred = 0 ;
    dispatch_once(&pred, ^{
        manager = [[super allocWithZone:NULL]init];
    });
    return manager;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



-(void)startMoniter
{
    self.connectionReachable = YES;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:NetworkReachabilityChangedNotification object:nil];
    hostReachability = [Reachability reachabilityWithHostName:apihost];
    [hostReachability startNotifier];
    internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    wifiReachability = [Reachability reachabilityForLocalWiFi];

    [wifiReachability startNotifier];

}

-(void)reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    if([curReach.key isEqualToString:@"InternetConnection"])
    {
        if(curReach.currentReachabilityStatus == kNotReachable)
        {
            NSLog(@"%@",@"不好意思断网了");
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionNoReach object:nil];
            self.connectionReachable = NO ;
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionReach object:nil];
            self.connectionReachable = YES ;
        }
    }else{
    }
}
@end
