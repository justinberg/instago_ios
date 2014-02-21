//
//  EditPhotoViewController.m
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "PhotoDetailsFooterView.h"
#import "UIImage+ResizeAdditions.h"
#import "iOSCombobox.h"
#import "Settings.h"

@interface EditPhotoViewController ()
{
    InfiniteScrollPicker *isp;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation EditPhotoViewController
@synthesize scrollView;
@synthesize image;
@synthesize commentTextField;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;

@synthesize fotoView;
@synthesize editImage;
@synthesize editImagePub;
@synthesize tapImage;
@synthesize emot;
@synthesize feelRecord;
@synthesize colorEmotion;





- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        self.image = aImage;
        self.editImagePub = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory warning on Edit");
}


///AVIARLY SECTIONS

- (void)displayEditorForImage:(UIImage *)imageToEdit

{
    
    NSArray * toolOrder = @[kAFEnhance, kAFEffects, kAFAdjustments, kAFFocus,  kAFStickers,  kAFOrientation, kAFCrop,  kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme , kAFFrames];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    
    [AFPhotoEditorCustomization setSupportedIpadOrientations:@[@(UIInterfaceOrientationLandscapeRight),
                                                               @(UIInterfaceOrientationLandscapeLeft) ]];
    
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:editImagePub];
    
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)imagez
{
    
    
    [fotoView setImage:imagez];
    editImagePub = imagez;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIViewController

- (void)loadView {
    //self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 320.0f, 320.0f, 500.0f)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.view = self.scrollView;
    
    // UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    // [photoImageView setBackgroundColor:[UIColor blackColor]];
    //[photoImageView setImage:self.image];
    //[photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    fotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    [fotoView setBackgroundColor:[UIColor blackColor]];
    [fotoView setImage:self.editImagePub];
    [fotoView setContentMode:UIViewContentModeScaleAspectFit];
    
    // CALayer *layer = photoImageView.layer;
    CALayer *layer = fotoView.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    // [self.scrollView addSubview:photoImageView];
    [self.scrollView addSubview:fotoView];
    
    //photoImageView = photoImageView1;
    
    //INfinity view
    NSMutableArray *set1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        [set1 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png", i]]];
    }
    
    isp = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 250, 320, 70)];
    [isp setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9]];
    [isp setItemSize:CGSizeMake(25, 25)];
    [isp setImageAry:set1];
    [self.scrollView addSubview:isp];
    /////
    
    emot = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 160, 50)];
    [emot setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:226.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [emot setText:tapImage];
    [emot setTextAlignment:NSTextAlignmentCenter];
    [emot setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:225.0f/255.0f alpha:1.0f]];
    
    [self.scrollView addSubview:emot];
    
    
    //BUTTON SECTION
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(160, 320, 160, 50)];
    [btn setBackgroundColor:[UIColor colorWithRed:118.0f/255.0f green:202.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    [btn setTitle:NSLocalizedString( @"Colorize photo",nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(displayEditorForImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    
    CGRect footerRect = [PhotoDetailsFooterView rectForView];
    //footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height+40;
    footerRect.origin.y = fotoView.frame.origin.y + fotoView.frame.size.height +40;
    
    PhotoDetailsFooterView *footerView = [[PhotoDetailsFooterView alloc] initWithFrame:footerRect];
    self.commentTextField = footerView.commentField;
    self.commentTextField.delegate = self;
    [self.scrollView addSubview:footerView];
    
    //  [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, photoImageView.frame.origin.y + photoImageView.frame.size.height + footerView.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, fotoView.frame.origin.y + fotoView.frame.size.height + footerView.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoNavigationBar.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Publish",nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // [self shouldUploadImage:self.image];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonAction:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField resignFirstResponder];
}


#pragma mark - ()

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    UIImage *resizedImage = [editImagePub resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640.0f, 640.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [editImagePub thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %d for Anypic photo upload", self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    [self.scrollView setContentSize:scrollViewContentSize];
    
    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    // Align the bottom edge of the photo with the keyboard
    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.0f - [UIScreen mainScreen].bounds.size.height+40.0f;
    
    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
}

- (void)doneButtonAction:(id)sender {
    
    NSLog(@"WAT TEXT - %@",self.commentTextField.text);
    
    if (commentTextField.text.length < 1){
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Field Add a comment - are required!!!",ni) message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString( @"Dismiss",nil), nil];
        [alert show];
        return;
        
    }
    
    
    
    [self shouldUploadImage:image];
    NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    trimmedComment,kPAPEditPhotoViewControllerUserInfoCommentKey,
                    nil];
    }
    
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
    NSString *tagAlert = @"nospam";
    
    
    PFObject *photo = [PFObject objectWithClassName:kPAPPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
    [photo setObject:self.photoFile forKey:kPAPPhotoPictureKey];
    [photo setObject:self.thumbnailFile forKey:kPAPPhotoThumbnailKey];
    [photo setObject:tagAlert forKey:@"alert"];
    [photo setObject:feelRecord forKey:@"feel"];
    
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    [photoACL setWriteAccess:YES forUserId:AdministratorAccount];
    
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // save
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded");
            
            [[Cache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            // userInfo might contain any caption which might have been posted by the uploader
            if (userInfo) {
                NSString *commentText = [userInfo objectForKey:kPAPEditPhotoViewControllerUserInfoCommentKey];
                
                if (commentText && commentText.length != 0) {
                    // create and save photo caption
                    PFObject *comment = [PFObject objectWithClassName:kPAPActivityClassKey];
                    [comment setObject:kPAPActivityTypeComment forKey:kPAPActivityTypeKey];
                    [comment setObject:photo forKey:kPAPActivityPhotoKey];
                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
                    [comment setObject:[PFUser currentUser] forKey:kPAPActivityToUserKey];
                    [comment setObject:commentText forKey:kPAPActivityContentKey];
                    
                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [ACL setPublicReadAccess:YES];
                    comment.ACL = ACL;
                    
                    [comment saveEventually];
                    [[Cache sharedCache] incrementCommentCountForPhoto:photo];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            NSLog(@"Photo failed to save: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)cancelButtonAction:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)setCategoryz{
    
    
    
}






-(void) infiniteScrollPicker:(InfiniteScrollPicker *)infiniteScrollPicker didSelectAtImage:(UIImage*)buttonIndex
{
    
    
    if (buttonIndex == [UIImage imageNamed:@"icon_0.png"]) {
        
        
        tapImage = @"I Feel Happy";
        
        
        
        feelRecord = @"icon_0.png";
        
        
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_1.png"]) {
        
        
        tapImage = @"I Feel Angry";
        
        /*  [UILabel animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^
         {
         isp.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:61.0f/255.0f blue:65.0f/255.0f alpha:0.4f];
         } completion: NULL];*/
        
        feelRecord = @"icon_1.png";
        
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_2.png"]) {
        
        
        tapImage = @"I Feel Disgust";
        
        
        feelRecord = @"icon_2.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_3.png"]) {
        
        
        tapImage = @"I Feel Love";
        
        
        
        feelRecord = @"icon_3.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_4.png"]) {
        
        
        tapImage = @"I Feel Sad";
        
        
        
        feelRecord = @"icon_4.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_5.png"]) {
        
        
        tapImage = @"I Feel Annoy";
        
        
        feelRecord = @"icon_5.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_6.png"]) {
        
        
        tapImage = @"I Feel Surprise";
        
        
        
        feelRecord = @"icon_6.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_7.png"]) {
        
        
        tapImage = @"I Feel Scare";
        
        
        
        feelRecord = @"icon_7.png";
    }
    if (buttonIndex == [UIImage imageNamed:@"icon_8.png"]) {
        
        
        tapImage = @"I Feel Calm";
        
        
        
        feelRecord = @"icon_8.png";
    }
    
    
    [emot setText:tapImage];
}




- (void)viewWillDisappear:(BOOL)animated{
	//[emoLable setNeedsDisplay];
    
}



@end