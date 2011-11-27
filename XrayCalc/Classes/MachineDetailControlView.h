//
//  MachineDetailControlView.h
//  XrayCalc
//
//  Created by Tim Robb on 20110925.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineDetailControlView : UIViewController {
    Machine *machineToEdit;
}
@property (nonatomic,retain) Machine *machineToEdit;

@end
