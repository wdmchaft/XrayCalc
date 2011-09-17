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
    IBOutlet UIWindow       *window;
    
    IBOutlet UIImageView    *topBar;
    
    UICandySlider  *densitySlider;
    UICandySlider  *thicknessSlider;
}
@property (nonatomic,retain) UIWindow       *window;

@property (nonatomic,retain) UIImageView    *topBar;

@property (nonatomic,retain) UICandySlider  *densitySlider;
@property (nonatomic,retain) UICandySlider  *thicknessSlider;

@end
