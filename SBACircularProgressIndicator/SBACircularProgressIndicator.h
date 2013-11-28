//
//  SBACircularProgressIndicator.h
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A circular progress indicator for iOS.

 */

@interface SBACircularProgressIndicator : UIView

/**
 Specifies the width of the stroke for the circle. Defaults to 1.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 A float between 0 (0%) and 1 (100%) indicating the progress that should be
 shown. Changing this property will cause the indicator to animate to the new
 position. To set the progress without animation, use setProgress:animated:
 instead, setting animated to NO.

 @see setProgress:animated:
 */
@property (nonatomic, assign) CGFloat progress;

/**
 Set the progress to be shown, with optional animation.

 @param progress A float between 0 (0%) and 1 (100%).
 @param animated Indicates whether the change should be animated.
 @see progress
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
