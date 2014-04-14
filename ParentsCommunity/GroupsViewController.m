//
//  GroupsViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-25.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupObject.h"
#import "AppDelegate.h"
#import "GroupCell.h"
#import "SendMessageViewController.h"
#import "ItestViewController.h"
#import "GroupInfoViewController.h"
#import "GroupInstructionCell.h"
#import "NetWorkProblemTipView.h"
#import "NetWorkManager.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface GroupsViewController ()
{

    UITableView *_tableView;
    BOOL haveJoined;
}

@end

@implementation GroupsViewController
@synthesize managedObjectContext = _managedObjectContext;
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
    if(!IS_IPHONE5)
    {
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    haveJoined = NO;
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] ;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = @"家长会";
    deletage.topTabBarController.navigationItem.titleView = label;
    
    _tableView = [[UITableView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -55-deletage.navigationController.navigationBar.frame.size.height)];
    NSLog(@"%f",_tableView.frame.size.height);
    NSLog(@"%f",self.view.frame.origin.y);
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    // Do any additional setup after loading the view from its nib.

    _managedObjectContext = deletage.managedObjectContext;
    deletage.topTabBarController.navigationItem.hidesBackButton = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(joinRoom) name:joinRoomNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRemoteGroupList) name:getRemoteGroupListNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:refreshGroupsNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkNoReach:) name:ConnectionNoReach object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkReach:) name:ConnectionReach object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitTheGroupAction:) name:exitTheGroup object:nil];
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    [_tableView setSeparatorColor:[UIColor colorWithRed:0.827f green:0.859f blue:0.871f alpha:1]];
    [self getGroups];
    [self refresh];
}

-(void)exitTheGroupAction:(NSNotification *)notifiaction
{
    NSString *roomId = notifiaction.object;
    [GroupObject deleteGroupById:roomId];
    [self refresh];
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    [deletage.navigationController popToRootViewControllerAnimated:YES];
}

-(void)networkNoReach:(NSNotification *)notification
{
    if([_groupRecords count]>0)
    {
        GroupObject *groupObj = _groupRecords[0];
        if(groupObj.grouptype == NetworkProblemTipGroup)
        {
            return ;
        }
    }
    GroupObject *groupObj = [[GroupObject alloc]init];
    groupObj.grouptype = NetworkProblemTipGroup;
    [_groupRecords insertObject:groupObj atIndex:0];
    [_tableView reloadData];
}

-(void)networkReach:(NSNotification *)notification
{
    if([_groupRecords count]>0)
    {
        GroupObject *groupObj = _groupRecords[0];
        if(groupObj.grouptype == NetworkProblemTipGroup)
        {
            [_groupRecords removeObjectAtIndex:0];
            [_tableView reloadData];
        }
    }
    
}

-(void)tableTapGesture:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
       // [
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"213");
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    UILabel *label = (UILabel *)deletage.topTabBarController.navigationItem.titleView;
    label.text =@"家长会";
    deletage.topTabBarController.navigationItem.titleView =label;
    deletage.topTabBarController.navigationItem.rightBarButtonItem = nil;
    [super viewWillAppear:animated];
}

