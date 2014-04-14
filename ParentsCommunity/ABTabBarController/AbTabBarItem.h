//
//  AbTabBarItem.h
//
//  Created by Alexander Blunck on 15.02.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbTabBarItem : NSObject {
    
}

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) UIViewController *viewController;

-(id) initWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage viewController:(UIViewController*)viewcontroller;

@end
