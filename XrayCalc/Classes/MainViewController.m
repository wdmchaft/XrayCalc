//
//  MainViewController.m
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#pragma mark - Animation/UI
// TODO: Tutorial/helper overlay or image sequence on load and in information screen
// TODO: Add labels to everything
// TODO: Add different thickness measurements (inches, meters, yards, kilometres etc)
// TODO: Link up Settings
// TODO: Deblurrify things

#pragma mark - Logic

#import "MainViewController.h"
#import "InformationViewController.h"
#import "MachineListControlView.h"

#pragma mark - Implementation

@implementation MainViewController

@synthesize outputLabel;
@synthesize outputMeasurementLabel;

@synthesize coreTimer;

@synthesize gridPicker;
@synthesize platePicker;

@synthesize densitySlider;
@synthesize thicknessSlider;

@synthesize leftDial;
@synthesize rightDial;

- (void)dealloc {   
    [outputLabel release];
    [outputMeasurementLabel release];
	
	[coreTimer release];
	
	[gridPicker release];
	[platePicker release];
    
    [densitySlider release];
    [thicknessSlider release];
	
	[leftDial release];
	[rightDial release];
}

static float count = 0.0f;
static float target = 0.0f;
static float increment = 0.0f;

- (void)coreUpdate {
	float newTarget = [[Setting getCurrentSetting:[CURRENT_MACHINE.outputType intValue]].value floatValue];
	if (count > 0.0f || newTarget != target) {
		target = newTarget;
		if (target < count) {
			increment = (count-target)/5;
		} else if (target > count) {
			increment = (target-count)/5;
		} else {
			increment = 0.0f;
		}
	}
	
	if (!self.coreTimer || (self.coreTimer && !self.coreTimer.isValid)) {
		target = newTarget;
		count = self.outputLabel.text.floatValue;
		if (target < count) {
			increment = (count-target)/5;
		} else if (target > count) {
			increment = (target-count)/5;
		} else {
			increment = 0.0f;
		}
		if (increment != 0.0f) {
			NSLog(@"START-----\n");
			self.coreTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f
															  target:self
															selector:@selector(updateOutput:)
															userInfo:nil
															 repeats:YES];
		}
	}
}

- (void)updateOutput:(NSTimer*)timer {
	BOOL down = NO;
		
	if (target < count) {
		down = YES;
		count -= increment;
	} else if (target > count) {
		count += increment;
	}
	
	NSString *countString = [NSString stringWithFormat:@"%.3f",count];
	NSString *targetString = [NSString stringWithFormat:@"%.3f",target];
	
	NSLog(@"%.2f/%.2f",count,target);
	NSString *newText = [NSString stringWithFormat:@"%.2f",count];
	
	UIFont   *outputFont = [UIFont systemFontOfSize:48.0f];
	CGSize   newOutputSize = [newText sizeWithFont:outputFont];
	CGSize   outputSize = [self.outputLabel.text sizeWithFont:outputFont];
	self.outputLabel.text = newText;
	self.outputMeasurementLabel.text = [CURRENT_MACHINE getOutputTypeString];
	
	if (newOutputSize.width != outputSize.width) {
		[self updateOutputSize:newOutputSize];
	}
	
    if ((!down && [countString floatValue] >= [targetString floatValue]) || (down && [countString floatValue] <= [targetString floatValue])) {
		NSLog(@"-----STOP\n");
        [timer invalidate];
		count = 0.0f;
		increment = 0.0f;
		target = 0.0f;
    }
}

