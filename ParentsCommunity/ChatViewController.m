//
//  ChatViewController.m
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-18.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "ChatViewController.h"
#import "IMessageCell.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize messageTable = _messageTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"messagingCell";
    
    IMessageCell * cell = (IMessageCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[IMessageCell alloc] initMessagCellingWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_msgArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize messageSize = [IMessageCell messageSize:[_msgArr objectAtIndex:indexPath.row]];
    return messageSize.height+2*[IMessageCell textMarginVertical]+40.0f;
}
-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    IMessageCell* ccell = (IMessageCell*)cell;
    
    if (indexPath.row % 2 == 0) {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
    } else {
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
    }
    ccell.messageLabel.text = [_msgArr objectAtIndex:indexPath.row];
    ccell.timeLabel.text = @"2012-08-29";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _messageTable.delegate = self;
    _messageTable.dataSource = self ;
    _msgArr = [[NSMutableArray alloc] initWithObjects:
                 @"Hello, how are you.",
                 @"I'm great, how are you?",
                 @"I'm fine, thanks. Up for dinner tonight?",
                 @"Glad to hear. No sorry, I have to work.",
                 @"Oh that sucks. A pitty, well then - have a nice day.."
                 @"Thanks! You too. Cuu soon.",
                 nil];
    _messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
