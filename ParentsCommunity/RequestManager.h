//
//  RequestManager.h
//  ParentsCommunity
//
//  Created by qizhang on 14-3-31.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
@interface RequestManager : NSObject
{
    ASINetworkQueue *networkQueue;
}
+(RequestManager *)sharedInstance;
+(id)allocWithZone:(struct _NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (void)doNetworkOperations;
-(void)addRequest:(ASIHTTPRequest *)request;
@property (retain) ASINetworkQueue *networkQueue;
@end
