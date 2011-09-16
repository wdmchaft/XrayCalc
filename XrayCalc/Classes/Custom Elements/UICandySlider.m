//
//  UICandySlider.m
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

// 120,120,120

#import "UICandySlider.h"

@implementation UICandySlider

@synthesize slider;
@synthesize output;

@synthesize delegate;

@synthesize suffix;
@synthesize multipler;

-(UICandySlider*)initWithFrame:(CGRect)frame balloonSuffix:(NSString*)newSuffix andMultiplier:(int)newMultipler {
    self.suffix = newSuffix;
    self.multipler = newMultipler;
    
    self.slider = [[UISlider alloc] initWithFrame:frame];
    self.slider.minimumValueImage = [UIImage imageNamed:@"CandyPattern.png"];
    self.slider.maximumValueImage = [UIImage imageNamed:@"CandySliderGradient.png"];
    [self.slider setThumbImage:[UIImage imageNamed:@"CandySliderThumb"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
    
    self.output = [[UILabel alloc] initWithFrame:CGRectMake(7.0f, 14.0f, 60.0f, 13.0f)];
    self.output.textColor = [UIColor colorWithRed:120.0f/255.0f green:120.0f/255.0f blue:120.0f/255.0f alpha:1];
    self.output.textAlignment = UITextAlignmentCenter;
    self.output.tag = 1;
    self.output.text = [NSString stringWithFormat:@"%d%@",self.slider.value*multipler,suffix];
    
    [self.slider addSubview:self.output];
    
    return self;
}

-(void)changed:(id)sender {
    if(self.delegate) {
        [self.delegate sliderChanged:self];
    } else {
        self.output.text = [NSString stringWithFormat:@"%d%@",self.slider.value*multipler,suffix];
    }
}

-(void)dealloc {
    [slider release];
    [output release];
    [delegate release];
    [suffix release];
    
    [super dealloc];
}

@end
