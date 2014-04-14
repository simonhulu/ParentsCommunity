//
//  WCMessageCell.m
//  微信
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCMessageCell.h"
#import "AppDelegate.h"
#import "ImageUtilities.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width


@implementation WCMessageCell
@synthesize delegate,status;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _bubbleBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _headMask =[[UIImageView alloc]initWithFrame:CGRectZero];
        _chatImage =[[UIImageView alloc]initWithFrame:CGRectZero];
        indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:messageContentFontSize]];
        _messageConent.lineBreakMode = NSLineBreakByCharWrapping;
        _messageConent.numberOfLines = 0 ;
        [_messageConent setNumberOfLines:20];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        [self.contentView addSubview:nameLabel];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.851f green:0.851f blue:0.851f alpha:1];
        //bgColorView.layer.cornerRadius = 7;
        bgColorView.layer.masksToBounds = YES;
        [self setSelectedBackgroundView:bgColorView];
        //[_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        
        UITapGestureRecognizer *userHeadTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userHeadTap:)];
        userHeadTapGesture.numberOfTapsRequired =1 ;
        _userHead.userInteractionEnabled = YES;
        [_userHead addGestureRecognizer:userHeadTapGesture];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillHid:) name:UIMenuControllerWillHideMenuNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillShow:) name:UIMenuControllerDidShowMenuNotification object:nil];
//        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(bubbleBglongPress:)];
//        press.minimumPressDuration = 0.5;
//        [_bubbleBg addGestureRecognizer:press];
        

    }
    return self;
}





//-(void)bubbleBglongPress:(UILongPressGestureRecognizer *)longPressGestureRecoginer
//{
//    switch (longPressGestureRecoginer.state) {
//        case 1: // object pressed
//        case 2:
//
//            break;
//        case 3: // object released
//            [_bubbleBg.layer setOpacity:1.0];
//            break;
//        default: // unknown tap
//            NSLog(@"%i", longPressGestureRecoginer.state);
//            break;
//    }
//}



-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    
    NSString *orgin=_messageConent.text;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:messageContentFontSize] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];

    switch (_msgStyle) {
        case kWCMessageCellStyleMe:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [nameLabel setHidden:YES];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, INSETS+10, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
//            [nameLabel sizeToFit];
//            [nameLabel setFrame:CGRectMake(_messageConent.frame.size.width+_messageConent.frame.origin.x-nameLabel.frame.size.width+8, INSETS, nameLabel.frame.size.width, nameLabel.frame.size.height)];
//            
//            [nameLabel setTextAlignment:NSTextAlignmentRight];
             [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-10, _messageConent.frame.origin.y-10, textSize.width+25, textSize.height+20);
            [self removeIndicator];
            [self removeNetWorkError];
            [self attachTapHandler];
        }
            break;
        case kWCMessageCellStyleOther:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [nameLabel setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];

            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, 41, textSize.width, textSize.height)];

            [nameLabel setFrame:CGRectMake(_messageConent.frame.origin.x-8, INSETS, 100, 14)];
            [nameLabel setTextAlignment:NSTextAlignmentLeft];
            [nameLabel sizeToFit];
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:15 topCapHeight:25]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-10, textSize.width+25, textSize.height+20);
            [self removeIndicator];
            [self removeNetWorkError];
            [self attachTapHandler];
        }
            break;
        case kWCMessageCellStyleMeWithImage:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [nameLabel setHidden:YES];
            CGSize newsize = [ImageUtilities imageWithImage:_chatImage.image scaledToMaxWidth:MAXIMAGE maxHeight:MAXIMAGE];
            CGRect oldchatimageframe = _chatImage.frame;
            oldchatimageframe.size.width = newsize.width;
            oldchatimageframe.size.height = newsize.height;
            _chatImage.frame = oldchatimageframe;
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-_chatImage.frame.size.width-7, INSETS+10, _chatImage.frame.size.width, _chatImage.frame.size.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
//            [nameLabel setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-15-nameLabel.frame.size.width, INSETS, nameLabel.frame.size.width, nameLabel.frame.size.height)];
//
//            [nameLabel setTextAlignment:NSTextAlignmentRight];
//            [nameLabel sizeToFit];
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-5, _chatImage.frame.origin.y-10, _chatImage.frame.size.width+15, _chatImage.frame.size.height+10);
            if (status == kWCMessageSending) {
                [self removeNetWorkError];
                [self addIndicator];
                [aaa setFrame:CGRectMake(_bubbleBg.frame.origin.x-INSETS-20, _bubbleBg.frame.origin.y, 20, 20)];
            }else if(status == kWCMessageFailed)
            {
                [self removeIndicator];

                [self addNetWorkError];
                [sendErrorView setFrame:CGRectMake(_bubbleBg.frame.origin.x-INSETS-20, _bubbleBg.frame.origin.y, 20, 20)];
            }else if(status == kWCMessageDone)
            {
                [self removeNetWorkError];
                [self removeIndicator];
            }
            
        }
            break;
            case kWCMessageCellStyleOtherWithImage:
        {
            [self imageWithOtherlayout];
        }
            break;
        default:
            break;
    }
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}


