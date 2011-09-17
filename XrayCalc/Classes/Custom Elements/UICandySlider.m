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

@synthesize output;
@synthesize minTrackView;
@synthesize maxTrackView;

@synthesize delegate;

@synthesize suffix;
@synthesize multipler;

-(UICandySlider*)initWithFrame:(CGRect)frame balloonSuffix:(NSString*)newSuffix andMultiplier:(int)newMultipler {
    self.suffix = newSuffix;
    self.multipler = newMultipler;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50)];
    
    UIImage *thumb = [Core getScaledImage:[UIImage imageNamed:@"CandySliderThumb.png"]];
    UIImage *minTrack = [Core getScaledImage:[UIImage imageNamed:@"CandyPattern.png"]];
    UIImage *maxTrack = [Core getScaledImage:[UIImage imageNamed:@"CandySliderGradient.png"]];
    
    self.maxTrackView = [[UIImageView alloc] initWithFrame:[self trackRectForBounds:self.bounds]];
    [self.maxTrackView setBackgroundColor:[UIColor colorWithPatternImage:minTrack]];
    CGRect f = self.maxTrackView.frame;
    self.maxTrackView.tag = 2;
    self.maxTrackView.frame = CGRectMake(f.origin.x, f.origin.y+1, f.size.width-2, f.size.height-2);
    self.maxTrackView.layer.cornerRadius = 5;
    self.maxTrackView.layer.masksToBounds = YES;
    [self addSubview:self.maxTrackView];
    [self.maxTrackView release];
    
    self.minTrackView = [[UIImageView alloc] initWithFrame:[self trackRectForBounds:self.bounds]];
    [self.minTrackView setBackgroundColor:[UIColor colorWithPatternImage:maxTrack]];
    f = self.minTrackView.frame;
    self.minTrackView.tag = 1;
    self.minTrackView.frame = CGRectMake(f.origin.x, f.origin.y+1, f.size.width, f.size.height-2);
    self.minTrackView.layer.cornerRadius = 5;
    self.minTrackView.layer.masksToBounds = YES;
    [self addSubview:self.minTrackView];
    [self.minTrackView release];
        
    [self setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self setThumbImage:thumb forState:UIControlStateNormal];
    
    self.output = [[UILabel alloc] initWithFrame:CGRectMake(0, 10.0f, 45.0f, 13.0f)];
    self.output.font = [UIFont systemFontOfSize:14.0f];
    self.output.backgroundColor = [UIColor clearColor];
    self.output.textColor = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1];
    self.output.textAlignment = UITextAlignmentCenter;
    self.output.text = [NSString stringWithFormat:@"%.0f%@",self.value*self.multipler,self.suffix];
    
    [self addSubview:self.output];
        
    return self;
}

-(void)changed:(float)value {
    self.output.text = [NSString stringWithFormat:@"%.0f%@",value*self.multipler,self.suffix];
}

-(void)setValue:(float)value {
    [super setValue:value];
    [self changed:value];
}

-(void)setValue:(float)value animated:(BOOL)animated {
    [super setValue:value animated:animated];
    [self changed:value];
}

-(CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.size.height-22, bounds.size.width, 22);
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    float newX = ((value/self.maximumValue)*bounds.size.width);
    CGRect of = self.output.frame;
    CGRect tf = self.maxTrackView.frame;
    
    self.minTrackView.frame = CGRectMake(0, tf.origin.y, newX, tf.size.height);
    
    [self changed:value];
    
    self.output.frame = CGRectMake(newX-(of.size.width/2), of.origin.y, of.size.width, of.size.height);
    [self bringSubviewToFront:self.output];
    
    return CGRectMake(newX-(62.0f/6), bounds.size.height-(38.0f), 62.0f/3, 88.0f/3);
}

-(void)dealloc {
    [output release];
    [delegate release];
    [suffix release];
    
    [super dealloc];
}

@end
