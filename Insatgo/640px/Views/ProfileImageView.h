//
//  ProfileImageView.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

@class PFImageView;
@interface ProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;

@end
