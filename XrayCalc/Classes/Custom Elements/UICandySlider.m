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
@synthesize descriptionLeft;
@synthesize descriptionRight;

@synthesize minTrackView;
@synthesize maxTrackView;

@synthesize suffix;
@synthesize multipler;

@synthesize sliderType;

@synthesize shouldAnimateDescriptions;

-(UICandySlider*)initWithFrame:(CGRect)frame type:(NSInteger)type {
    self.sliderType = type;
    if(self.sliderType == kCandySliderTypeDensity) {
        self.suffix = @"%";
        self.multipler = 100;
    } else {
        self.suffix = @"cm";
        self.multipler = 1;
    }
    
    self.shouldAnimateDescriptions = NO;
    
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
    self.maxTrackView.layer.cornerRadius = 2.5f;
    self.maxTrackView.layer.masksToBounds = YES;
    [self addSubview:self.maxTrackView];
    [self.maxTrackView release];
    
    self.minTrackView = [[UIImageView alloc] initWithFrame:[self trackRectForBounds:self.bounds]];
    [self.minTrackView setBackgroundColor:[UIColor colorWithPatternImage:maxTrack]];
    f = self.minTrackView.frame;
    self.minTrackView.tag = 1;
    self.minTrackView.frame = CGRectMake(f.origin.x, f.origin.y+1, f.size.width, f.size.height-2);
    self.minTrackView.layer.cornerRadius = 2.5f;
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
    
    if(self.sliderType == kCandySliderTypeDensity) {
        self.descriptionLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 50, 14)];
        self.descriptionLeft.font = [UIFont systemFontOfSize:12.0f];
        self.descriptionLeft.textColor = [UIColor whiteColor];
        self.descriptionLeft.backgroundColor = [UIColor clearColor];
        self.descriptionLeft.text = @"Bone";
        [self addSubview:self.descriptionLeft];
        [self sendSubviewToBack:self.descriptionLeft];
        [self.descriptionLeft release];
        
        self.descriptionRight = [[UILabel alloc] initWithFrame:CGRectMake(0+self.frame.size.width-30, 6, 50, 16)];
        self.descriptionRight.font = [UIFont systemFontOfSize:12.0f];
        self.descriptionRight.textColor = [UIColor whiteColor];
        self.descriptionRight.backgroundColor = [UIColor clearColor];
        self.descriptionRight.text = @"Lung";
        [self addSubview:self.descriptionRight];
        [self sendSubviewToBack:self.descriptionRight];
        [self.descriptionRight release];
    }
        
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
    
    if(self.sliderType == kCandySliderTypeDensity && self.shouldAnimateDescriptions) {
        BOOL leftUp = NO;
        BOOL leftNeedAnimation = NO;
        BOOL rightUp = NO;
        BOOL rightNeedAnimation = NO;
        
        if(newX < self.descriptionLeft.frame.size.width+5) {
            leftUp = YES;
            leftNeedAnimation = (self.descriptionLeft.frame.origin.y >= 6);
        } else {
            leftUp = NO;
            leftNeedAnimation = (self.descriptionLeft.frame.origin.y < 6);
        }
        if(newX > self.frame.size.width-self.descriptionRight.frame.size.width-5) {
            rightUp = YES;
            rightNeedAnimation = (self.descriptionRight.frame.origin.y >= 6);
        } else {
            rightUp = NO;
            rightNeedAnimation = (self.descriptionRight.frame.origin.y < 6);
        }
        
        if(leftNeedAnimation) {
            CGRect leftFrame = self.descriptionLeft.frame;
            if (leftUp) {
                [UIView beginAnimations:@"LeftDescriptionUp" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.25f];
                self.descriptionLeft.frame = CGRectMake(leftFrame.origin.x, -15, leftFrame.size.width, leftFrame.size.height);
                [UIView commitAnimations];
            } else {
                [UIView beginAnimations:@"LeftDescriptionDown" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.25f];
                self.descriptionLeft.frame = CGRectMake(leftFrame.origin.x, 6, leftFrame.size.width, leftFrame.size.height);
                [UIView commitAnimations];
            }
        }
        if(rightNeedAnimation) {
            CGRect rightFrame = self.descriptionRight.frame;
            if (rightUp) {
                [UIView beginAnimations:@"RightDescriptionUp" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.25f];
                self.descriptionRight.frame = CGRectMake(rightFrame.origin.x, -15, rightFrame.size.width, rightFrame.size.height);
                [UIView commitAnimations];
            } else {
                [UIView beginAnimations:@"RightDescriptionDown" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.25f];
                self.descriptionRight.frame = CGRectMake(rightFrame.origin.x, 6, rightFrame.size.width, rightFrame.size.height);
                [UIView commitAnimations];
            }
        }
        
        CGRect leftFrame = self.descriptionLeft.frame;
        if(newX < leftFrame.size.width/3) {
            self.descriptionLeft.frame = CGRectMake(newX-(leftFrame.size.width/3), leftFrame.origin.y, leftFrame.size.width, leftFrame.size.height);
        } else {
            self.descriptionLeft.frame = CGRectMake(0, leftFrame.origin.y, 50, 14);
        }
        
        CGRect rightFrame = self.descriptionRight.frame;
        if(newX > self.frame.size.width-30+(rightFrame.size.width/3)) {
            self.descriptionRight.frame = CGRectMake(newX-(rightFrame.size.width/3), rightFrame.origin.y, rightFrame.size.width, rightFrame.size.height);
        } else {
            self.descriptionRight.frame = CGRectMake(0+self.frame.size.width-30, rightFrame.origin.y, 50, 16);
        }
    }
    
    return CGRectMake(newX-(62.0f/6), bounds.size.height-(38.0f), 62.0f/3, 88.0f/3);
}

-(void)dealloc {
    [output release];
    [suffix release];
    
    [super dealloc];
}

@end
