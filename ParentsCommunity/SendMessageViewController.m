;//
//  SendMessageViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-19.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "SendMessageViewController.h"
#import "WCMessageCell.h"
#import "Photo.h"
#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "NSString+XMLEntities.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "GroupInfoViewController.h"
#import "MHFacebookImageViewer.h"
#import "EmojiKeyBoardView.h"
#import "SREmojiConvertor.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "PersonalViewController.h"
#import "TipTableViewCell.h"
#import "WCMessageCell.h"
#import "NetWorkProblemTipView.h"
#import "NetWorkManager.h"
#define inputBarHeight 44.0f
#define messageTextInputHeight 30
@interface SendMessageViewController ()
{
    EmojiKeyBoardView *emojiKeyboardView;
    UITextField *tt ;
    UIImageView *bandView;
    NetWorkProblemTipView *connectionTipView;
    NSUInteger messagePageIndex;
    //该属性用来决定滚到第几行
    NSUInteger lastMessageRowIndex;
    dispatch_queue_t concurrentQueue;
}

@end

@implementation SendMessageViewController
@synthesize messageText,groupObj,selectEmotionBtn,takePicBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    concurrentQueue =  dispatch_queue_create(
                                             "com.example.gcd.MyConcurrentDispatchQueue",
                                             NULL);
    if(!IS_IPHONE5)
    {
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    // Do any additional setup after loading the view from its nib.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    msgRecordTable = [[UITableView alloc]initWithFrame:CGRectZero];
    msgRecordTable.delegate = self;
    msgRecordTable.dataSource = self ;
    if(IS_OS_7_OR_LATER)
    {
        //20 status bar height
        [msgRecordTable setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20 - inputBarHeight)];
    }else{
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height-10)];
        [msgRecordTable setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-inputBarHeight)];
    }
    [self.view addSubview:msgRecordTable];
    emojiKeyboardView = [[EmojiKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)] ;
    emojiKeyboardView.delegate = self;
    [inputBar setFrame:CGRectMake(0, self.view.bounds.size.height-inputBarHeight, self.view.bounds.size.width, inputBarHeight)];
    [inputBar setImage:[UIImage imageNamed:@"inputbg.png"]];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = groupObj.name;
    [messageText setFont:[UIFont systemFontOfSize:messageContentFontSize]];
    self.navigationItem.titleView = label;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bandSendMessage:) name:banSendMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reCoverMessage:) name:reCoverSendMessage object:nil];
    [self initMessage];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        _myHeadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head]]]];
//        _userHeadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:groupObj.roomIconUrl]]];
//        //回到主线程来处理
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [msgRecordTable reloadData];
//        });
//    });
    //messageText.frame = CGRectMake(10, 7, 230, 33);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [msgRecordTable addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [msgRecordTable setBackgroundView:nil];
    [msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _shareMoreView = [[WCChatSelectionView alloc]init];
    [_shareMoreView setFrame:CGRectMake(0, 0, 320, 170)];
    [_shareMoreView setDelegate:self];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"groupInfoIcon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoGroupInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.visibleViewController.navigationItem.rightBarButtonItem = customItem;
    tt = [[UITextField alloc]init];
    [self.view addSubview:tt];
    messageText.delegate = self;
    messageText.layer.cornerRadius = 4;
    messageText.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:inputBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkNoReach:) name:ConnectionNoReach object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkReach:) name:ConnectionReach object:nil];
    if (![NetWorkManager sharedInstance].connectionReachable) {
        [self networkNoReach:nil];
    }
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f -msgRecordTable.bounds.size.height, msgRecordTable.frame.size.width, msgRecordTable.bounds.size.height)];
		view.delegate = self;
        [view setBackgroundColor:[UIColor whiteColor]];
		[msgRecordTable addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark ---EGORefreshTableHeaderDelegate
//加载完成后调用的方法
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:msgRecordTable];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self pullMoreMessages];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void)networkNoReach:(NSNotification *)notification
{
    if(!connectionTipView)
    {
        connectionTipView = [[NetWorkProblemTipView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NetWorkProblemTipViewHEIGHT)];
        [self.view addSubview:connectionTipView];
    }
}

