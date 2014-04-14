//
//  ImageUtilities.m
//  ParentsCommunity
//
//  Created by qizhang on 14-4-2.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ImageUtilities.h"

@implementation ImageUtilities
+ (CGSize )imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return newSize;
}

@end