-(void)joinRoom
{
    for (GroupObject * obj in _groupRecords) {
        //连接已经加入的群
        if(obj.isAlreadyIn == 1)
        {
            NSString *myJid = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            [[WCXMPPManager sharedInstance]joinRoom:[NSString stringWithFormat:@"%@@%@",obj.roomXMPPid,xmppdomain] nickname:myJid];
        }
    }
    haveJoined = YES;
}
-(void)getGroups
{
    NSURL *url = [NSURL URLWithString:getRoomList];
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    [_request setPostValue:[WCUserObject getLoginUserId]  forKey:@"username"];
    __weak ASIFormDataRequest *request = _request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSDictionary *rootDic = [parser objectWithString:responseString];
        NSArray *joinRooms = [[[rootDic objectForKey:@"result"] objectForKey:@"data"] objectForKey:@"joinRoom"];
        NSArray *canjoinRooms = [[[rootDic objectForKey:@"result"] objectForKey:@"data"] objectForKey:@"canJoinRoom"];
        //create group object
        NSError *error;
        //先删除原来的group记录
        [GroupObject deleteAllGroup];
        
        for (NSDictionary *room in joinRooms)
        {
            GroupObject *group = [[GroupObject alloc]init];
            group.roomXMPPid = [NSString stringWithFormat:@"%@",[room objectForKey:@"roomId"]];
            group.name = [room objectForKey:@"name"];
            group.roomIconUrl = [room objectForKey:@"roomIconUrl"];
            group.roomIntroduction = [room objectForKey:@"roomIntroduction"];
            group.roomMember = [[room objectForKey:@"roomMember"] intValue];
            group.isAlreadyIn = [[room objectForKey:@"isAlreadyIn"] intValue];
            group.isNeedVerify = [[room objectForKey:@"isNeedVerify"] intValue];
            group.roomAdmin = [room objectForKey:@"roomAdmin"];
            group.speakstate = [[room objectForKey:@"speakstate"]intValue];
            if(room == joinRooms[0])
            {
                group.grouptype = TopGroup;
            }else{
                group.grouptype = NormalGroup;
            }

            if (![GroupObject save:group]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }else{
                if(haveJoined)
                {
                    [self joinRoom];
                }
            }
        }
        for (NSDictionary *room in canjoinRooms)
        {
            GroupObject *group = [[GroupObject alloc]init];
            group.roomXMPPid = [NSString stringWithFormat:@"%@",[room objectForKey:@"roomId"]];
            group.name = [room objectForKey:@"name"];
            group.roomIconUrl = [room objectForKey:@"roomIconUrl"];
            group.roomIntroduction = [room objectForKey:@"roomIntroduction"];
            group.roomMember = [[room objectForKey:@"roomMember"] intValue];
            group.isAlreadyIn = [[room objectForKey:@"isAlreadyIn"] intValue];
            group.isNeedVerify = [[room objectForKey:@"isNeedVerify"] intValue];
            group.roomAdmin = [room objectForKey:@"roomAdmin"];
            group.speakstate = [[room objectForKey:@"speakstate"]intValue];
            group.grouptype = NormalGroup;
            [GroupObject save:group];
        }
        [self refresh];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@",error);
        NSLog(@"%@",[[request url] debugDescription]);
       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"连接错误" message:[[request url] debugDescription] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }];
    [request startAsynchronous];
    
}


-(void)getRemoteGroupList
{
    [self getGroups];
}

-(void)refresh
{
//    joinedNum = 0 ;
//    
//    for (GroupObject *obj in _groupRecords) {
//        if(obj.isAlreadyIn == 1)
//        {
//            joinedNum = joinedNum+1;
//        }
//    }
    [self fetchGroup];
    NSLog(@"%lu",(unsigned long)[_groupRecords count]);;
//    if([_groupRecords count]!=0)
//    {
        [_tableView reloadData];
//    }
}


-(void)fetchGroup
{
    _groupRecords = [NSMutableArray arrayWithArray:[GroupObject fetchGroupsWithUser]];
    _groupRecords = [self resortGroup:_groupRecords];

}

-(NSMutableArray *)resortGroup:(NSMutableArray *)groupRecords
{
    if([groupRecords count]>0)
    {
        NSInteger jm = 0 ;
        for (GroupObject *obj in groupRecords) {
            if(obj.isAlreadyIn == 1)
            {
                jm = jm+1;
            }
        }
        GroupObject *group = [[GroupObject alloc]init];
        group.grouptype = GapGroup;
        [groupRecords insertObject:group atIndex:jm];
    }
    if(![NetWorkManager sharedInstance].connectionReachable)
    {
        [self networkNoReach:nil];
    }
    return groupRecords;
}



