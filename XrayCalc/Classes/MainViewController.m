//
//  MainViewController.m
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MainViewController.h"
#import "InformationViewController.h"
#import "MachineListControlView.h"


#define DENSITY_DEFAULT 0.5f
#define THICKNESS_DEFAULT 10.0f

@implementation MainViewController

@synthesize densitySlider;
@synthesize thicknessSlider;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOUR;
        
    UIImageView *backgroundTexture = [[UIImageView alloc] initWithImage:[Core getInstance].currentTexture];
    backgroundTexture.alpha = 0.03;
    [self.view addSubview:backgroundTexture];
    [backgroundTexture release];
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29.5f, 29.5f)];
    [infoButton setImage:[UIImage imageNamed:@"InformationButton.png"] forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"InformationButtonPressed.png"] forState:UIControlEventTouchDown];
    [infoButton addTarget:self action:@selector(infoPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]];
    [infoButton release];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29.5f, 29.5f)];
    [settingsButton setImage:[UIImage imageNamed:@"SettingsButton.png"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"SettingsButtonPressed.png"] forState:UIControlEventTouchDown];
    [settingsButton addTarget:self action:@selector(settingsPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:settingsButton]];
    [settingsButton release];
    
    CGRect posFrame = CGRectMake(40, 100, 240, 50);
    self.densitySlider = [[UICandySlider alloc] initWithFrame:posFrame
                                                         type:kCandySliderTypeDensity];
    
    [self.view addSubview:self.densitySlider];
    
    
    CGRect posFrame2 = CGRectMake(posFrame.origin.x, posFrame.origin.y+posFrame.size.height+16, posFrame.size.width, posFrame.size.height);
    self.thicknessSlider = [[UICandySlider alloc] initWithFrame:posFrame2
                                                           type:kCandySliderTypeThickness];
    self.thicknessSlider.minimumValue = 0;
    self.thicknessSlider.maximumValue = 40;
    [self.view addSubview:self.thicknessSlider];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"XrayCalc";
}

- (void)viewDidAppear:(BOOL)animated {
    if(animated) {
        [NSTimer scheduledTimerWithTimeInterval:0.025f
                                         target:self
                                       selector:@selector(updateDensity:)
                                       userInfo:nil
                                        repeats:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.025f
                                         target:self
                                       selector:@selector(updateThickness:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)updateDensity:(NSTimer*)timer {
    static float count = 0.0f;
    if (count >= DENSITY_DEFAULT) {
        [timer invalidate];
        [self.densitySlider setShouldAnimateDescriptions:YES];
    } else
        [self.densitySlider setValue:count += 0.025f];
}

- (void)updateThickness:(NSTimer*)timer {
    static float count = 0.0f;
    if (count >= THICKNESS_DEFAULT)
        [timer invalidate];
    else
        [self.thicknessSlider setValue:count += 0.5f];
}

- (void)infoPush:(UIButton*)sender {
    self.title = @"Home";
    InformationViewController *infoViewController = [[InformationViewController alloc] init];
    [self.navigationController pushViewController:infoViewController animated:YES];
    [infoViewController release];
}

- (void)settingsPush:(UIButton*)sender {
    self.title = @"Home";
    MachineListControlView *machineListControlView = [[MachineListControlView alloc] init];
    [self.navigationController pushViewController:machineListControlView animated:YES];
    [machineListControlView release];
}

- (void)dealloc {        
    [densitySlider release];
    [thicknessSlider release];
}

@end
