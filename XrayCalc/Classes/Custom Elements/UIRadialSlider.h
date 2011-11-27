//
//  UIRadialSlider.h
//  XrayCalc
//
//  Created by Tim Robb on 20110922.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRadialSlider : UISlider {
    UILabel *outputLabel;
    UIView *centerPoint;
    
    kSettingType settingType;
}

@property (nonatomic,retain) UILabel *outputLabel;
@property (nonatomic,retain) UIView *centerPoint;
@property (nonatomic,assign) kSettingType settingType;

-(UIRadialSlider*)initWithFrame:(CGRect)frame type:(kSettingType)type;
-(void)changed:(float)value;

@end