-(void)networkReach:(NSNotification *)notification
{
    if(connectionTipView)
    {
        [connectionTipView removeFromSuperview];
    }
    
}

-(void)bandSendMessage:(NSNotification *)nitification
{
    if (!bandView) {
        bandView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-43, self.view.bounds.size.width, 43)];
        messageText.userInteractionEnabled = NO;
        
        [bandView setImage:[UIImage imageNamed:@"bansendMessage"]];
        [self.view addSubview:bandView];
        bandView.userInteractionEnabled = NO;
        takePicBtn.userInteractionEnabled = NO;
        selectEmotionBtn.userInteractionEnabled = NO;
    }
}

-(void)reCoverMessage:(NSNotification *)nitification
{
    if (bandView) {
        [bandView removeFromSuperview];
        bandView = nil;
        messageText.userInteractionEnabled = YES;
        takePicBtn.userInteractionEnabled = YES;
        selectEmotionBtn.userInteractionEnabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark ---触摸关闭键盘---
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //变成第一响应
    [self.view endEditing:YES];
}

#pragma mark --键盘高度变化---
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获得到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyboardBeginBounds CGRectValue];
    
    //获得到键盘frame变化之后的frame
    NSValue *keyboardEndBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    //拿到frame变化之后的origin.y变化之前的origin.y,其差值(带正负号)就是我们self.view的y方向上的增量
    NSLog(@"delatY:%f",deltaY);
    NSTimeInterval duration = 0.4f;
    [CATransaction begin];
    if(deltaY >0)
    {
        duration = 0.2f;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [msgRecordTable setContentInset:UIEdgeInsetsMake(msgRecordTable.contentInset.top-deltaY, 0, 0, 0)];

    } completion:^(BOOL finished) {
    }];
    [CATransaction commit];
}

-(void)sendIt
{
    NSString *message = messageText.text;
    
    //首先判断有没有emoji表情
    //转换
    NSString *yourString = message;
    NSMutableArray *emojiArray = [self stringContainsEmoji:yourString];
    for (int i=0; i<[emojiArray count]; i++) {
        NSString *emojiOriginStr = emojiArray[i];
        NSString *iemojiStr ;
        NSData *data1 = [emojiOriginStr dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
        uint32_t unicode;
        [data1 getBytes:&unicode length:sizeof(unicode)];
        iemojiStr = [NSString stringWithFormat:@"[e]%x[/e]",unicode];
        message = [message stringByReplacingOccurrencesOfString:emojiOriginStr withString:iemojiStr];
    }
//    NSError *error = NULL;
//    
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[e\\](.*?)\\[/e\\]" options:NSRegularExpressionCaseInsensitive error:&error];
//    
//    
//    [regex enumerateMatchesInString:yourString options:0 range:NSMakeRange(0, [yourString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//        
//        // detect
//        NSString *insideString = [yourString substringWithRange:[match rangeAtIndex:1]];
//        
//        unsigned int outVal;
//        NSScanner* scanner = [NSScanner scannerWithString:insideString];
//        [scanner scanHexInt:&outVal];
//        
//        NSString *smiley = [[NSString alloc] initWithBytes:&outVal length:sizeof(outVal) encoding:NSUTF32LittleEndianStringEncoding];
//        NSLog(@"%@", smiley);
//        //print
//        NSLog(@"%@",insideString);
//        
//    }];
    
    if(message.length > 0 )
    {
        [self sendMessage:kWCMessageTypePlain text:message smallImageURLPath:nil bigImageURLPath:nil];
    }
    [messageText setText:nil];
}


- (NSMutableArray *)stringContainsEmoji:(NSString *)string {
    NSMutableArray *emojiArray = [[NSMutableArray alloc]init];
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     [emojiArray addObject:substring];
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 [emojiArray addObject:substring];
                 returnValue = YES;
             }
         }
     }];
    
    return emojiArray;
}


