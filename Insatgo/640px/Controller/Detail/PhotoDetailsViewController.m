//
//  PhotoDetailsViewController.m
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "BaseTextCell.h"
#import "ActivityCell.h"
#import "PhotoDetailsFooterView.h"
#import "Constants.h"
#import "AccountViewController.h"
#import "LoadMoreCell.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "UITabBarController+hidable.h"
#import "Settings.h"



enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1
};

@interface PhotoDetailsViewController ()
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) PhotoDetailsHeaderView *headerView;
@property (nonatomic, assign) BOOL likersQueryInProgress;
@end

static const CGFloat kPAPCellInsetWidth = 0.0f;

@implementation PhotoDetailsViewController{
    
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
}

@synthesize commentTextField;
@synthesize photo, headerView;

#pragma mark - Initialization

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
}

- (id)initWithPhoto:(PFObject *)aPhoto {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kPAPActivityClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of comments to show per page
        self.objectsPerPage = 30;
        
        self.photo = aPhoto;
        
        self.likersQueryInProgress = NO;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        hidden = NO;
    }
    return self;
}



#pragma mark - UIViewController

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoNavigationBar.png"]];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake( 0.0f, 0.0f, 52.0f, 32.0f);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    backButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0f, 5.0f, 0.0f, 0.0f);
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"buttonBack.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"buttonBackSelected.png"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // Set table view properties
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    // texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLeather.png"]];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.tableView.backgroundView = texturedBackgroundView;
    
    // Set table header
    self.headerView = [[PhotoDetailsHeaderView alloc] initWithFrame:[PhotoDetailsHeaderView rectForView] photo:self.photo];
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    
    
    
    
    
    // Set table footer
    PhotoDetailsFooterView *footerView = [[PhotoDetailsFooterView alloc] initWithFrame:[PhotoDetailsFooterView rectForView]  ];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    
    
    
    
    
    
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(280, 10, 30, 30) ];
    //[btn setBackgroundColor:[UIColor colorWithRed:130.0f/255.0f green:65.0f/255.0f blue:211.0f/255.0f alpha:0.5f]];
    [btn setBackgroundImage:[UIImage imageNamed:@"report3.png"] forState:UIControlStateNormal];
    // [btn setTitle:NSLocalizedString( @"Report photo",nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reportPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:btn];
    
    NSString *alertz = self.photo.objectId;
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query getObjectInBackgroundWithId:alertz block:^(PFObject *alertLable, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"%@", alertLable);
        NSString *labz = alertLable[@"alert"];
        NSLog(@"lable - %@",labz);
        
        if([labz  isEqual: @"spam"]){
            
            NSLog(@"LAble spam");
            NSString *userAd = [[PFUser currentUser] objectForKey:@"channel"];
            NSLog(@"USER - %@",userAd);
            if([userAd  isEqual:AdministratorAccountFull]){
                
                UIImageView *spam = [[UIImageView alloc] initWithFrame:CGRectMake(280, 326, 40, 40) ];
                [spam setBackgroundColor:[UIColor clearColor]];
                [spam setImage:[UIImage imageNamed:@"spam.png"]];
                
                
                [self.tableView addSubview:spam];
                
            }
            
            
            
        }
        
        
    }];
    
    
    
    
    if (![self currentUserOwnsPhoto]) {
        
        // Use UIActivityViewController if it is available (iOS 6 +)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activityButtonAction:)];
    }  else if ([self currentUserOwnsPhoto]){
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonAction:)];
        
    }
    
    NSString *userAd = [[PFUser currentUser] objectForKey:@"channel"];
    NSLog(@"USER - %@",userAd);
    if([userAd  isEqual: AdministratorAccountFull]){
        
        NSLog(@"Jr");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonAction:)];
        
    }
    
    
    
    
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        self.refreshControl.tintColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
        self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
    }
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:hidden
                                             animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headerView reloadLikeBar];
    
    // we will only hit the network if we have no cached data for this photo
    BOOL hasCachedLikers = [[Cache sharedCache] attributesForPhoto:self.photo] != nil;
    if (!hasCachedLikers) {
        [self loadLikers];
    }
    
    // [self.tabBarController setTabBarHidden:hidden
    //                            animated:NO];
}

-(void)reportPhoto{
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Report photo!", nil)
                                                      message:NSLocalizedString(@"",nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            otherButtonTitles:NSLocalizedString(@"Photo contains nudity",nil),
                            NSLocalizedString(@"Bullying",nil),
                            NSLocalizedString(@"Threads of violence",nil),
                            // NSLocalizedString(@"Copyright",nil),
                            NSLocalizedString(@"Photo contains advertising",nil),
                            // NSLocalizedString(@"Fake photo",nil),
                            nil];
    [message show];
    
    
    
    
    
    
}

