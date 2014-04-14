//
//  IUtil.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-3-6.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "IUtil.h"

@implementation IUtil
{
    
}
+(NSString *)replaceAT:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"@" withString:@"\\40"];
}

+(NSString *) revertAT:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"];
}
@end
