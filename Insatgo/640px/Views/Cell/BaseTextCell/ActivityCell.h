//
//  ActivityCell.h
//  Instago
//
//  Created by CODERLAB on 17.12.13.
//  Copyright (c) 2013 studio76. All rights reserved.
//

#import "BaseTextCell.h"
@protocol ActivityCellDelegate;

@interface ActivityCell : BaseTextCell

/*!Setter for the activity associated with this cell */
@property (nonatomic, strong) PFObject *activity;

/*!Set the new state. This changes the background of the cell. */
- (void)setIsNew:(BOOL)isNew;

@end


/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol ActivityCellDelegate <BaseTextCellDelegate>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(ActivityCell *)cellView didTapActivityButton:(PFObject *)activity;

@end
