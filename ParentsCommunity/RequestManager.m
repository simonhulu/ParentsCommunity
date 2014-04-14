//
//  RequestManager.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-31.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager
@synthesize networkQueue;
__strong static RequestManager *manager = nil ;
+(RequestManager *)sharedInstance
{
    static dispatch_once_t pred = 0 ;
    dispatch_once(&pred, ^{
        manager = [[super allocWithZone:NULL]init];
        [manager doNetworkOperations];
    });
    return manager;
}

- (void)doNetworkOperations
{
	// Stop anything already in the queue before removing it
	[[self networkQueue] cancelAllOperations];
	
	// Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
	[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
}


-(void)addRequest:(ASIHTTPRequest *)request
{
    if (![self networkQueue]) {
        [self doNetworkOperations];
    }
    [[self networkQueue] addOperation:request];
    [[self networkQueue] go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
        
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil];
	}
	
	//... Handle success
	NSLog(@"Request finished");
}

- (void)requestFailed:(ASIHTTPRequest *)request 
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	
	//... Handle failure
	NSLog(@"Request failed");
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
	NSLog(@"Queue finished");
}



+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
