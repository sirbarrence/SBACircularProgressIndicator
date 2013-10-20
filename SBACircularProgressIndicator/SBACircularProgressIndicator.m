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
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIBezierPath *arcPath;
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@property (nonatomic, strong) UIView *arcView;

@property (nonatomic, strong) UIBezierPath *progressPath;

@property (nonatomic, assign) CGFloat maxLineWidth;
@property (nonatomic, assign) CGFloat arcWidth;

@end


@implementation SBACircularProgressIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//		self.backgroundColor = [UIColor redColor];
		self.layer.opacity = 0.75;
		_lineWidth = 1.0f;
		CGFloat diameter = frame.size.width;
		_maxLineWidth = diameter / 2;

		CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
		_circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
		_circleLayer = [CAShapeLayer layer];
		_circleLayer.path = _circlePath.CGPath;
		_circleLayer.strokeColor = self.tintColor.CGColor;
		_circleLayer.fillColor = [UIColor clearColor].CGColor;
//		_circleLayer.backgroundColor = [UIColor orangeColor].CGColor;
		_circleView = [[UIView alloc] initWithFrame:self.bounds];
//		_circleView.backgroundColor = [UIColor greenColor];
		_circleView.layer.opacity = 0.75f;
		[_circleView.layer addSublayer:_circleLayer];
		_circleLayer.bounds = _circleView.layer.bounds;
		_circleLayer.position = CGPointMake(_circleView.bounds.size.width / 2, _circleView.bounds.size.height / 2);
		[self addSubview:_circleView];
		
		_arcPath =
		[UIBezierPath
		 bezierPathWithArcCenter:(CGPoint){CGRectGetMidX(circleRect), CGRectGetMidY(circleRect)}
		 radius:diameter / 2
		 startAngle:DEGREES_TO_RADIANS(45)
		 endAngle:DEGREES_TO_RADIANS(135)
		 clockwise:YES];
		_arcLayer = [CAShapeLayer layer];
		_arcLayer.path = _arcPath.CGPath;
		_arcLayer.strokeColor = self.tintColor.CGColor;
		_arcLayer.fillColor = [UIColor clearColor].CGColor;
//		_arcLayer.backgroundColor = [UIColor redColor].CGColor;
		_arcLayer.lineCap = kCALineCapSquare;
		_arcView = [[UIView alloc] initWithFrame:self.bounds];
		[_arcView.layer addSublayer:_arcLayer];
		_arcLayer.bounds = _arcView.layer.bounds;
		_arcLayer.position = CGPointMake(_arcView.bounds.size.width / 2, _arcView.bounds.size.height / 2);
		[self addSubview:_arcView];
		
		[self adjustLineWidth:1.0f];
    }
    return self;
}

- (void)tintColorDidChange
{
	self.circleLayer.strokeColor = self.tintColor.CGColor;
	self.arcLayer.strokeColor = self.tintColor.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)adjustLineWidth:(CGFloat)newWidth
{
	_lineWidth = newWidth;
	self.circlePath.lineWidth = _lineWidth;
	self.circleLayer.path = self.circlePath.CGPath;
	self.circleLayer.lineWidth = self.circlePath.lineWidth;
	self.arcPath.lineWidth = _lineWidth + 2;
	self.arcLayer.lineWidth = self.arcPath.lineWidth;
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
	if ([_arcLayer animationForKey:@"transform"]) {
		// already animating
		return;
	}
	
	CATransform3D origTransform = _arcLayer.transform;
	CATransform3D halfTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(180), 0, 0, 1);
	CATransform3D rotTransform = CATransform3DRotate(origTransform, DEGREES_TO_RADIANS(360), 0, 0, 1);
	
	// Change model value first so the arc won't snap back to the starting transform
	// when the animation completes.
	_arcLayer.transform = rotTransform;
	
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
	[_arcLayer addAnimation:anim forKey:@"transform"];
}

- (void)stopIndeterminateAnimation
{
	[_arcLayer removeAnimationForKey:@"transform"];
}

@end
