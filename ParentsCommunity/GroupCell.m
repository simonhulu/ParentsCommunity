//
//  GroupCell.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-28.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell
@synthesize groupObj,groupImageView,groupNameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        groupImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 46, 46)];
        groupNameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(66, 7, 100, 44)];
        totalNum = [[UILabel alloc]initWithFrame:CGRectZero];
        [totalNum setFont:[UIFont systemFontOfSize:15]];
        totalNum.textAlignment = NSTextAlignmentLeft;

        [totalNum setTextColor:[UIColor colorWithRed:0.851f green:0.851f blue:0.851f alpha:1]];
        _preViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(66, 33, 260, 20)];
        [_preViewLabel setFont:[UIFont systemFontOfSize:15]];
        [_preViewLabel setTextColor:[UIColor colorWithRed:0.569f green:0.576f blue:0.580f alpha:1]];
        [self addSubview:groupNameLabel];
        [self addSubview:groupImageView];
        [self addSubview:totalNum];
        [self addSubview:_preViewLabel];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newXmppMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newXmppMsgReaded:) name:kXMPPNewMsgNotifiactionReaded object:nil];
    }
    return self;
}



-(void)newXmppMsgReaded:(NSNotification *)notification
{
    GroupObject *group = notification.object;
    if([group.roomXMPPid isEqualToString: groupObj.roomXMPPid])
    {
        [self removeMessageCircle];
    }
}

-(void)newXmppMsgCome:(NSNotification *)notifacation
{
    WCMessageObject *message = notifacation.object;
    //不是自己发的
    if([message.messageRoom isEqualToString: groupObj.roomXMPPid] && ![message.messageSendXMPPid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]])
    {
        [self setMessageCircle];

    }
    if([message.messageRoom isEqualToString: groupObj.roomXMPPid])
    {
        if(message.messageType == kWCMessageTypeImage)
        {
            _preViewLabel.text = @"图片";
        }else{
            NSString *messageContent = [WCMessageObject convertXESemojiSymbol:message.messageContent];
            _preViewLabel.text = messageContent;
        }
    }
}

-(void)setMessageCircle
{
    if(!circleView)
    {
        circleView = [[UIView alloc]initWithFrame:CGRectMake(51, 2, 10, 10)];
        circleView.layer.cornerRadius = 5;
        circleView.backgroundColor = [UIColor colorWithRed:0.957f green:0.169f blue:0.188f alpha:1];
        [self addSubview:circleView];
    }
    
    
}


-(void)removeMessageCircle
{
    if(circleView)
    {
        [circleView removeFromSuperview];
        circleView = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setPeopleNum:(NSString *)num
{
    totalNum.text = num;
    [totalNum sizeToFit];
    [totalNum setFrame:CGRectMake(self.bounds.size.width-totalNum.frame.size.width-10, 7, totalNum.frame.size.width, totalNum.frame.size.height)];
}

@end
