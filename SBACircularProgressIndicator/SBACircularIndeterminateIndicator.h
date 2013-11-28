//
//  SBACircularIndeterminateIndicator.h
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 11/28/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBACircularIndeterminateIndicator : UIView

/** A circular indeterminate indicator for iOS.
 
 */

/**
 Determines the start angle in degrees of the arc before it starts animating.
 */
@property (nonatomic, assign) CGFloat arcStartAngle;

/**
 For indeterminate indicators, this determines the length of the arc in degrees.
 */
@property (nonatomic, assign) CGFloat arcLength;

/**
 Specifies the width of the stroke for the circle. Defaults to 1.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Starts the animation.
 */
- (void)startAnimation;

/**
 Stops the animation.
 */
- (void)stopAnimation;


@end
