//
//  WCMessageCell.h
//  微信
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"

//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 1000.0f
//间距
#define INSETS 8.0f
#define MAXIMAGE 88.0f
#define messageContentFontSize 18
@protocol WCMessageCellChatImageTapDelegate <NSObject>

@optional
-(void)WCMessageCellChatImageTap:(MWPhoto *)photo;
-(void)userHeadTap:(enum kWCMessageCellStyle)msgStyle;
-(void)reSendMessage:(NSInteger)messageIndex;
@end

@interface WCMessageCell : UITableViewCell<MWPhotoBrowserDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
    UILabel *nameLabel;
    MWPhoto *photo;

    UITapGestureRecognizer *tap;
    UIActivityIndicatorView *indicatorView;
    UIView *aaa;
    UILabel *sendErrorView;

    
}
@property(nonatomic,assign) id<WCMessageCellChatImageTapDelegate> delegate;
@property (nonatomic,assign) enum kWCMessageCellStyle msgStyle;
@property(nonatomic,assign)  NSInteger status;
@property (nonatomic) int height;
-(void)setMessageObject:(WCMessageObject*)aMessage;
-(void)setHeadImage:(UIImage*)headImage;
-(void)setChatImage:(UIImage *)chatImage;
-(void)setHeadImageWithURL:(NSURL *)url;
-(void)setChatImageWithURL:(NSURL *)url bigImg:(NSURL *)bigurl;
-(void)setName:(NSString *)name;

@end
