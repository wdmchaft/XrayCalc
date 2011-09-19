//
//  main.m
//  XrayCalc
//
//  Created by Tim Robb on 20110915.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

/*
XrayCalc is designed to calculate exposure factors for an Atomscope 903A diagnostic xray machine. Calculations are based on 2 different sized screens, with the smaller screens 1.4 the speed of the larger ones. The grid used has an energy absorbtion factor of 6:1. Xrays are processed in an automatic processor. While these factors seem to work very nicely in our system, every system produces different results. Use the caluclations as guide only and use at your own risk. Radiography requires licensing in most countries: it is your duty to comply with relevant local regulations.
*/