-(void)imageWithOtherlayout
{
    [_chatImage setHidden:NO];
    [_messageConent setHidden:YES];
    [nameLabel setHidden:NO];
    CGSize newsize ;
    if(_chatImage.image)
    {
     newsize = [ImageUtilities imageWithImage:_chatImage.image scaledToMaxWidth:MAXIMAGE maxHeight:MAXIMAGE];

    }else{
        newsize = CGSizeMake(MAXIMAGE, MAXIMAGE);
    }
    CGRect oldchatimageframe = _chatImage.frame;
    oldchatimageframe.size.width = newsize.width;
    oldchatimageframe.size.height = newsize.height;
    _chatImage.frame = oldchatimageframe;
    [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+7, 43,_chatImage.frame.size.width,_chatImage.frame.size.height)];
    [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
    [nameLabel setFrame:CGRectMake(_bubbleBg.frame.origin.x+5, INSETS, 100, 14)];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel sizeToFit];
    [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
    
    _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-10, _chatImage.frame.origin.y-5, _chatImage.frame.size.width+15, _chatImage.frame.size.height+10);

    [self removeIndicator];
    [self removeNetWorkError];
}

#pragma mark ---UIMenuController---

-(void)menuWillHid:(NSNotification *)notification
{
    //去掉高亮
    if(_msgStyle == kWCMessageCellStyleOther || _msgStyle == kWCMessageCellStyleOtherWithImage)
    {
        [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
    }
    if(_msgStyle == kWCMessageCellStyleMe || _msgStyle == kWCMessageCellStyleMeWithImage)
    {
        [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
    }
}

-(void)menuWillShow:(NSNotification *)notification
{

}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//返回你关心的功能 这里是粘贴
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(_msgStyle == kWCMessageCellStyleMe || _msgStyle == kWCMessageCellStyleOther)
    {
            return (action==@selector(icopy:));
    }else{
        return (action == @selector(reSend:));
    }

}


//针对copy的实现
-(void)icopy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:_messageConent.text];

}

//UILabel默认是不接受事件的 我们需要自己添加touch事件
-(void)attachTapHandler
{
    _messageConent.userInteractionEnabled = YES;
    //双击
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 2;
    [_messageConent addGestureRecognizer:touch];


    //长按压
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.5;
    [_messageConent addGestureRecognizer:press];
}

-(void)attachErrorTapHandler
{
    if(sendErrorView)
    {
        sendErrorView.userInteractionEnabled = YES;
        //双击
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorTap:)];
        touch.numberOfTapsRequired = 2;
        [sendErrorView addGestureRecognizer:touch];
        
        //长按压
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(errorLongPress:)];
        press.minimumPressDuration = 0.5;
        [sendErrorView addGestureRecognizer:press];
    }
}

-(void)errorTap:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *resendMenuItem = [[UIMenuItem alloc]initWithTitle:@"重新发送" action:@selector(reSend:)];
    [menu setTargetRect:sendErrorView.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    [menu setMenuItems:[NSArray arrayWithObjects:resendMenuItem, nil]];
}

-(void)errorLongPress:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *resendMenuItem = [[UIMenuItem alloc]initWithTitle:@"重新发送" action:@selector(reSend:)];
    [menu setTargetRect:sendErrorView.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    [menu setMenuItems:[NSArray arrayWithObjects:resendMenuItem, nil]];
}

-(void)reSend:(id)sender
{
    if([delegate respondsToSelector:@selector(reSendMessage:)])
    {
        [delegate reSendMessage:self.tag];
    }
}


