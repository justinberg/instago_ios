//
//  SearchUserViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "FindFriendsCell.h"

@interface SearchUserViewController :  PFQueryTableViewController <FindFriendsCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate,UISearchBarDelegate> {
    
    PFQuery *querys;
}

@property (nonatomic,retain) PFQuery *querys;

@end

