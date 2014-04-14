//
//  SendMessageViewController.h
//  ParentsCommunity
//
//  Created by 张 诗杰 on 14-2-19.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCChatSelectionView.h"
#import "WCUserObject.h"
#import "XMPPRoom.h"
#import "GroupObject.h"
#import "EmojiKeyBoardView.h"
#import "ASIHttpRequest/ASIHTTPRequest.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "WCMessageCell.h"
#import "INavigationViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface SendMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,WCShareMoreDelegate,UIActionSheetDelegate,ASIProgressDelegate,INavigationViewControllerDelegate,UINavigationControllerDelegate,EmojiKeyboardViewDelegate,WCMessageCellChatImageTapDelegate,MWPhotoBrowserDelegate,UITextViewDelegate,EmojiKeyboardViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *msgRecords;
    UIImage *_myHeadImage,*_userHeadImage;
    WCChatSelectionView *_shareMoreView;
    XMPPRoom *_xmppRoom;
    NSMutableArray *_photos;
    NSMutableArray *_thumbs;
    NSMutableArray *_selections;
    MBProgressHUD *_HUD;
    UIImageView *inputBar;
     UITableView *msgRecordTable;

    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}
- (IBAction)sendIt:(id)sender;
- (IBAction)shareMore:(id)sender;
@property(nonatomic,strong)IBOutlet UITextView *messageText;

@property(nonatomic,strong)IBOutlet UIButton *selectEmotionBtn;
@property(nonatomic,strong)IBOutlet UIButton *takePicBtn;
@property(nonatomic)GroupObject *groupObj;
@end
