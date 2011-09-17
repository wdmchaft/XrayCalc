//
//  UICandySlider.h
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICandySlider;

@protocol NSCandySliderDelegate <NSObject>
-(void)sliderChanged:(UICandySlider*)slider value:(int)value;
@end

@interface UICandySlider : UISlider {
    UILabel *output;
    UIImageView *minTrackView;
    UIImageView *maxTrackView;
    
    id<NSCandySliderDelegate> delegate;
    
    NSString *suffix;
    NSInteger multipler;
}
@property (nonatomic,retain) UILabel *output;
@property (nonatomic,retain) UIImageView *minTrackView;
@property (nonatomic,retain) UIImageView *maxTrackView;

@property (nonatomic,retain) id<NSCandySliderDelegate> delegate;

@property (nonatomic,retain) NSString *suffix;
@property (nonatomic,assign) NSInteger multipler;

-(UICandySlider*)initWithFrame:(CGRect)frame balloonSuffix:(NSString*)suffix andMultiplier:(int)multipler;
-(void)changed:(float)value;

@end
