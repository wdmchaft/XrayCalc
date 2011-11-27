//
//  UIRadialSlider.m
//  XrayCalc
//
//  Created by Tim Robb on 20110922.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

// I love you <3

#import "UIRadialSlider.h"
#import "Entities.h"

@implementation UIRadialSlider

#define thumbImage [Core getScaledImage:[UIImage imageNamed:@"DialThumb.png"]]
#define thumbOffset 0.2f // Determines how off the "0" mark the slider will start and finish at.

@synthesize outputLabel;
@synthesize centerPoint;
@synthesize settingType;

-(void)dealloc {
    [outputLabel release];
    [centerPoint release];
    
    [super dealloc];
}

-(float)valueOfNearestSettingWithOrder:(float)value {
    return [[Core findClosestOrder:value inSettingArray:[CURRENT_MACHINE getSettingsArrayOfType:self.settingType]].value floatValue];
}

-(UIRadialSlider*)initWithFrame:(CGRect)frame type:(kSettingType)type {
    self.backgroundColor = [UIColor clearColor];
    
    [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 96.5f, 96.5f)];
    self.bounds = self.frame;
    
    UIImage *base = [UIImage imageNamed:@"DialBase.png"];
    
    [self setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self setThumbImage:thumbImage             forState:UIControlStateNormal];
    
    UIImageView *baseView = [[UIImageView alloc] initWithFrame:self.frame];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.image = base;
    baseView.tag = 2;
    [self addSubview:baseView];
    [baseView release];
    
    self.centerPoint = [[UIView alloc] initWithFrame:CGRectMake(self.center.x, self.center.y, 0, 0)];
    [self addSubview:self.centerPoint];
    
    NSString *outputText = [NSString stringWithFormat:@"%.2f",[self valueOfNearestSettingWithOrder:self.value]];
    UIFont *outputFont = [UIFont systemFontOfSize:17.0f];
    CGSize outputSize = [outputText sizeWithFont:outputFont];
    CGRect outputRect = CGRectMake(self.center.x-(outputSize.width/2), (self.center.y-(outputSize.height/2))-5, outputSize.width, outputSize.height);
    self.outputLabel = [[UILabel alloc] initWithFrame:outputRect];
    self.outputLabel.font = outputFont;
    self.outputLabel.backgroundColor = [UIColor clearColor];
    self.outputLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1];
    self.outputLabel.textAlignment = UITextAlignmentCenter;
    self.outputLabel.text = outputText;
    
    [self addSubview:self.outputLabel];
    
    [self setSettingType:type];
    
    self.value = 0;
    self.maximumValue = [[CURRENT_MACHINE getSettingsArrayOfType:type] count]-1;
    
    [self touchesEnded:nil withEvent:nil];
    
    return self;
}

- (void)setSettingType:(kSettingType)type {
    settingType = type;
    
    NSString *settingText = [Setting getDisplayStringForType:type];
    UIFont *settingFont = [UIFont systemFontOfSize:14.0f];
    CGSize settingSize = [settingText sizeWithFont:settingFont];
    
    UILabel *measurementLabel = (UILabel*)[self viewWithTag:1];
    
    if(measurementLabel == nil) {
        CGRect settingFrame = CGRectMake(self.center.x-(settingSize.width/2), self.outputLabel.frame.origin.y+self.outputLabel.frame.size.height+1, settingSize.width, settingSize.height);
        measurementLabel = [[UILabel alloc] initWithFrame:settingFrame];
        measurementLabel.font = settingFont;
        measurementLabel.textColor = self.outputLabel.textColor;
        measurementLabel.backgroundColor = [UIColor clearColor];
        measurementLabel.tag = 1;
        
        [self addSubview:measurementLabel];
    }
    
    measurementLabel.text = settingText;
}

-(void)changed:(float)value {
    value = fabsf(value);
    self.outputLabel.text = [NSString stringWithFormat:@"%.2f",[self valueOfNearestSettingWithOrder:value]];
    [Setting setCurrentSetting:[Core findClosestOrder:value inSettingArray:[CURRENT_MACHINE getSettingsArrayOfType:self.settingType]]];
    Recalculate;
}

-(float)roundValueToSegments:(float)value {
    int count = [[CURRENT_MACHINE getSettingsArrayOfType:self.settingType] count]-1;
    float segment = roundf(value*count);
    
    return segment;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.centerPoint];
    float x = touchLocation.x;
    float y = touchLocation.y;
    float radians = (x == 0) ? self.value*2*M_PI : atan2f(-y,-x)+M_PI-(M_PI/2);
    
    if(radians/(2*M_PI) < 0) {
        radians += 2*M_PI;
    }
    
    [self changed:[self roundValueToSegments:self.value]];
    NSLog(@"%.2f",radians/(2*M_PI));
    self.value = radians/(2*M_PI);
    [self setThumbImage:[Core rotateImage:thumbImage by:radians degrees:NO] forState:UIControlStateNormal];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touchesBegan:touches withEvent:event];
    int count = [[CURRENT_MACHINE getSettingsArrayOfType:self.settingType] count]-1;
    
    CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self.centerPoint];
    float x = touchLocation.x;
    float y = touchLocation.y;
    float radians = (x == 0) ? self.value*2*M_PI : atan2f(-y,-x)+M_PI-(M_PI/2);
    
    if(radians/(2*M_PI) < 0) {
        radians += 2*M_PI;
    }
    
    int segment = [self roundValueToSegments:self.value];
    float segmentPosition = (self.value*count)-segment+0.5f;
     
    if(segment == 0 && segmentPosition < thumbOffset) {
        radians = segment+thumbOffset;
    } else if(segment == count && segmentPosition > (1-thumbOffset)) {
        radians = segment+(1-thumbOffset);
    }
    
    NSLog(@"S: %d; P: %.2f; R: %.2f",segment,segmentPosition,radians);
     
    [self changed:[self roundValueToSegments:self.value]];
    [self setThumbImage:[Core rotateImage:thumbImage by:radians degrees:NO] forState:UIControlStateNormal];
     
    self.value = radians/(2*M_PI);
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    int count = [[CURRENT_MACHINE getSettingsArrayOfType:self.settingType] count]-1;
    float segment = [self roundValueToSegments:self.value];
    
    if(segment == 0) {
        segment += thumbOffset;
    } else if(segment == count) {
        segment -= thumbOffset;
    }
    self.value = segment/count;
    [self changed:[self roundValueToSegments:self.value]];
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    float radius = (bounds.size.height/2)-3;
    float radians = (value*2*M_PI)+(M_PI/2);
    bounds.origin.x += radius * cosf(radians);
    bounds.origin.y += radius * sinf(radians);
    return bounds;
}
/*if (love == courtzie){
    [GET_ENGAGED ];
    
}*/
@end
