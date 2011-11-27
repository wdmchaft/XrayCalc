//
//  Grid.m
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "Grid.h"
#import "Machine.h"


@implementation Grid

@dynamic name;
@dynamic ratio;

@dynamic machine;

static Grid *currentGrid;

+ (Grid *)getCurrentGrid {
	return currentGrid;
}

+ (void)setCurrentGrid:(Grid *)grid {
	if (grid != currentGrid) {
    	[currentGrid release];
    	currentGrid = [grid retain];
    }
}

+ (void)createGrid:(NSString*)name ratio:(double)ratio assign:(BOOL)assign {
	Grid *grid = (Grid *)[NSEntityDescription insertNewObjectForEntityForName:@"Grid" inManagedObjectContext:[Core getInstance].managedObjectContext];
	grid.name = name;
    grid.ratio = [NSNumber numberWithInteger:ratio];
    if(assign) {
        //grid.machine = CURRENT_MACHINE;
        [CURRENT_MACHINE addGrid:grid];
    }
	
	[self setCurrentGrid:grid];
}

@end
