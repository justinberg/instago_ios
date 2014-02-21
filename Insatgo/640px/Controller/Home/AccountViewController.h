//
//  AccountViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "PhotoTimelineViewController.h"

@interface AccountViewController : PhotoTimelineViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    
    UIImage *photopr;
    UIImage *profimage;
}

@property (nonatomic, strong) PFUser *user;
@property (nonatomic,retain) UIImage *photopr;
@property (nonatomic,retain) UIImage *profimage;
- (BOOL)shouldPresentPhotoCaptureController;

@end
