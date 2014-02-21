//
//  FindFriendsCell.m
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "FindFriendsCell.h"
#import "ProfileImageView.h"

@interface FindFriendsCell ()
/*! The cell's views. These shouldn't be modified but need to be exposed for the subclass */
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) ProfileImageView *avatarImageView;

@end


@implementation FindFriendsCell
@synthesize delegate;
@synthesize user;
@synthesize avatarImageView;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize photoLabel;
@synthesize followButton;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        self.avatarImageView = [[ProfileImageView alloc] init];
        [self.avatarImageView setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        
        
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageButton setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarImageButton];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setBackgroundColor:[UIColor clearColor]];
        [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.nameButton setTitleColor:[UIColor colorWithRed:92.0/255.0 green:163.0/255.0 blue:225.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        // [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.nameButton];
        
        self.photoLabel = [[UILabel alloc] init];
        [self.photoLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.photoLabel setTextColor:[UIColor colorWithRed:39.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1]];
        [self.photoLabel setBackgroundColor:[UIColor clearColor]];
        //  [self.photoLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.700f]];
        // [self.photoLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.contentView addSubview:self.photoLabel];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.followButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self.followButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 10.0f, 0.0f, 0.0f)];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"buttonFollow.png"] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"buttonFollowing.png"] forState:UIControlStateSelected];
        [self.followButton setImage:[UIImage imageNamed:@"iconTick.png"] forState:UIControlStateSelected];
        [self.followButton setTitle:NSLocalizedString(@"Follow",nil) forState:UIControlStateNormal]; // space added for centering
        [self.followButton setTitle:NSLocalizedString(@"Following",nil) forState:UIControlStateSelected];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //  [self.followButton setTitleShadowColor:[UIColor colorWithRed:232.0f/255.0f green:203.0f/255.0f blue:168.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        //  [self.followButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.followButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
        [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.followButton];
    }
    return self;
}


#pragma mark - PAPFindFriendsCell

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Configure the cell
    [avatarImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
    
    // Set name
    NSString *nameString = [self.user objectForKey:kPAPUserDisplayNameKey];
    CGSize nameSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] forWidth:144.0f lineBreakMode:NSLineBreakByTruncatingTail];
    [nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateNormal];
    [nameButton setTitle:[self.user objectForKey:kPAPUserDisplayNameKey] forState:UIControlStateHighlighted];
    
    [nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.width, nameSize.height)];
    
    // Set photo number label
    CGSize photoLabelSize = [NSLocalizedString(@"photos",nil) sizeWithFont:[UIFont systemFontOfSize:11.0f] forWidth:144.0f lineBreakMode:NSLineBreakByTruncatingTail];
    [photoLabel setFrame:CGRectMake( 60.0f, 17.0f + nameSize.height, 140.0f, photoLabelSize.height)];
    
    // Set follow button
    [followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
}

#pragma mark - ()

+ (CGFloat)heightForCell {
    return 67.0f;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}

@end