- (void)updateOutputSize:(CGSize)newSize {
	self.outputLabel.frame = CGRectMake(0, 0, newSize.width, newSize.height);
	
	UIFont   *outputFont2 = [UIFont systemFontOfSize:24.0f];
	CGSize   outputSize2 = [self.outputMeasurementLabel.text sizeWithFont:outputFont2];
	self.outputMeasurementLabel.frame = CGRectMake(newSize.width+2, 51-outputSize2.height, outputSize2.width, outputSize2.height);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Core getInstance].delegate = self;
	
	
	
	
	/******************
	 *                *
	 *   Background   *
	 *                *
	 ******************/
    
    self.view.backgroundColor = BACKGROUND_COLOUR;
    
    UIImageView *outputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OutputBackground.png"]];
    outputBackground.frame = CGRectMake(0, 284, 320, 132);
    [self.view addSubview:outputBackground];
    [outputBackground release];
        
    UIImageView *backgroundTexture = [[UIImageView alloc] initWithImage:[Core getInstance].currentTexture];
    backgroundTexture.alpha = 0.03;
    [self.view addSubview:backgroundTexture];
    [backgroundTexture release];
	
	
	
	
	/******************
	 *                *
	 *   Navigation   *
	 *                *
	 ******************/
    
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
	
	
	
	
	/******************
	 *                *
	 *    Pickers     *
	 *                *
	 ******************/
	
	CGRect plateFrame = CGRectMake(20, 35, 125.5, 81.5);
	self.platePicker = [[UIHorizontalPicker alloc] initWithFrame:plateFrame andType:kHorizontalPickerTypePlate];
	[self.view addSubview:self.platePicker];
	
	CGRect gridFrame = CGRectMake(plateFrame.origin.x+plateFrame.size.width+30,
								  plateFrame.origin.y, plateFrame.size.width, plateFrame.size.height);
	self.gridPicker = [[UIHorizontalPicker alloc] initWithFrame:gridFrame andType:kHorizontalPickerTypeGrid];
	[self.view addSubview:self.gridPicker];
	
	
	
	
	
	/******************
	 *                *
	 *    Sliders     *
	 *                *
	 ******************/
    
    CGRect posFrame = CGRectMake(40, 95, 240, 50);
    self.densitySlider = [[UICandySlider alloc] initWithFrame:posFrame
                                                         type:kCandySliderTypeDensity];
    self.densitySlider.value = [CURRENT_MACHINE.densityInitial floatValue];
    self.densitySlider.shouldAnimateDescriptions = YES;
    [self.view addSubview:self.densitySlider];
    
    
    CGRect posFrame2 = CGRectMake(posFrame.origin.x, posFrame.origin.y+posFrame.size.height+16, posFrame.size.width, posFrame.size.height);
    self.thicknessSlider = [[UICandySlider alloc] initWithFrame:posFrame2
                                                           type:kCandySliderTypeThickness];
    self.thicknessSlider.minimumValue = [CURRENT_MACHINE.thicknessMin intValue];
    self.thicknessSlider.maximumValue = [CURRENT_MACHINE.thicknessMax intValue];
    self.thicknessSlider.value = [CURRENT_MACHINE.thicknessInitial intValue];
    [self.view addSubview:self.thicknessSlider];
	
	
	
	
	/******************
	 *                *
	 *     Dials      *
	 *                *
	 ******************/
    
    CGRect leftDialFrame = CGRectMake(posFrame2.origin.x-20, posFrame2.origin.y+posFrame2.size.height+16, 0, 0);
    self.leftDial = [[UIRadialSlider alloc] initWithFrame:leftDialFrame 
                                                     type:[CURRENT_MACHINE.leftSetting intValue]];
    [self.view addSubview:self.leftDial];
    
    CGRect rightDialFrame = CGRectMake(posFrame2.origin.x+posFrame2.size.width-96.5f+20, leftDialFrame.origin.y, 0, 0);
    self.rightDial = [[UIRadialSlider alloc] initWithFrame:rightDialFrame 
                                                     type:[CURRENT_MACHINE.rightSetting intValue]];
    [self.view addSubview:self.rightDial];
	
	
	
	
	/******************
	 *                *
	 *     Output     *
	 *                *
	 ******************/
    
    UIView *outputView = [[UIView alloc] initWithFrame:CGRectMake(0, 345, 320, 60)];
    
        NSString *outputText = [NSString stringWithFormat:@"%0.2f",[CURRENT_SETTING_S.value floatValue]];
        UIFont   *outputFont = [UIFont systemFontOfSize:48.0f];
        CGSize   outputSize = [outputText sizeWithFont:outputFont];
        self.outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, outputSize.width, outputSize.height)];
        [self.outputLabel setTextColor:[UIColor colorWithRed:32.0f/255 green:176.0f/255 blue:216.0f/255 alpha:1]];
        [self.outputLabel setShadowColor:[UIColor colorWithWhite:0.09 alpha:0.4]];
        [self.outputLabel setShadowOffset:CGSizeMake(1, 2)];
        [self.outputLabel setTextAlignment:UITextAlignmentCenter];
        [self.outputLabel setBackgroundColor:[UIColor clearColor]];
        [self.outputLabel setFont:outputFont];
        self.outputLabel.text = outputText;
		self.outputLabel.adjustsFontSizeToFitWidth = YES;
        [self.outputLabel sizeToFit];
        [outputView addSubview:self.outputLabel];
        
        NSString *outputText2 = [CURRENT_MACHINE getOutputTypeString];
        UIFont   *outputFont2 = [UIFont systemFontOfSize:24.0f];
        CGSize   outputSize2 = [outputText2 sizeWithFont:outputFont2];
        CGRect   mFrame = CGRectMake(outputSize.width+2, 51-outputSize2.height, outputSize2.width, outputSize2.height);
        self.outputMeasurementLabel = [[UILabel alloc] initWithFrame:mFrame];
        [self.outputMeasurementLabel setTextColor:self.outputLabel.textColor];
        [self.outputMeasurementLabel setShadowColor:self.outputLabel.shadowColor];
        [self.outputMeasurementLabel setShadowOffset:self.outputLabel.shadowOffset];
        [self.outputMeasurementLabel setBackgroundColor:self.outputLabel.backgroundColor];
        [self.outputMeasurementLabel setFont:outputFont2];
        self.outputMeasurementLabel.text = outputText2;
        [self.outputMeasurementLabel sizeToFit];
        [outputView addSubview:self.outputMeasurementLabel];
    
    CGRect oldFrame = outputView.frame;
    oldFrame.size.width = self.outputMeasurementLabel.frame.origin.x+self.outputMeasurementLabel.frame.size.width+1;
    oldFrame.origin.x = APP_DELEGATE.window.center.x-(oldFrame.size.width/2);
    outputView.frame = oldFrame;
    
    [self.view addSubview:outputView];
    [outputView release];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"XrayCalc";
}

- (void)viewWillDisappear:(BOOL)animated {
    self.title = @"Home";
}

#pragma mark - Navigation

- (void)infoPush:(UIButton*)sender {
    InformationViewController *infoViewController = [[InformationViewController alloc] init];
    [self.navigationController pushViewController:infoViewController animated:YES];
    [infoViewController release];
}

- (void)settingsPush:(UIButton*)sender {
    MachineListControlView *machineListControlView = [[MachineListControlView alloc] init];
    [self.navigationController pushViewController:machineListControlView animated:YES];
    [machineListControlView release];
}

@end
