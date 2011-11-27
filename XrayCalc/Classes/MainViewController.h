//
//  MainViewController.h
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 Invader Tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICandySlider.h"
#import "UIRadialSlider.h"

@interface MainViewController : UIViewController <CoreUpdates> {
    UILabel         *outputLabel;
    UILabel         *outputMeasurementLabel;
    
    UICandySlider   *densitySlider;
    UICandySlider   *thicknessSlider;
    
    UIRadialSlider  *leftDial;
    UIRadialSlider  *rightDial;
}
@property (nonatomic,retain) UILabel        *outputLabel;
@property (nonatomic,retain) UILabel        *outputMeasurementLabel;    

@property (nonatomic,retain) UICandySlider  *densitySlider;
@property (nonatomic,retain) UICandySlider  *thicknessSlider;

@property (nonatomic,retain) UIRadialSlider  *leftDial;
@property (nonatomic,retain) UIRadialSlider  *rightDial;

@end
