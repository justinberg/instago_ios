//
//  FindFriendsViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "FindFriendsCell.h"

@interface FindFriendsViewController : PFQueryTableViewController <FindFriendsCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate>

@end
