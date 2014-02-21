//
//  EditPhotoViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "AFPhotoEditorController.h"
#import "InfiniteScrollPicker.h"
@interface EditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate,AFPhotoEditorControllerDelegate> {
    
    UIImageView *fotoView;
    UIImage *editImage;
    UIImage *editImagePub;
    NSString *tapImage;
    UILabel *emot;
    NSString *feelRecord;
    NSString *colorEmotion;
    
    
    
    
    
}


@property (nonatomic,retain) UIImageView *fotoView;
@property (nonatomic,retain) UIImage *editImage;
@property (nonatomic,retain) UIImage *editImagePub;
@property (nonatomic,retain) NSData *videoData;
@property (nonatomic,retain)  NSString *tapImage;
@property (nonatomic,retain)  UILabel *emot;
@property (nonatomic,retain) NSString *feelRecord;
@property (nonatomic,retain) NSString *colorEmotion;





- (id)initWithImage:(UIImage *)aImage;




@end

