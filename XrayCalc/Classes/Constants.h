//
//  Constants.h
//  XrayCalc
//
//  Created by Tim Robb on 20110917.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define Recalculate [Core update:[Core calculateSettingFromMachine:CURRENT_MACHINE type:[CURRENT_MACHINE.outputType intValue]]]

#define TEXTURE_RETINA [UIImage imageNamed:@"noise_retina.png"]
#define TEXTURE_NORMAL [UIImage imageNamed:@"noise.png"]

#define BGC 35.0f
#define BACKGROUND_COLOUR [UIColor colorWithRed:BGC/255 green:BGC/255 blue:BGC/255 alpha:1]

#define DEFAULT_PLATE_SIZE_LARGE 800
#define DEFAULT_PLATE_SIZE_SMALL 200
#define DEFAULT_GRID_SPEED 6

#define FUDGE (0.002 * 0.3 *(8/7))