-(void)alertView:(UIAlertView *)message clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        
        NSLog(@"index-0");
        
        return;
    }
    
    if (buttonIndex == 1){
        
        NSLog(@"index-1");
    }
    
    if (buttonIndex == 2){
        
        NSLog(@"index-2");
    }
    
    if (buttonIndex == 3){
        
        NSLog(@"index-3");
    }
    
    if (buttonIndex == 4){
        
        NSLog(@"index-4");
    }
    NSString *messageAllert = [message buttonTitleAtIndex:buttonIndex];
    // Create notification message
    NSString *alertm =messageAllert;
    NSString *userFirstName = [Utility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]];
    NSString *messagez = [NSString stringWithFormat:@"%@: %@", userFirstName, alertm];
    
    
    
    
    NSDictionary *payload =
    [NSDictionary dictionaryWithObjectsAndKeys:
     kAPNSSoundKey1,kAPNSSoundKey,kAPNSBadgeKey1,kAPNSBadgeKey, messagez, kAPNSAlertKey,
     kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
     kPAPPushPayloadActivityCommentKey, kPAPPushPayloadActivityTypeKey,
     [[PFUser currentUser]objectId], kPAPPushPayloadFromUserObjectIdKey,
     [self.photo objectId], kPAPPushPayloadPhotoObjectIdKey,
     nil];
    NSLog(@"%@",payload);
    // Send the push
    
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:AdministratorAccountFull];
    [push setData:payload];
    [push sendPushInBackground];
    //  NSString *alertz = self.photo.objectId;
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName: kPAPPhotoClassKey];
    NSString *photoObg = self.photo.objectId;
    
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:photoObg block:^(PFObject *alertTag, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        alertTag[@"alert"] = @"spam";
        
        [alertTag saveInBackground];
        
    }];
    
    //NSString *adminz = @"BF09fQijYr";
    // PFQuery *admin = [PFUser objectWithoutDataWithObjectId:@"BF09fQijYr"];
    PFUser *admin = [PFUser objectWithoutDataWithObjectId:AdministratorAccount];
    NSLog(@"%@",admin);
    PFObject *alertAcive = [PFObject objectWithClassName:kPAPActivityClassKey];
    [alertAcive setObject:messagez forKey:kPAPActivityContentKey]; // Set alert text
    [alertAcive setObject:admin forKey:kPAPActivityToUserKey]; // Set toUser
    [alertAcive setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey]; // Set fromUser
    [alertAcive setObject:kPAPActivityTypeReport forKey:kPAPActivityTypeKey];
    [alertAcive setObject:self.photo forKey:kPAPActivityPhotoKey];
    
    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    [ACL setWriteAccess:YES forUser:[self.photo objectForKey:kPAPPhotoUserKey]];
    alertAcive.ACL = ACL;
    [alertAcive saveInBackground];
    
    
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) { // A comment row
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        if (object) {
            NSString *commentString = [self.objects[indexPath.row] objectForKey:kPAPActivityContentKey];
            
            PFUser *commentAuthor = (PFUser *)[object objectForKey:kPAPActivityFromUserKey];
            
            NSString *nameString = @"";
            if (commentAuthor) {
                nameString = [commentAuthor objectForKey:kPAPUserDisplayNameKey];
            }
            
            return [ActivityCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:kPAPCellInsetWidth];
        }
    }
    
    // The pagination row
    return 44.0f;
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query includeKey:kPAPActivityFromUserKey];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
    [query orderByAscending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
    
    [self.headerView reloadLikeBar];
    [self loadLikers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    BaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kPAPCellInsetWidth;
        cell.delegate = self;
    }
    
    [cell setUser:[object objectForKey:kPAPActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kPAPActivityContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kPAPCellInsetWidth;
        cell.hideSeparatorTop = YES;
    }
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 && [self.photo objectForKey:kPAPPhotoUserKey]) {
        PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
        [comment setObject:trimmedComment forKey:kPAPActivityContentKey]; // Set comment text
        [comment setObject:[self.photo objectForKey:kPAPPhotoUserKey] forKey:kPAPActivityToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey]; // Set fromUser
        [comment setObject:kPAPActivityTypeComment forKey:kPAPActivityTypeKey];
        [comment setObject:self.photo forKey:kPAPActivityPhotoKey];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[self.photo objectForKey:kPAPPhotoUserKey]];
        comment.ACL = ACL;
        
        [[Cache sharedCache] incrementCommentCountForPhoto:self.photo];
        
        // Show HUD view
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": comment} repeats:NO];
        
        [comment saveEventually:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
            
            if (error && error.code == kPFErrorObjectNotFound) {
                [[Cache sharedCache] decrementCommentCountForPhoto:self.photo];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not post comment", nil) message:NSLocalizedString(@"This photo is no longer available", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.photo userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
            
            // Comment saved successfully, so now we send out pushes
            
            // This will hold the channels we send the notification
            NSMutableSet *channelSet = [NSMutableSet setWithCapacity:self.objects.count];
            
            // Get all commenters and add them to the channel set
            for (PFObject *comment in self.objects) {
                PFUser *author = [comment objectForKey:kPAPActivityFromUserKey];
                NSString *privateChannelName = [author objectForKey:kPAPUserPrivateChannelKey];
                if (privateChannelName
                    && privateChannelName.length != 0
                    && ![[author objectId] isEqualToString:[[PFUser currentUser] objectForKey:kPAPUserPrivateChannelKey]]) {
                    [channelSet addObject:privateChannelName];
                }
            }
            
            // Explicitly add the photographer in case he didn't comment
            // [channelSet addObject:[self.photo objectForKey:kPAPPhotoUserKey]];
            
            NSLog(@" %@",channelSet);
            
            if (channelSet.count > 0) {
                
                // Create notification message
                NSString *userFirstName = [Utility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]];
                NSString *message = [NSString stringWithFormat:@"%@: %@", userFirstName, trimmedComment];
                
                // Truncate message if necessary and ensure we have enough space
                // for the rest of the payload
                if (message.length > 100) {
                    message = [message substringToIndex:99];
                    message = [message stringByAppendingString:@"..."];
                }
                
                
                NSDictionary *payload =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 kAPNSSoundKey1,kAPNSSoundKey,kAPNSBadgeKey1,kAPNSBadgeKey, message, kAPNSAlertKey,
                 kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                 kPAPPushPayloadActivityCommentKey, kPAPPushPayloadActivityTypeKey,
                 [[PFUser currentUser]objectId], kPAPPushPayloadFromUserObjectIdKey,
                 [self.photo objectId], kPAPPushPayloadPhotoObjectIdKey,
                 nil];
                NSLog(@"%@",payload);
                // Send the push
                
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannels:[channelSet allObjects]];
                [push setData:payload];
                [push sendPushInBackground];
            }
            
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
    
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == MainActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            // prompt to delete
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
            actionSheet.tag = ConfirmDeleteActionSheetTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else {
            [self activityButtonAction:actionSheet];
        }
    } else if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            [self shouldDeletePhoto];
        }
    } else if (actionSheet.tag == MainActionSheetTag)  {
        
        if(buttonIndex == 3){
            
            NSLog(@"WWW");
        }
        
        
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [commentTextField resignFirstResponder];
    
}


