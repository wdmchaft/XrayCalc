//
//  MainViewController.h
//  XrayCalc
//
//  Created by Tim Robb on 20110916.
//  Copyright (c) 2011 Invader Tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICandySlider.h"

@interface MainViewController : UIViewController {
    UICandySlider  *densitySlider;
    UICandySlider  *thicknessSlider;
}
@property (nonatomic,retain) UICandySlider  *densitySlider;
@property (nonatomic,retain) UICandySlider  *thicknessSlider;

@end
