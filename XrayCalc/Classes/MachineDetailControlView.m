//
//  MachineDetailControlView.m
//  XrayCalc
//
//  Created by Tim Robb on 20110925.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MachineDetailControlView.h"

@implementation MachineDetailControlView
@synthesize machineToEdit;

-(void)dealloc {
    [super dealloc];
    [machineToEdit release];
}

-(void)viewDidLoad {
    self.title = self.machineToEdit.name;
}

@end