-(void)sendMessage:(NSInteger)type text:(NSString *)text smallImageURLPath:(NSString *)smallImageURLPath bigImageURLPath:(NSString *)bigImageURLPath
{
    //生成消息对象
    NSXMLElement *user = [NSXMLElement elementWithName:@"user"];
    NSString *role = [WCUserObject getLoginAccount].subName;
    NSString *fullName = [NSString stringWithFormat:@"%@的%@",[WCUserObject getLoginUserNickName],role];
    [user addAttributeWithName:@"nickname" stringValue:fullName];
    NSString *userHead = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head];
    
    [user addAttributeWithName:@"headimg" stringValue:userHead];
    NSXMLElement *msg = [NSXMLElement elementWithName:@"msg"];
    [msg addAttributeWithName:@"mid" stringValue:@""];
    [msg addAttributeWithName:@"type" stringValue:@"user"];

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    [msg addAttributeWithName:@"sendtime" stringValue: timeString];
    if(type == kWCMessageTypePlain)
    {
        [msg addAttributeWithName:@"mtype" stringValue:@"text"];
        NSXMLElement *content = [NSXMLElement elementWithName:@"content" stringValue:text];
        [msg addChild:content];
    }else if(type == kWCMessageTypeImage)
    {
        [msg addAttributeWithName:@"mtype" stringValue:@"img"];
        NSXMLElement *imgs = [NSXMLElement elementWithName:@"imgs"];
        if(smallImageURLPath)
        {
            NSXMLElement *smallImage = [NSXMLElement elementWithName:@"small" stringValue:smallImageURLPath];
            [imgs addChild:smallImage];
        }
        if(bigImageURLPath)
        {
            NSXMLElement *bigImage = [NSXMLElement elementWithName:@"big" stringValue:bigImageURLPath];
            [imgs addChild:bigImage];
        }
        [msg addChild:imgs];
    }

    [user addChild:msg];

    NSString *htmlstring = [[user XMLString] stringByDecodingHTMLEntities];
    NSXMLElement *body = [[NSXMLElement alloc] initWithName:@"body" stringValue:htmlstring];
    XMPPMessage *message = [XMPPMessage message];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",groupObj.roomXMPPid,xmppdomain]];
    [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    [message addChild:body];
    
    
    [[WCXMPPManager sharedInstance]sendMessage2Room:[NSString stringWithFormat:@"%@@%@",groupObj.roomXMPPid,xmppdomain] message:message];
    
}

-(void)uploadImage:(UIImage *)aImage message:(WCMessageObject *)message
{

    
    NSURL *url = [NSURL URLWithString:uploadMsgImage];
    ASIFormDataRequest *_request = [[ASIFormDataRequest alloc]initWithURL:url];
    __weak ASIFormDataRequest *request = _request;
    [request setData:UIImagePNGRepresentation(aImage) forKey:@"img"];
    [request setUploadProgressDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *rootDic = [parser objectWithString:responseString];
        NSLog(@"%@",[[rootDic valueForKey:@"result"]valueForKey:@"data"]);
        if([[rootDic valueForKey:@"result"] valueForKey:@"status"]==0)
        {
            [message setMessageStatus:kWCMessageFailed];
        }else{
            NSString *smallImagePath = [[[rootDic valueForKey:@"result"]valueForKey:@"data"] valueForKey:@"small"];
            NSString *bigImagePath = [[[rootDic valueForKey:@"result"]valueForKey:@"data"] valueForKey:@"big"];
            //发送xmpp消息
            [self sendMessage:kWCMessageTypeImage text:nil smallImageURLPath:smallImagePath bigImageURLPath:bigImagePath];
            [message setMessageStatus:kWCMessageDone];
        }


        //更新image状态
        [WCMessageObject updateMessageById:message];
        [self refresh];
    }];
    [request setFailedBlock:^{
        [message setMessageStatus:kWCMessageFailed];
        //更新image状态
        [WCMessageObject updateMessageById:message];
        [self refresh];
    }];
    [_request startAsynchronous];
}

