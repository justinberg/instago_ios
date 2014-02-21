//
//  SettingsActionSheetDelegate.m
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "SettingsActionSheetDelegate.h"
#import "FindFriendsViewController.h"
#import "AccountViewController.h"
#import "AppDelegate.h"

// ActionSheet button indexes
typedef enum {
	kPAPSettingsProfile = 0,
	kPAPSettingsFindFriends,
	kPAPSettingsLogout,
    kPAPSettingsNumberOfButtons
} kPAPSettingsActionSheetButtons;

@implementation SettingsActionSheetDelegate

@synthesize navController;

#pragma mark - Initialization

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        navController = navigationController;
    }
    return self;
}

- (id)init {
    return [self initWithNavigationController:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!self.navController) {
        [NSException raise:NSInvalidArgumentException format:@"navController cannot be nil"];
        return;
    }
    
    switch ((kPAPSettingsActionSheetButtons)buttonIndex) {
        case kPAPSettingsProfile:
        {
            AccountViewController *accountViewController = [[AccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [accountViewController setUser:[PFUser currentUser]];
            [navController pushViewController:accountViewController animated:YES];
            break;
        }
        case kPAPSettingsFindFriends:
        {
            FindFriendsViewController *findFriendsVC = [[FindFriendsViewController alloc] init];
            [navController pushViewController:findFriendsVC animated:YES];
            break;
        }
        case kPAPSettingsLogout:
            // Log out user and present the login view controller
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
            break;
        default:
            break;
    }
}

@end
