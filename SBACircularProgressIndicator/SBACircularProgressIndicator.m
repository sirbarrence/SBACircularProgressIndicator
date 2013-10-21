//
//  SBACircularProgressIndicator.m
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import "SBACircularProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@interface SBACircularProgressIndicator ()


@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIBezierPath *indeterminateArcPath;
@property (nonatomic, strong) CAShapeLayer *indeterminateArcLayer;

@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign) CGFloat maxLineWidth;
@property (nonatomic, assign) CGFloat diameter;

@end


@implementation SBACircularProgressIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.opacity = 0.75;
		_lineWidth = 1.0f;
		_diameter = frame.size.width;
		_maxLineWidth = _diameter / 2;

		CGRect circleRect = CGRectMake(0, 0, _diameter, _diameter);
		_circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
		_circleLayer = [CAShapeLayer layer];
		_circleLayer.path = _circlePath.CGPath;
		_circleLayer.strokeColor = self.tintColor.CGColor;
		_circleLayer.fillColor = [UIColor clearColor].CGColor;
		[self.layer addSublayer:_circleLayer];
		_circleLayer.bounds = self.layer.bounds;
		_circleLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		
		_indeterminateArcPath =
		[UIBezierPath
		 bezierPathWithArcCenter:(CGPoint){CGRectGetMidX(circleRect), CGRectGetMidY(circleRect)}
		 radius:_diameter / 2 - 1
		 startAngle:DEGREES_TO_RADIANS(45)
		 endAngle:DEGREES_TO_RADIANS(135)
		 clockwise:YES];
		_indeterminateArcLayer = [CAShapeLayer layer];
		_indeterminateArcLayer.path = _indeterminateArcPath.CGPath;
		_indeterminateArcLayer.strokeColor = self.tintColor.CGColor;
		_indeterminateArcLayer.fillColor = [UIColor clearColor].CGColor;
		_indeterminateArcLayer.lineCap = kCALineCapSquare;
		[self.layer addSublayer:_indeterminateArcLayer];
		_indeterminateArcLayer.bounds = self.layer.bounds;
		_indeterminateArcLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		
		circleRect = CGRectMake(1, 1, _diameter - 2, _diameter - 2);
		_progressPath = [UIBezierPath bezierPathWithOvalInRect:circleRect];

		_progressLayer = [CAShapeLayer layer];
		_progressLayer.path = _progressPath.CGPath;
		_progressLayer.strokeColor = self.tintColor.CGColor;
		_progressLayer.fillColor = [UIColor clearColor].CGColor;
		_progressLayer.lineCap = kCALineCapSquare;
		_progressLayer.strokeStart = 0;
		_progressLayer.strokeEnd = 0;
		[self.layer addSublayer:_progressLayer];
		_progressLayer.bounds = self.layer.bounds;
		_progressLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		
		[self adjustLineWidth:1.0f];
    }
    return self;
}

- (void)tintColorDidChange
{
	self.circleLayer.strokeColor = self.tintColor.CGColor;
	self.indeterminateArcLayer.strokeColor = self.tintColor.CGColor;
	self.progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)adjustLineWidth:(CGFloat)newWidth
{
	_lineWidth = newWidth;
	self.circlePath.lineWidth = _lineWidth;
	self.circleLayer.path = self.circlePath.CGPath;
	self.circleLayer.lineWidth = self.circlePath.lineWidth;
	self.indeterminateArcPath.lineWidth = _lineWidth + 2;
	self.indeterminateArcLayer.lineWidth = self.indeterminateArcPath.lineWidth;
	self.progressLayer.lineWidth = _lineWidth + 2;
}

#pragma mark - Public

- (void)setLineWidth:(CGFloat)lineWidth
{
	if (lineWidth == _lineWidth) {
		return;
	}
	NSParameterAssert(lineWidth <= _maxLineWidth);
	[self adjustLineWidth:lineWidth];
	[self setNeedsDisplay];
}

- (void)applyIdent
{
	[self startIndeterminateAnimation];
}

- (void)startIndeterminateAnimation
{
	if ([_indeterminateArcLayer animationForKey:@"transform"]) {
		// already animating
		return;
	}
	
	self.indeterminateArcLayer.hidden = NO;
	self.progressLayer.hidden = YES;
	
	CATransform3D origTransform = _indeterminateArcLayer.transform;
	CATransform3D halfTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(180), 0, 0, 1);
	CATransform3D rotTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(360), 0, 0, 1);
	
	// Change model value first so the arc won't snap back to the starting transform
	// when the animation completes.
	_indeterminateArcLayer.transform = rotTransform;
	
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
	[_indeterminateArcLayer addAnimation:anim forKey:@"transform"];
}

- (void)stopIndeterminateAnimation
{
	[self.indeterminateArcLayer removeAnimationForKey:@"transform"];
	self.indeterminateArcLayer.hidden = YES;
}

- (void)setProgress:(CGFloat)progress
{
	NSParameterAssert(progress >= 0 && progress <= 1);

	[self stopIndeterminateAnimation];
	if (progress == _progress) {
		return;
	}
	
	_progress = progress;
	self.progressLayer.hidden = NO;
	self.progressLayer.strokeEnd = _progress;
}

@end
