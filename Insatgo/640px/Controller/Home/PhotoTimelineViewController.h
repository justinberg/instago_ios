//
//  PhotoTimelineViewController.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "PhotoHeaderView.h"

@interface PhotoTimelineViewController : PFQueryTableViewController <PhotoHeaderViewDelegate>

- (PhotoHeaderView *)dequeueReusableSectionHeaderView;

@end
