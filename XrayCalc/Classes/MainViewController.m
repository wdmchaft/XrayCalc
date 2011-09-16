//
//  MainViewController.m
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MainViewController.h"
#import "UICandySlider.h"

@implementation MainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICandySlider *densitySlider = [[UICandySlider alloc] initWithFrame:CGRectMake(20, 20, 300, 50) 
                                                          balloonSuffix:@"%" 
                                                          andMultiplier:100];
    [self.view addSubview:densitySlider];
}

- (void)dealloc {
    
}

@end
