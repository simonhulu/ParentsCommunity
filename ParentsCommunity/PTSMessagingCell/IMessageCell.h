//
//  IMessageCell.h
//  JabberClient
//
//  Created by 张 诗杰 on 14-2-17.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMessageCell : UITableViewCell
{
    __strong UIImageView *_avatarImageView;
    __strong UILabel *_timeLabel;
    __strong UILabel *_messageLabel;
    __strong UIView *_messageView;
    __strong UIImageView *_balloonView;
}

@property(nonatomic,strong)UIView *messageView;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)UIImageView *balloonView;
@property(assign)BOOL sent;

/**
 文件的横向间距
 */
+(CGFloat)textMarginHorizontal;
/**
 文件的纵向间距
 */
+(CGFloat)textMarginVertical;
/**
 文本的最大宽度
 */
+(CGFloat)maxTextWidth;
/**
 计算消息的大小
 */
+(CGSize)messageSize:(NSString*)message;
/**
 泡泡是否选中
 */
+(UIImage*)ballonImage:(BOOL)sent isSelected:(BOOL)selected;
/**
 Initializes the PTSMessagingCell
 */
-(id)initMessagCellingWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
