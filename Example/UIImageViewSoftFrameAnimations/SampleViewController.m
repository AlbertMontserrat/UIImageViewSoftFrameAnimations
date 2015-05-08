//
//  UIViewController.m
//  UIImageViewSoftFrameAnimations
//
//  Created by Albert M on 05/08/2015.
//  Copyright (c) 2014 Albert M. All rights reserved.
//

#import "SampleViewController.h"
#import <UIImageViewSoftFrameAnimations/UIImageView+SoftFrameAnimations.h>

@interface UIViewController ()

@end

@implementation SampleViewController


-(IBAction)playIdle:(id)sender{
    [bird setIdleAnimation:@"bird_" numberOfDigits:2 firstDigit:1 andExtension:@"jpg" startNow:YES andFPS:0.09];
}

-(IBAction)pauseIdle:(id)sender{
    [bird pauseSoftFrameAnimation];
}

-(IBAction)playmouth:(id)sender{
    [mouth softFrameAnimateWithImageName:@"bouche_" numberOfDigits:2 firstDigit:1 andExtension:@"jpg" loop:NO loopCount:0 andFPS:0.09];
}

-(IBAction)playmouth3times:(id)sender{
    [mouth softFrameAnimateWithImageName:@"bouche_" numberOfDigits:2 firstDigit:1 andExtension:@"jpg" loop:YES loopCount:3 andFPS:0.09];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

@end