-(void)handleTap:(UIGestureRecognizer*) recognizer{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(icopy:)];
    [menu setTargetRect:_messageConent.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    [menu setMenuItems:[NSArray arrayWithObject:copyItem]];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(icopy:)];
        [menu setTargetRect:_messageConent.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
        [menu setMenuItems:[NSArray arrayWithObject:copyItem]];
        if(_msgStyle == kWCMessageCellStyleOther || _msgStyle == kWCMessageCellStyleOtherWithImage)
        {
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkgHL"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
        }
        if(_msgStyle == kWCMessageCellStyleMe || _msgStyle == kWCMessageCellStyleMeWithImage)
        {
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkgHL"]stretchableImageWithLeftCapWidth:10 topCapHeight:30]];
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMessageObject:(WCMessageObject*)aMessage
{
    if(aMessage.messageType == kWCMessageTypePlain)
    {
//        NSString *yourString = aMessage.messageContent;
//        NSError *error = NULL;
//        __block NSString *message =  aMessage.messageContent;
//        NSLog(@"%@",yourString);
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[e\\](.*?)\\[/e\\]" options:NSRegularExpressionCaseInsensitive error:&error];
//        
//        
//        [regex enumerateMatchesInString:yourString options:0 range:NSMakeRange(0, [yourString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//            
//            // detect
//            NSString *insideString = [yourString substringWithRange:[match rangeAtIndex:1]];
//            
//            unsigned int outVal;
//            NSScanner* scanner = [NSScanner scannerWithString:insideString];
//            [scanner scanHexInt:&outVal];
//            
//            NSString *smiley = [[NSString alloc] initWithBytes:&outVal length:sizeof(outVal) encoding:NSUTF32LittleEndianStringEncoding];
//            //print
//            NSString *matchStirng = [NSString stringWithFormat:@"[e]%@[/e]",insideString];
//            message = [message stringByReplacingOccurrencesOfString:matchStirng withString:smiley];
//        }];
        NSString *message = [WCMessageObject convertXESemojiSymbol:aMessage.messageContent];
        [_messageConent setText:message];
        [indicatorView startAnimating];
    }
}

-(void)setHeadImageWithURL:(NSURL *)url
{
    [_userHead setImageWithURL:url];
}
-(void)setChatImageWithURL:(NSURL *)url bigImg:(NSURL *)bigurl
{
    __weak WCMessageCell *ss =self;
    [_chatImage setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [ss imageWithOtherlayout];
    }];
    if(!tap)
    {
        _chatImage.userInteractionEnabled = YES ;
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [_chatImage addGestureRecognizer:tap];
        //_photos = [[NSMutableArray alloc]init];
    }
    if(bigurl)
    {
        photo =[MWPhoto photoWithURL:bigurl];
    }else{
        photo =[MWPhoto photoWithURL:url];
    }

    //[_photos addObject:photo];
    
}
-(void)setHeadImage:(UIImage*)headImage
{
    [_userHead setImage:headImage];
}
-(void)setChatImage:(UIImage *)chatImage
{
    
    [_chatImage setImage:chatImage];
    if(!tap)
    {
        _chatImage.userInteractionEnabled = YES ;
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [_chatImage addGestureRecognizer:tap];
        //_photos = [[NSMutableArray alloc]init];
    }
    photo =[MWPhoto photoWithImage:chatImage];
}

-(void)addNetWorkError
{
    if(!sendErrorView)
    {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"errorIcon"]];
        sendErrorView = [[UILabel alloc]initWithFrame:CGRectZero];
        [sendErrorView addSubview:image];
        [self addSubview:sendErrorView];
        [self attachErrorTapHandler];
    }
}

-(void)removeNetWorkError
{
    if(sendErrorView)
    {
        [sendErrorView removeFromSuperview];
        sendErrorView = nil;
    }
}

-(void)addIndicator
{
    if(!aaa)
    {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        [indicatorView sizeToFit];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.hidden = NO;
        
        aaa = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        indicatorView.center = aaa.center;
        [aaa addSubview:indicatorView];
        [self addSubview:aaa];
        [indicatorView startAnimating];
    }

}

-(void)removeIndicator
{
    [aaa removeFromSuperview];
    aaa = nil ;
}

-(void)setName:(NSString *)name
{

    nameLabel.text = name;
    [nameLabel sizeToFit];
}


#pragma ---WCMessageCellChatImageTapDelegate---
-(void)tapImage:(UIGestureRecognizer *)gesture
{
    if([delegate respondsToSelector:@selector(WCMessageCellChatImageTap:)])
    {
        [delegate WCMessageCellChatImageTap:photo];
    }
}

-(void)userHeadTap:(UITapGestureRecognizer *)gesture
{
    if([delegate respondsToSelector:@selector(userHeadTap:)])
    {
        [delegate userHeadTap:_msgStyle];
    }
}

-(void)reSendMessage:(NSInteger)messageIndex
{
    if([delegate respondsToSelector:@selector(reSendMessage:)])
    {
        [delegate reSendMessage:self.tag];
    }
}

@end
