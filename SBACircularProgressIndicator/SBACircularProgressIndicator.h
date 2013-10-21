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

- (void)startIndeterminateAnimation;
- (void)stopIndeterminateAnimation;

/**
 *  Set the progess indicator to display a certain percentage.
 *
 *  @param progress A float between 0 (0%) and 1 (100%).
 */
- (void)setProgressTo:(CGFloat)progress;

@end
