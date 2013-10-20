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

@property (nonatomic, strong) SBACircularProgressIndicator *ind;
@property (weak, nonatomic) IBOutlet UITextField *widthText;

@end

@implementation SBAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.ind = [[SBACircularProgressIndicator alloc] initWithFrame:CGRectMake(50, 50, 20, 20)];
	[self.view addSubview:self.ind];
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

@end
