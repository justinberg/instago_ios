//
//  LogInViewController.m
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "LogInViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface LogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation LogInViewController
@synthesize fieldsBackground;


#pragma mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back-login-s.png"]];
    
    
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoz.png"]]];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit1.png"] forState:UIControlStateNormal];
    self.logInView.autoresizesSubviews = YES;
    
    [self.logInView.facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"Facebook" forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    
    [self.logInView.twitterButton setTitle:@"Twitter" forState:UIControlStateNormal];
    [self.logInView.twitterButton setTitle:@"Twitter" forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign up" forState:UIControlStateHighlighted];
    
    
    self.fields = PFLogInFieldsUsernameAndPassword;
    self.logInView.usernameField.placeholder = @"Enter your username";
    self.logInView.usernameField.textColor = [UIColor blackColor];
    self.logInView.passwordField.textColor = [UIColor blackColor];
    
    // Add login field background
    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
   
    
    
    
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(0.0f, 0.0f, 1.5f, 1.5f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
   
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}






// NSString *photoUrl = [info objectForKey:@"photo_big"];


/*
 NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
 _userImage.image = [UIImage imageWithData:photoData];
 
 _userName.text = [info objectForKey:@"first_name"];
 _userSurName.text = [info objectForKey:@"last_name"];
 _userBDate.text = [info objectForKey:@"bdate"];
 _userGender.text = [NSString stringWithGenderId:[[info objectForKey:@"sex"] intValue]];
 
 */


-(void)dissm{
    
    [self.logInView.dismissButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}




@end
