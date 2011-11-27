//
//  Plate.m
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "Plate.h"

@implementation Plate

@dynamic name;
@dynamic speed;
@dynamic machine;
@dynamic isBase;

static Plate *currentPlate;

+ (Plate *)getCurrentPlate {
	return currentPlate;
}

+ (void)setCurrentPlate:(Plate *)plate {
	if (plate != currentPlate) {
    	[currentPlate release];
    	currentPlate = [plate retain];
    }
}

+ (void)createPlate:(NSString*)name speed:(double)speed assign:(BOOL)assign base:(BOOL)base {
	Plate *plate = (Plate *)[NSEntityDescription insertNewObjectForEntityForName:@"Plate" inManagedObjectContext:[Core getInstance].managedObjectContext];
	plate.name = name;
    plate.speed = [NSNumber numberWithInteger:speed];
    plate.isBase = [NSNumber numberWithBool:base];
    if(assign) {
        //plate.machine = CURRENT_MACHINE;
        [CURRENT_MACHINE addPlate:plate];
    }
	
	[self setCurrentPlate:plate];
}

@end
