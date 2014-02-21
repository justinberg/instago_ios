//
//  ActivityFeedViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "ActivityCell.h"

@interface ActivityFeedViewController : PFQueryTableViewController <ActivityCellDelegate>

+ (NSString *)stringForActivityType:(NSString *)activityType;

@end
