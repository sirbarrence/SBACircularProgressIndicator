//
//  SBAViewController.m
//  SBACircularProgressIndicator
//
//  Created by Barry Simpson on 10/14/13.
//  Copyright (c) 2013 Barry Simpson. All rights reserved.
//

#import "SBAViewController.h"
#import "SBACircularProgressIndicator.h"

@interface SBAViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) SBACircularProgressIndicator *ind;
@property (weak, nonatomic) IBOutlet UITextField *widthText;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation SBAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.ind = [[SBACircularProgressIndicator alloc] initWithFrame:CGRectMake(50, 50, 20, 20)];
	[self.view addSubview:self.ind];
}

- (IBAction)stepperChanged:(id)sender
{
	[self.ind setProgress:self.stepper.value / 100];
	self.widthText.text = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.stepper.value] intValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doThing:(id)sender
{
	[self.ind startIndeterminateAnimation];
}

- (IBAction)doOtherThing:(id)sender
{
	[self.ind stopIndeterminateAnimation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.ind setProgress:[self.widthText.text floatValue] / 100];
	return YES;
}



@end
