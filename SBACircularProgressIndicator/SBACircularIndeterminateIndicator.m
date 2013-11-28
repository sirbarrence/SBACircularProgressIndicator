//
//  SBACircularIndeterminateIndicator.m
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 11/28/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import "SBACircularIndeterminateIndicator.h"

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)


@interface SBACircularIndeterminateIndicator ()

@property (nonatomic, strong) UIBezierPath *indeterminateArcPath;
@property (nonatomic, strong) CAShapeLayer *indeterminateArcLayer;

@property (nonatomic, assign, readonly) CGFloat maxLineWidth;
@property (nonatomic, assign) CGFloat diameter;

@property (nonatomic, assign) CGRect outerCircleRect;
@property (nonatomic, assign) CGRect innerCircleRect;

@end


@implementation SBACircularIndeterminateIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
	_diameter = self.frame.size.width;
	_maxLineWidth = _diameter / 2;
	_arcStartAngle = 45.0f;
	_arcLength = 135.0f;
	_outerCircleRect = CGRectMake(0, 0, _diameter, _diameter);

	[self updateIndeterminateLayer];
	[self setLineWidth:1.0f];
	self.indeterminateArcLayer.hidden = YES;
}

#pragma mark - Overrides

- (void)tintColorDidChange
{
	self.indeterminateArcLayer.strokeColor = self.tintColor.CGColor;
}

#pragma mark - Public

- (void)setArcStartAngle:(CGFloat)arcStartAngle
{
	if (_arcStartAngle != arcStartAngle) {
		_arcStartAngle = arcStartAngle;
		[self updateIndeterminateLayer];
	}
}

- (void)setArcLength:(CGFloat)arcLength
{
	if (_arcLength != arcLength) {
		_arcLength = arcLength;
		[self updateIndeterminateLayer];
	}
}

- (void)startAnimation
{
	if ([self.indeterminateArcLayer animationForKey:@"transform"]) {
		// already animating
		return;
	}
	
	self.indeterminateArcLayer.hidden = NO;
	
	CATransform3D origTransform = self.indeterminateArcLayer.transform;
	CATransform3D halfTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(180), 0, 0, 1);
	CATransform3D rotTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(360), 0, 0, 1);
	
	// Change model value first so the arc won't snap back to the starting transform
	// when the animation completes.
	self.indeterminateArcLayer.transform = rotTransform;
	
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	anim.rotationMode = kCAAnimationRotateAuto;
	NSValue *startVal = [NSValue valueWithCATransform3D:origTransform];
	// using a middle value to force the desired roation direction.
	NSValue *midVal = [NSValue valueWithCATransform3D:halfTransform];
	NSValue *endVal = [NSValue valueWithCATransform3D:rotTransform];
	anim.values = @[ startVal, midVal, endVal ];
	anim.duration = 2.0f;
	anim.repeatCount = HUGE_VALF;
	// Using same key as the animation's property key prevents the initial transform
	// property change's implicit animation from happening.
	[self.indeterminateArcLayer addAnimation:anim forKey:@"transform"];
}

- (void)stopAnimation
{
	[self.indeterminateArcLayer removeAnimationForKey:@"transform"];
	self.indeterminateArcLayer.hidden = YES;
}

#pragma mark - Utility

- (void)updateIndeterminateLayer
{
	_indeterminateArcPath =
	[UIBezierPath
	 bezierPathWithArcCenter:(CGPoint){CGRectGetMidX(_outerCircleRect), CGRectGetMidY(_outerCircleRect)}
	 radius:_diameter / 2 - 1
	 startAngle:DEGREES_TO_RADIANS(_arcStartAngle)
	 endAngle:DEGREES_TO_RADIANS((_arcStartAngle + _arcLength))
	 clockwise:YES];
	if (_indeterminateArcLayer == nil) {
		_indeterminateArcLayer = [CAShapeLayer layer];
		[self.layer addSublayer:_indeterminateArcLayer];
	}
	_indeterminateArcLayer.path = _indeterminateArcPath.CGPath;
	_indeterminateArcLayer.strokeColor = self.tintColor.CGColor;
	_indeterminateArcLayer.fillColor = [UIColor clearColor].CGColor;
	_indeterminateArcLayer.lineCap = kCALineCapSquare;
	_indeterminateArcLayer.bounds = self.layer.bounds;
	_indeterminateArcLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setLineWidth:(CGFloat)lineWidth
{
	if (_lineWidth != lineWidth) {
		_lineWidth = lineWidth;
		self.indeterminateArcPath.lineWidth = _lineWidth;
		self.indeterminateArcLayer.lineWidth = _lineWidth;
	}
}

@end
