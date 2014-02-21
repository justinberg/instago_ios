//
//  SettingsActionSheetDelegate.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsActionSheetDelegate : NSObject <UIActionSheetDelegate>

// Navigation controller of calling view controller
@property (nonatomic, strong) UINavigationController *navController;

- (id)initWithNavigationController:(UINavigationController *)navigationController;

@end
