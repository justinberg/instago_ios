//
//  PhotoDetailsViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "PhotoDetailsHeaderView.h"
#import "BaseTextCell.h"


@interface PhotoDetailsViewController : PFQueryTableViewController <UITextFieldDelegate, UIActionSheetDelegate, PhotoDetailsHeaderViewDelegate, BaseTextCellDelegate,UIAlertViewDelegate>{
    
    
    
}

@property (nonatomic, strong) PFObject *photo;

- (id)initWithPhoto:(PFObject*)aPhoto;

@end

