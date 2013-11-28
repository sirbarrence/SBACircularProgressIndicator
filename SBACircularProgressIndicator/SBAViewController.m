//
//  SBAViewController.m
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import "SBAViewController.h"
#import "SBACircularProgressIndicator.h"
#import "SBACircularIndeterminateIndicator.h"

@interface SBAViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SBACircularProgressIndicator *progressIndicator;
@property (weak, nonatomic) IBOutlet SBACircularIndeterminateIndicator *indeterminateIndicator;
@property (weak, nonatomic) IBOutlet UITextField *percentText;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;
@property (weak, nonatomic) IBOutlet UISlider *arcLengthSlider;

@end

@implementation SBAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.progressIndicator.progress = 0.5f;
	self.percentText.text = @"50";
	self.stepper.value = 50;
	self.slider.value = 50;
	self.arcLengthSlider.value = self.indeterminateIndicator.arcLength;
}

- (IBAction)arcLengthSliderChanged:(UISlider*)sender
{
	self.indeterminateIndicator.arcLength = sender.value;
}

- (IBAction)stepperChanged:(id)sender
{
	self.percentText.text =
	[NSString stringWithFormat:@"%d",
	 [[NSNumber numberWithDouble:self.stepper.value] intValue]];
	self.slider.value = self.stepper.value;
	
	[self.progressIndicator
	 setProgress:self.stepper.value / 100
	 animated:self.animatedSwitch.on];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	self.stepper.value = [self.percentText.text doubleValue];
	self.slider.value = [self.percentText.text floatValue];

	[self.progressIndicator
	 setProgress:[self.percentText.text floatValue] / 100
	 animated:self.animatedSwitch.on];
	
	return YES;
}

- (IBAction)sliderValueChanged:(id)sender
{
	self.percentText.text =
	[NSString stringWithFormat:@"%d",
	 [[NSNumber numberWithFloat:self.slider.value] intValue]];
	self.stepper.value = self.slider.value;

	[self.progressIndicator
	 setProgress:self.slider.value / 100
	 animated:self.animatedSwitch.on];
}

- (IBAction)doStart:(id)sender
{
	[self.indeterminateIndicator startAnimation];
	// or
//	self.indeterminateIndicator.indeterminate = YES;
}

- (IBAction)doStop:(id)sender
{
	[self.indeterminateIndicator stopAnimation];
	// or
//	self.indeterminateIndicator.indeterminate = NO;
}


@end