-(void)setGroupRecords:(NSMutableArray *)groupRecords
{
    _groupRecords = groupRecords;
    _groupRecords = [self resortGroup:_groupRecords];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_groupRecords count]>0)
    {
        return ([_groupRecords count]) ;
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *topGroupIdentifier = @"groupsIdentifier";
    static NSString *gapGroupIdentifier = @"gapGroupIdentifier";
    static NSString *normalIdentifier = @"normalIdentifier";
    static NSString *networkTipIdentifier = @"networkTipIdentifier";
    UITableViewCell *cell = nil;
    GroupObject *groupObj = nil;
     groupObj = [_groupRecords objectAtIndex:indexPath.row];
    if(groupObj.grouptype == TopGroup || groupObj.grouptype == NormalGroup)
    {
        if(groupObj.grouptype ==TopGroup)
        {
            cell =[tableView dequeueReusableCellWithIdentifier:topGroupIdentifier];
            if(!cell)
            {
                cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topGroupIdentifier];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.867f green:0.925f blue:0.953f alpha:1];
        }else
        {
            cell =[tableView dequeueReusableCellWithIdentifier:normalIdentifier];
            if(!cell)
            {
                cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
            }
        }

        ((GroupCell *)cell).groupObj =groupObj;
        [((GroupCell *)cell).groupImageView setImageWithURL:[NSURL URLWithString:groupObj.roomIconUrl]];
        ((GroupCell *)cell).groupNameLabel.text = groupObj.name;
        [((GroupCell *)cell).groupNameLabel sizeToFit];
        WCMessageObject *message = [WCMessageObject getLastMessageByRoom:groupObj.roomXMPPid];
        if(message.messageType == kWCMessageTypeImage)
        {
            ((GroupCell *)cell).preViewLabel.text = @"[图片]";
        }else{
            if (message) {
                NSString *mm =[WCMessageObject convertXESemojiSymbol:message.messageContent];
                ((GroupCell *)cell).preViewLabel.text =mm;
                NSDate *date = message.messageDate;
                NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
                fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                fmt.dateFormat = @"HH:mm";
                NSString* dateString = [fmt stringFromDate:date];
                [((GroupCell *)cell) setPeopleNum:dateString];
            }else{
                [((GroupCell *)cell) setPeopleNum:[NSString stringWithFormat:@"%ld人",(long)groupObj.roomMember]];
            }
            
        }

    }else if (groupObj.grouptype == GapGroup)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:gapGroupIdentifier];
        if(!cell)
        {
            cell = [[GroupInstructionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gapGroupIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (groupObj.grouptype == NetworkProblemTipGroup)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:networkTipIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:networkTipIdentifier];
            cell.backgroundView = [[NetWorkProblemTipView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NetWorkProblemTipViewHEIGHT)];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
 
//    if(indexPath.row == (joinedNum))
//    {
//
//    }else{
//
//        GroupObject *groupObj = nil;
//        if(indexPath.row<joinedNum)
//        {
//            groupObj = [_groupRecords objectAtIndex:indexPath.row];
//        }else{
//            groupObj = [_groupRecords objectAtIndex:indexPath.row-1];
//        }
//        cell =[tableView dequeueReusableCellWithIdentifier:topGroupIdentifier];
//        if(!cell)
//        {
//            cell = [[GroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIdentifier];
//            ((GroupCell *)cell).groupObj =groupObj;
//            [((GroupCell *)cell).groupImageView setImageWithURL:[NSURL URLWithString:groupObj.roomIconUrl]];
//            ((GroupCell *)cell).groupNameLabel.text = groupObj.name;
//            [((GroupCell *)cell).groupNameLabel sizeToFit];
//            WCMessageObject *message = [WCMessageObject getLastMessageByRoom:groupObj.roomXMPPid];
//            if(message.messageType == kWCMessageTypeImage)
//            {
//                ((GroupCell *)cell).preViewLabel.text = @"[图片]";
//            }else{
//                if (message) {
//                    NSString *mm =[WCMessageObject convertXESemojiSymbol:message.messageContent];
//                    ((GroupCell *)cell).preViewLabel.text =mm;
//                    NSDate *date = message.messageDate;
//                    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//                    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//                    fmt.dateFormat = @"HH:mm";
//                    NSString* dateString = [fmt stringFromDate:date];
//                    [((GroupCell *)cell) setPeopleNum:dateString];
//                }else{
//                    [((GroupCell *)cell) setPeopleNum:[NSString stringWithFormat:@"%ld人",(long)groupObj.roomMember]];
//                }
//
//            }
//
//            if(indexPath.row==0)
//            {
//               // cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_group_bg.png"]];
//                cell.backgroundColor = [UIColor colorWithRed:0.867f green:0.925f blue:0.953f alpha:1];
//            }
//        }
//
//    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)] || IS_OS_7_OR_LATER) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupObject *groupObj = _groupRecords[indexPath.row];
    if(groupObj.grouptype == NetworkProblemTipGroup)
    {
        return NetWorkProblemTipViewHEIGHT;
    }else{
        return GROUPCELLHEIGHT ;
    }


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupObject *groupObj = nil;
    groupObj = [_groupRecords objectAtIndex:indexPath.row];
    if(groupObj.grouptype == TopGroup || groupObj.grouptype == NormalGroup)
    {
        AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                       target:nil
                                       action:nil];
        //如果isAlreadyIn为1 代表该群已加入
        if (groupObj.isAlreadyIn>0) {
            SendMessageViewController *sendMsgView = [[SendMessageViewController alloc]init];
            sendMsgView.groupObj =groupObj;

            [deletage.navigationController pushViewController:sendMsgView animated:YES];

            [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifiactionReaded object:groupObj];
        }else{
            GroupInfoViewController *groupInfoView = [[GroupInfoViewController alloc]init];
            [groupInfoView setGroup:groupObj];
            AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
            [deletage.navigationController pushViewController:groupInfoView animated:YES];
        }
        deletage.topTabBarController.navigationItem.backBarButtonItem = backButton;
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---ABTabBarController---
-(void)abTabControllerWillAdd
{
    AppDelegate *deletage = [[UIApplication sharedApplication]delegate] ;
    UILabel *label = (UILabel *)deletage.topTabBarController.navigationItem.titleView;
    label.text =@"家长会";
    deletage.topTabBarController.navigationItem.titleView =label;
   [[WCMessageObject sharedInstance] getRemoteHistoryMsg];
}

#pragma  ---UInavigationControllerDelegate---
@end
