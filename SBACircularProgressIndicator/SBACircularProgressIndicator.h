//
//  SBACircularProgressIndicator.h
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBACircularProgressIndicator : UIView

/**
 Specifies the width of the stroke for the circle. Defaults to 1.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  A float between 0 (0%) and 1 (100%) indicating the progress that should be 
 *  shown. Changing this property will cause the indicator to animate to the new 
 *  position.
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  Indicates whether this indicator is / should be indeterminate. Setting this to
 *  YES starts the indeterminate animation; setting it to NO stops the animation 
 *  and sets the progress to 0.
 */
@property (nonatomic, assign) BOOL indeterminate;

- (void)startIndeterminateAnimation;
- (void)stopIndeterminateAnimation;

/**
 *  Set the progress to be shown, with optional animation.
 *
 *  @param progress A float between 0 (0%) and 1 (100%).
 *  @param animated Indicates whether the change should be animated.
 *  @see `progress`
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