#pragma mark - PAPBaseTextCellDelegate

- (void)cell:(BaseTextCell *)cellView didTapUserButton:(PFUser *)aUser {
    [self shouldPresentAccountViewForUser:aUser];
}


#pragma mark - PAPPhotoDetailsHeaderViewDelegate

-(void)photoDetailsHeaderView:(PhotoDetailsHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    [self shouldPresentAccountViewForUser:user];
}

- (void)actionButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.tag = MainActionSheetTag;
    actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", nil)];
    if (NSClassFromString(@"UIActivityViewController")) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share Photo", nil)];
        
        
        
        
    }
    
    
    
    
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void)activityButtonAction:(id)sender {
    
    
    if (NSClassFromString(@"UIActivityViewController")) {
        // TODO: Need to do something when the photo hasn't finished downloading!
        if ([[self.photo objectForKey:kPAPPhotoPictureKey] isDataAvailable]) {
            [self showShareSheet];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[self.photo objectForKey:kPAPPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [self showShareSheet];
                }
            }];
        }
    }
}


#pragma mark - ()

- (void)showShareSheet {
    [[self.photo objectForKey:kPAPPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
            
            // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
            if ([[[PFUser currentUser] objectId] isEqualToString:[[self.photo objectForKey:kPAPPhotoUserKey] objectId]] && [self.objects count] > 0) {
                PFObject *firstActivity = self.objects[0];
                if ([[[firstActivity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kPAPPhotoUserKey] objectId]]) {
                    NSString *commentString = [firstActivity objectForKey:kPAPActivityContentKey];
                    [activityItems addObject:commentString];
                }
            }
            
            [activityItems addObject:[UIImage imageWithData:data]];
            [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://Instago.ru/#pic/%@", self.photo.objectId]]];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        }
    }];
}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    AccountViewController *accountViewController = [[AccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userLikedOrUnlikedPhoto:(NSNotification *)note {
    [self.headerView reloadLikeBar];
}

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (void)loadLikers {
    if (self.likersQueryInProgress) {
        return;
    }
    
    self.likersQueryInProgress = YES;
    PFQuery *query = [Utility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error) {
            [self.headerView reloadLikeBar];
            return;
        }
        
        NSMutableArray *likers = [NSMutableArray array];
        NSMutableArray *commenters = [NSMutableArray array];
        
        BOOL isLikedByCurrentUser = NO;
        
        for (PFObject *activity in objects) {
            if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
            } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
            }
            
            if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
        
        [[Cache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
        [self.headerView reloadLikeBar];
    }];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
    //[MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
}

- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kPAPPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)shouldDeletePhoto {
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [query whereKey:kPAPActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // Delete photo
        [self.photo deleteEventually];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - The Magic!

-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    //  [self.tabBarController setTabBarHidden:YES
    //                            animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    // [self.tabBarController setTabBarHidden:NO
    //                   animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self expand];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self contract];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self contract];
    return YES;
}


-(void) isParseReachable{
    
}
@end