#pragma mark delegate progress
-(void)setProgress:(float)newProgress
{
    NSLog(@"value: %f",newProgress);
}
#pragma mark UIActionSheetDelegate delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger imageSourceType;
    switch (buttonIndex) {
        case 0:
            imageSourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case 1:
            imageSourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            return ;
            break;
        default:
            return;
            break;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    [imgPicker setSourceType:imageSourceType];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    [self.navigationController presentViewController:imgPicker animated:YES completion:^{
    
    }];
}
-(IBAction)shareMore:(id)sender
{
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册图片",@"拍照", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(IBAction)selectEmoticon:(id)sender
{
    tt.inputView = emojiKeyboardView;
    [tt becomeFirstResponder];
}

#pragma mark ---图片选择完成---
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageSaveFolder];
        NSString *saveImageFullPath = [[[imagePath stringByAppendingString:@"/"] stringByAppendingString:[[NSUUID UUID] UUIDString]]stringByAppendingString:@".png"];
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            //不存在文件夹则创建
            [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        }
        //保存到该文件夹
        UIImage *compressImage = [self compressForUpload:chosedImage scale:0.125];
        NSData *imageData = UIImagePNGRepresentation(compressImage);
        if(![imageData writeToFile:saveImageFullPath atomically:NO])
        {
            //没有保存成功
            
        }else{
            //保存成功 生成消息
            WCMessageObject *message = [self saveImageMessage:saveImageFullPath url:nil];
            [self uploadImage:compressImage message:message];

        }
        // [self sendImage:chosedImage];
    }];
}
//保存自己发送的图片信息
-(WCMessageObject*)saveImageMessage:(NSString *)localPath url:(NSString *)url
{
    //存到数据库 发送新消息通知给界面
    WCMessageObject *imageMessage = [[WCMessageObject alloc]init];
    NSString *userHead = [[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head];
    imageMessage.headimg = userHead;
    imageMessage.imageLocalPath =localPath;
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000;
    long long inter = [[NSNumber numberWithDouble:timeInterval] longLongValue];

    [imageMessage setMessageId:[NSString stringWithFormat:@"%llu",inter]];
    if(url)
    {
        imageMessage.imageURLPath = url;
    }
    [imageMessage setMessageDate:date];
    
    [imageMessage setMessageFrom:[WCUserObject getLoginUserId]];
    [imageMessage setMessageRoom:groupObj.roomXMPPid];
    [imageMessage setMessageSendXMPPid:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
    [imageMessage setMessageReadFlag:kWCMessageReadStatusRead];
    [imageMessage setMessageType: kWCMessageTypeImage];
    imageMessage.messageTo = groupObj.roomXMPPid;
    if([WCMessageObject save:imageMessage])
    {
        return imageMessage;
    }else
    {
        return nil;
    }
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma mark ---tableView协议---

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgRecords count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出消息
    NSString *identifier;
    WCMessageObject *msg = [msgRecords objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if (msg.messageType != kWCMessageTypeDateTip && msg.messageType != kWCMessageTypeNotification) {
        identifier=@"messageCell";
        WCMessageCell *messagecell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!messagecell)
        {
            messagecell = [[WCMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        [messagecell setMessageObject:msg];
        messagecell.status = msg.messageStatus;
        if([msg.messageSendXMPPid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]])
        {
            [messagecell setName:[WCUserObject getLoginUserNickName]];
        }else{
            [messagecell setName:msg.messageFrom];
        }
        enum kWCMessageCellStyle style;
        //判断是自己的来是来自别人的消息 和是否是图片
//        if(msg.messageType == kWCMessageTypeDateTip)
//        {
//            style = kWCMessageCellStyleTip;
//        }else{
            style = [msg.messageSendXMPPid isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:kXMPPmyJID]]?kWCMessageCellStyleMe:kWCMessageCellStyleOther;
//        }
         NSString *loginUserHead = [WCUserObject getLoginUserHead];
        switch (style) {
            case kWCMessageCellStyleMe:
                if(loginUserHead && ![loginUserHead isEqualToString:@""])
                {
                    [messagecell setHeadImageWithURL:[NSURL URLWithString:loginUserHead]];
                }else
                {
                    [messagecell setHeadImage:[UIImage imageNamed:@"defaultUserHead"]];
                }
                if(msg.messageType == kWCMessageTypeImage){
                    style = kWCMessageCellStyleMeWithImage;
                    [messagecell setChatImage:[UIImage imageWithContentsOfFile:msg.imageLocalPath]];
                }
                break;
            case kWCMessageCellStyleOther:
                if(msg.headimg && ![msg.headimg isEqualToString:@""])
                {
                    [messagecell setHeadImageWithURL:[NSURL URLWithString:msg.headimg]];
                }else
                {
                    [messagecell setHeadImage:[UIImage imageNamed:@"defaultUserHead"]];
                }
                if(msg.messageType == kWCMessageTypeImage){
                    style = kWCMessageCellStyleOtherWithImage;
                    NSURL *downloadUrl = [NSURL URLWithString:msg.imageLocalPath];
                    NSURL *bigURL = [NSURL URLWithString:msg.imageURLPath];
                    [messagecell setChatImageWithURL:downloadUrl bigImg:bigURL];
                }
                break;
            case kWCMessageCellStyleMeWithImage:
                if(loginUserHead && ![loginUserHead isEqualToString:@""])
                {
                    [messagecell setHeadImageWithURL:[NSURL URLWithString:loginUserHead]];
                }else
                {
                    [messagecell setHeadImage:[UIImage imageNamed:@"defaultUserHead"]];
                }
                break;
            case kWCMessageCellStyleOtherWithImage:
                if(msg.headimg)
                {
                    [messagecell setHeadImageWithURL:[NSURL URLWithString:msg.headimg]];
                }else
                {
                    [messagecell setHeadImage:[UIImage imageNamed:@"defaultUserHead"]];
                }
                break;
//            case kWCMessageCellStyleTip:
//                [messagecell setMessageDate:msg.messageDate];
//                break;
            default:
                break;
        }
        messagecell.msgStyle = style;
        messagecell.delegate = self;
        cell = messagecell;
    }else if(msg.messageType == kWCMessageTypeDateTip)
    {
        identifier =@"tipCell";
        TipTableViewCell *tipCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!tipCell)
        {
            tipCell = [[TipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        cell = tipCell;
        [tipCell setMessageDate:msg.messageDate];
    }else if (msg.messageType == kWCMessageTypeNotification)
    {
        identifier =@"tipCell";
        TipTableViewCell *tipCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!tipCell)
        {
            tipCell = [[TipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        cell = tipCell;
        [tipCell setTipText:msg.messageContent];
    }

    
    cell.tag = indexPath.row;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([msgRecords[indexPath.row] messageType]==kWCMessageTypeImage)
    {
        return 75+100;
    }else if ([msgRecords[indexPath.row] messageType]==kWCMessageTypeDateTip || [msgRecords[indexPath.row] messageType]==kWCMessageTypeNotification)
    {
        return 25;
    }
    else{
        NSString *orgin = [msgRecords[indexPath.row]messageContent];
        CGSize textSize = [orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(320-HEAD_SIZE-3*INSETS-40, TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        return 75+textSize.height;
    }
}

#pragma   mark ---接受新消息广播---
-(void)newMsgCome:(NSNotification *)notifacation
{
    //[self.tabBarController.tabBarItem setBadgeValue:@"1"];
    //创建操作队列
//
    //设置队列中最大的操作数
//    [operationQueue setMaxConcurrentOperationCount:10];
//    //创建操作（最后的object参数是传递给selector方法的参数）
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handNewMsg) object:nil];
//    //将操作添加到操作队列
//    [operationQueue addOperation:operation];
    dispatch_block_t block = ^{
        [self handNewMsg];
    };
    if(dispatch_get_current_queue() == concurrentQueue)
    {
        block();
    }else{
        dispatch_sync(concurrentQueue,block);
    }

                  

}


-(void)handNewMsg
{


    [self fetchLastMessage];
    [self refresh];
    [msgRecordTable setNeedsLayout];
    [self scrollToBottomRow];
    
}

#pragma mark sharemore按钮组协议
-(void)pickPhoto
{

}

#pragma ---business--
-(void)gotoGroupInfo
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    GroupInfoViewController *groupInfoView = [[GroupInfoViewController alloc]init];
    [groupInfoView setGroup:groupObj];
    self.navigationItem.backBarButtonItem = backButton;
    [messageText resignFirstResponder];
    [self.navigationController pushViewController:groupInfoView animated:YES];
}

#pragma mark ---message handle---

-(void)scrollToBottomRow
{
    [msgRecordTable setNeedsLayout];
    if([msgRecords count]>0)
    {
     [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[msgRecords count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }

}

-(void)initMessage
{
    msgRecords = [[NSMutableArray alloc]init];
    messagePageIndex = 0 ;
    [self fetchPageIndexMessgae];
    [self refresh];
    [self scrollToBottomRow];
}

-(void)fetchPageIndexMessgae
{
    NSMutableArray *messageArr = [WCMessageObject fetchMessageListWithUserAndRoom:[WCUserObject getLoginUserId] roomName:groupObj.roomXMPPid byPage:messagePageIndex];
    messageArr = [[NSMutableArray alloc]initWithArray:[[messageArr reverseObjectEnumerator] allObjects]];
    if([messageArr count]>0)
    {
        lastMessageRowIndex = [messageArr count];
        [messageArr addObjectsFromArray:msgRecords];
        msgRecords = messageArr;
        messagePageIndex+=1;
    }
}

-(void)fetchLastMessage
{
    WCMessageObject *message = [WCMessageObject getLastMessageByRoom:groupObj.roomXMPPid];
    if(message)
    {
        [msgRecords addObject:message];
    }
}

-(void)pullMoreMessages
{
    _reloading = YES;
    CGSize lastContectSize = msgRecordTable.contentSize;
    [self fetchPageIndexMessgae];
    [self refresh];
    dispatch_async(dispatch_get_main_queue(), ^{
        [msgRecordTable setNeedsLayout];
        CGSize currentSize = msgRecordTable.contentSize;
        [msgRecordTable setContentOffset:CGPointMake(0, currentSize.height-lastContectSize.height+1) animated:NO];
    });
    [self doneLoadingTableViewData];
}


-(void)refresh
{
    if(msgRecords.count!=0)
    {
        //重新刷新
        [msgRecordTable reloadData];

        //滚到对应行
//        [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastMessageRowIndex-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    }
}




#pragma mark ---emojikeyboard delegate---
- (void)emojiKeyBoardView:(EmojiKeyBoardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    NSString *tt = [messageText.text stringByAppendingString:emoji];
    [messageText setText:tt];
    [self textViewDidChange:messageText];
}


- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyBoardView *)emojiKeyBoardView {
   // UITextRange *range =  messageText.selectedTextRange;
//    NSLog(@"%d",messageText.text.length);
//    if(messageText.text.length>0)
//    {
//        NSInteger endPosition =messageText.text.length-1;
//            if(endPosition<0)
//            {
//                messageText.text = @"";
//           }else{
//                NSRange range = NSMakeRange(endPosition, 1);
//                NSMutableString *text = [messageText.text mutableCopy];
//                NSRange backward = NSMakeRange(range.location, 1);
//                // NSLog(@"Length: %d Location: %d", backward.length, backward.location);
//                [text deleteCharactersInRange:backward];
//                messageText.text = text;
//           }
//    }
    [messageText deleteBackward];

}

#pragma  mark ---WCMessageImagetapDelegate---
-(void)WCMessageCellChatImageTap:(MWPhoto *)photo
{
    if(!_photos)
    {
        _photos = [[NSMutableArray alloc]init];
    }
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = YES;
        [browser setCurrentPhotoIndex:0];
    if(photo)
    {
        //每次只显示一张
        [_photos removeAllObjects];
        [_photos addObject:photo];
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)userHeadTap:(enum kWCMessageCellStyle)msgStyle
{
    //如果是我的头像
    if(msgStyle == kWCMessageCellStyleMe || msgStyle == kWCMessageCellStyleMeWithImage)
    {
            PersonalViewController *viewController = [[PersonalViewController alloc]init];
        
            [ self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)reSendMessage:(NSInteger)messageIndex
{
    if(messageIndex <[msgRecords count])
    {
      WCMessageObject *message = [msgRecords objectAtIndex:messageIndex];
        [message setMessageStatus:kWCMessageSending];
        [WCMessageObject updateMessageById:message];
        [self refresh];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:message.imageLocalPath];
        [self uploadImage:image message:message];
    }

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    //保存图片
    MWPhoto *photo = [_photos objectAtIndex:index];
    if ([photo underlyingImage]) {
        [self showProgressHUDWithMessage:@"正在保存"];
        UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }

}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    //[self dismissViewControllerAnimated:YES completion:nil];
}




#pragma ---HUDProhress---
-(MBProgressHUD *)HUD
{
    if(!_HUD)
    {
        _HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
        _HUD.minSize = CGSizeMake(120, 120);
        _HUD.minShowTime = 1;
        
    }
    _HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [self.navigationController.view addSubview:_HUD];
    return _HUD;
}

-(void)showProgressHUDWithMessage:(NSString *)message
{
    self.HUD.labelText = message;
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.HUD show:YES];
}

-(void)hideProgressHUD:(BOOL)animated
{
    [self.HUD hide:animated];
}

-(void)showProgressHUDCompleteMessage:(NSString *)message
{
    if(message)
    {
        if(self.HUD.isHidden)[self.HUD show:YES];
        self.HUD.labelText = message;
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD hide:YES afterDelay:1.5];
    }else{
        [self.HUD hide:YES];
    }
}

#pragma ---save Image to album---
-(void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [self showProgressHUDCompleteMessage:@"保存成功"];
}

#pragma mark ---IUINavigationController
-(void)navigationWillShowTheView
{
    GroupObject *group = [GroupObject getGroupByid:groupObj.roomXMPPid];
    if(group.speakstate ==1)
    {
        [self bandSendMessage:nil];
    }
}


#pragma mark ---UITextViewDelegeate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [self sendIt];
        [self changeInputBarHeight:messageTextInputHeight];
        return NO;
    }else{
        return YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString * tweetTextString = textView.text;
    
    CGSize textSize = [tweetTextString sizeWithFont:[UIFont systemFontOfSize:messageContentFontSize] constrainedToSize:CGSizeMake(240, 20000) lineBreakMode: NSLineBreakByCharWrapping]; //Assuming your width is 240
    
    float heightToAdd = MIN(textSize.height, 100.0f); //Some fix height is returned if height is small or change it to MAX(textSize.height, 150.0f); // whatever best fits for you
    if(heightToAdd<inputBarHeight)heightToAdd=messageTextInputHeight;
    [UIView animateWithDuration:0.2 animations:^{
        [self changeInputBarHeight:heightToAdd];
        
    } completion:^(BOOL finished) {
    }];
    [CATransaction commit];
}

-(void)changeInputBarHeight:(CGFloat)height
{
    [inputBar setFrame:CGRectMake(inputBar.frame.origin.x,self.view.frame.size.height-height-14 , inputBar.frame.size.width, height+14)];
    [messageText setFrame:CGRectMake(messageText.frame.origin.x, messageText.frame.origin.y, messageText.frame.size.width, height)];
}

@end
