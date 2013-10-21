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

- (void)startIndeterminateAnimation;
- (void)stopIndeterminateAnimation;

@end
