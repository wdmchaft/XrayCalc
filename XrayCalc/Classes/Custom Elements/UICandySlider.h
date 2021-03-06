//
//  UICandySlider.h
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _kCandySliderType {
    kCandySliderTypeCustom = 0,
    kCandySliderTypeDensity = 1,
    kCandySliderTypeThickness = 2
} kCandySliderType;

@class UICandySlider;

@interface UICandySlider : UISlider {
    UILabel *output;
    UILabel *descriptionLeft;
    UILabel *descriptionRight;
    
    UIImageView *minTrackView;
    UIImageView *maxTrackView;
        
    NSString *suffix;
    NSInteger multipler;
    
    kCandySliderType sliderType;
    
    BOOL shouldAnimateDescriptions;
}
@property (nonatomic,retain) UILabel *output;
@property (nonatomic,retain) UILabel *descriptionLeft;
@property (nonatomic,retain) UILabel *descriptionRight;

@property (nonatomic,retain) UIImageView *minTrackView;
@property (nonatomic,retain) UIImageView *maxTrackView;

@property (nonatomic,retain) NSString *suffix;
@property (nonatomic,assign) NSInteger multipler;

@property (nonatomic,assign) kCandySliderType sliderType;

@property (nonatomic,assign) BOOL shouldAnimateDescriptions;

-(UICandySlider*)initWithFrame:(CGRect)frame type:(kCandySliderType)type;
-(void)changed:(float)value;

@end
