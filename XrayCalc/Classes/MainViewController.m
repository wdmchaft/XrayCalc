//
//  MainViewController.m
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MainViewController.h"

#define ANIMATION_DURATION 1.0f
#define DENSITY_DEFAULT 0.5f
#define THICKNESS_DEFAULT 10.0f

@implementation MainViewController

@synthesize window;

@synthesize topBar;

@synthesize densitySlider;
@synthesize thicknessSlider;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOUR;
    self.topBar.image = [Core getScaledImage:[UIImage imageNamed:@"NavigationGradient.png"]];
    
    UIImageView *backgroundTexture = [[UIImageView alloc] initWithImage:[Core getInstance].currentTexture];
    backgroundTexture.alpha = 0.03;
    [self.view addSubview:backgroundTexture];
    [backgroundTexture release];
    
    CGRect posFrame = CGRectMake(40, 140, 240, 50);
    self.densitySlider = [[UICandySlider alloc] initWithFrame:posFrame
                                                          balloonSuffix:@"%" 
                                                          andMultiplier:100];
    
    [self.view addSubview:self.densitySlider];
    
    [NSTimer scheduledTimerWithTimeInterval:0.025f
                                     target:self
                                   selector:@selector(updateDensity:)
                                   userInfo:nil
                                    repeats:YES];
    
    
    CGRect posFrame2 = CGRectMake(posFrame.origin.x, posFrame.origin.y+posFrame.size.height+16, posFrame.size.width, posFrame.size.height);
    self.thicknessSlider = [[UICandySlider alloc] initWithFrame:posFrame2
                                                  balloonSuffix:@"cm"
                                                  andMultiplier:1];
    self.thicknessSlider.minimumValue = 0;
    self.thicknessSlider.maximumValue = 40;
    [self.view addSubview:self.thicknessSlider];
    
    [NSTimer scheduledTimerWithTimeInterval:0.025f
                                     target:self
                                   selector:@selector(updateThickness:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateDensity:(NSTimer*)timer {
    static float count = 0.0f;
    if (count >= DENSITY_DEFAULT)
        [timer invalidate];
    else
        [self.densitySlider setValue:count += 0.025f];
}

- (void)updateThickness:(NSTimer*)timer {
    static float count = 0.0f;
    if (count >= THICKNESS_DEFAULT)
        [timer invalidate];
    else
        [self.thicknessSlider setValue:count += 0.5f];
}

- (void)dealloc {
    [window release];
    
    [topBar release];
    
    [densitySlider release];
    [thicknessSlider release];
}

@end
