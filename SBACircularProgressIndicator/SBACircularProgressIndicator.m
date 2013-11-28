//
//  SBACircularProgressIndicator.m
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import "SBACircularProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>


@interface SBACircularProgressIndicator ()

@property (nonatomic, strong) UIBezierPath *circlePath;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign, readonly) CGFloat maxLineWidth;
@property (nonatomic, assign) CGFloat diameter;

@property (nonatomic, assign) CGRect outerCircleRect;
@property (nonatomic, assign) CGRect innerCircleRect;

@end


@implementation SBACircularProgressIndicator

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
	_lineWidth = 1.0f;
	_diameter = self.frame.size.width;
	_maxLineWidth = _diameter / 2;
	
	_outerCircleRect = CGRectMake(0, 0, _diameter, _diameter);
	_circlePath = [UIBezierPath bezierPathWithOvalInRect:_outerCircleRect];
	_circleLayer = [CAShapeLayer layer];
	_circleLayer.path = _circlePath.CGPath;
	_circleLayer.strokeColor = self.tintColor.CGColor;
	_circleLayer.fillColor = [UIColor clearColor].CGColor;
	[self.layer addSublayer:_circleLayer];
	_circleLayer.bounds = self.layer.bounds;
	_circleLayer.position = (CGPoint){
		self.bounds.size.width / 2,
		self.bounds.size.height / 2
	};
			
	_innerCircleRect = CGRectMake(1, 1, _diameter - 2, _diameter - 2);
	_progressPath = [UIBezierPath bezierPathWithOvalInRect:_innerCircleRect];

	[self updateProgressLayer];
	[self adjustLineWidth:_lineWidth];
}

#pragma mark - Overrides

- (void)tintColorDidChange
{
	self.circleLayer.strokeColor = self.tintColor.CGColor;
	self.progressLayer.strokeColor = self.tintColor.CGColor;
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

- (void)setProgress:(CGFloat)progress
{
	[self setProgress:progress animated:YES];
}

- (void)setProgress:(CGFloat)newProgress animated:(BOOL)animated
{
	NSParameterAssert(newProgress >= 0 && newProgress <= 1);
		
	self.progressLayer.hidden = NO;
	
	if (_progress == 0 && newProgress > 0) {
		self.progressLayer.lineWidth = _lineWidth + 2;
	} else if (_progress > 0 && newProgress == 0) {
		self.progressLayer.lineWidth = _lineWidth;
	}
	
	_progress = newProgress;
	
	if (!animated) {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
	}
	
	self.progressLayer.strokeEnd = _progress;

	if (!animated) {
		[CATransaction commit];
	}
}

#pragma mark - Utility

- (void)updateProgressLayer
{
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
}

- (void)adjustLineWidth:(CGFloat)newWidth
{
	_lineWidth = newWidth;
	self.circlePath.lineWidth = _lineWidth;
	self.circleLayer.path = self.circlePath.CGPath;
	self.circleLayer.lineWidth = self.circlePath.lineWidth;
	self.progressLayer.lineWidth = _lineWidth;
}

@end
