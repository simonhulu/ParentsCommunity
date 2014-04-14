//
//  IMessageCell.m
//  JabberClient
//
//  Created by 张 诗杰 on 14-2-17.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "IMessageCell.h"

@implementation IMessageCell
static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 14.0f;
@synthesize messageView = _messageView;
@synthesize balloonView = _balloonView;
@synthesize timeLabel = _timeLabel;
@synthesize messageLabel = _messageLabel;
@synthesize avatarImageView = _avatarImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark-
#pragma mark Static methods
+(CGFloat)textMarginHorizontal
{
    return textMarginHorizontal;
}
+(CGFloat)textMarginVertical
{
    return textMarginVertical;
}

+(CGFloat)maxTextWidth
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return 220.0f;
    }else{
        return 400.0f;
    }
}

+(CGSize)messageSize:(NSString *)message
{
    return [message sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake([IMessageCell maxTextWidth],CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

+(UIImage *)balloonImage:(BOOL)sent isSelected:(BOOL)selected
{
    //是发送者并且被选中
    if(sent == YES && selected == YES)
    {
        return [[UIImage imageNamed:@"balloon_selected_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }else if (sent == YES && selected == NO)
    {
        return [[UIImage imageNamed:@"balloon_read_left"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
    }else if(sent == NO && selected == YES)
    {
        return [[UIImage imageNamed:@"balloon_selected_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }else
    {
           return [[UIImage imageNamed:@"balloon_read_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
}

-(id)initMessagCellingWithReuseIdentifier:(NSString*)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*Now the basic view-lements are initialized*/
        _messageView = [[UIView alloc] initWithFrame:CGRectZero];
        _messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _balloonView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _avatarImageView = [[UIImageView alloc]initWithImage:nil];
        
        /*Message-Label*/
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:messageTextSize];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0 ;
        
        /*Time-Label*/
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        
        /*...and adds them to the view*/
        [_messageView addSubview:_balloonView];
        [_messageView addSubview:_messageLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_messageView];
        [self.contentView addSubview:_avatarImageView];
        
        /*...and a gesture-recognizer,for LongPressure is added to the view.*/
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:1.0f];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

#pragma mark -
#pragma mark Layouting
-(void)layoutSubviews
{
    /*This method layouts the TableViewCell,It calculates the frame foe the different subvies*/
    /*计算消息大小*/
    CGSize textSize = [IMessageCell messageSize:self.messageLabel.text];
    /*计算时间文字大小*/
    CGSize dateSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font forWidth:[IMessageCell maxTextWidth] lineBreakMode:NSLineBreakByClipping];
    
    /*初始化frame*/
    CGRect ballonViewFrame = CGRectZero;
    CGRect messageLabelFrame = CGRectZero;
    CGRect timeLabelFrame = CGRectZero;
    CGRect avatarImageFrame = CGRectZero;
    //如果是发送者
    if(self.sent == YES)
    {
        avatarImageFrame = CGRectMake(5.0f, 0, 50.0f, 50.0f);
        timeLabelFrame = CGRectMake(self.frame.size.width -textMarginHorizontal - dateSize.width, 0.0f, dateSize.width, dateSize.height);
        ballonViewFrame = CGRectMake(55.0f, timeLabelFrame.size.height, textSize.width+2*textMarginHorizontal, textSize.height + 2*textMarginVertical);
        messageLabelFrame = CGRectMake(55.0f+textMarginHorizontal,  ballonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        avatarImageFrame = CGRectMake(5.0f, timeLabelFrame.size.height, 50.0f, 50.0f);
    }else {
        avatarImageFrame = CGRectMake(self.frame.size.width - 55.0f, timeLabelFrame.size.height, 50.0f, 50.0f);
        timeLabelFrame = CGRectMake(textMarginHorizontal, 0.0f, dateSize.width, dateSize.height);
        
        ballonViewFrame = CGRectMake(0.0f, timeLabelFrame.size.height, textSize.width + 2*textMarginHorizontal, textSize.height + 2*textMarginVertical);
        
        messageLabelFrame = CGRectMake(textMarginHorizontal, ballonViewFrame.origin.y + textMarginVertical, textSize.width, textSize.height);
        
        

    }
    _balloonView.image = [IMessageCell balloonImage:self.sent isSelected:self.selected];
    
    /*Sets the pre-initialized frames  for the balloonView and messageView.*/
    self.balloonView.frame = ballonViewFrame;
    self.messageLabel.frame = messageLabelFrame;
    
    /*If shown (and loaded), sets the frame for the avatarImageView*/
    if (self.avatarImageView.image != nil) {
        self.avatarImageView.frame = avatarImageFrame;
    }
    
    /*If there is next for the timeLabel, sets the frame of the timeLabel.*/
    
    if (self.timeLabel.text != nil) {
        self.timeLabel.frame = timeLabelFrame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	/*Selecting a UIMessagingCell will cause its subviews to be re-layouted. This process will not be animated! So handing animated = YES to this method will do nothing.*/
    [super setSelected:selected animated:NO];
    
    [self setNeedsLayout];
    
    /*Furthermore, the cell becomes first responder when selected.*/
    if (selected == YES) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
}

#pragma mark -
#pragma mark UIgesturerecognizer-Handling
-(void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    /*长按 复制菜单显示*/
    if(longPressRecognizer.state !=UIGestureRecognizerStateBegan)
    {
        return;
    }
    if([self becomeFirstResponder] == NO)
    {
        return ;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.balloonView.frame inView:self];
    [menu setMenuVisible:YES animated:YES ];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:))
    {
        return YES;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

-(void)copy:(id)sender
{
    /*Copy the messageString to the clipboard*/
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.messageLabel.text];
}

@end
