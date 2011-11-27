//
//  Machine.m
//  XrayCalc
//
//  Created Tim Robb 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "Core.h"

#import "Machine.h"
#import "Grid.h"
#import "Plate.h"
#import "Setting.h"


@implementation Machine

@dynamic name;
@dynamic fudge;
@dynamic sourceType;
@dynamic outputType;
@dynamic inputsLinked;

@dynamic leftSetting;
@dynamic rightSetting;

@dynamic thicknessMin;
@dynamic thicknessMax;
@dynamic thicknessValue;
@dynamic thicknessInitial;

@dynamic densityLeftTitle;
@dynamic densityRightTitle;
@dynamic densityMinimum;
@dynamic densityMaximum;
@dynamic densityValue;
@dynamic densityInitial;

@synthesize platesArray;
@synthesize gridsArray;
@synthesize kvArray;
@synthesize maArray;
@synthesize sArray;

@dynamic plates;
@dynamic grids;
@dynamic settings;

static Machine *currentMachine;

+ (Machine *)getCurrentMachine {
	return currentMachine;
}

+ (void)setCurrentMachine:(Machine *)machine {
	if (machine != currentMachine) {
    	[currentMachine release];
    	currentMachine = [machine retain];
    }
}

+ (void)createMachine:(NSString*)name withSourceType:(kMachineSourceType)sourceType defaults:(BOOL)shouldDefault {
	Machine *machine = (Machine *)[NSEntityDescription insertNewObjectForEntityForName:@"Machine" inManagedObjectContext:[Core getInstance].managedObjectContext];
	machine.name = name;
    machine.sourceType = [NSNumber numberWithInteger:sourceType];
    machine.fudge = [NSNumber numberWithInt:1];
    
    if(sourceType == kMachineSourceTypeDefault) {
        machine.thicknessMin = [NSNumber numberWithInt:0];
        machine.thicknessMax = [NSNumber numberWithInt:40];
        machine.thicknessInitial = [NSNumber numberWithInt:10];
        
        machine.densityLeftTitle = @"Bone";
        machine.densityRightTitle = @"Lung";
        machine.densityInitial = [NSNumber numberWithFloat:0.5];
        
        machine.outputType = [NSNumber numberWithInt:kSettingTypeS];
        machine.leftSetting = [NSNumber numberWithInt:kSettingTypeKV];
        machine.rightSetting = [NSNumber numberWithInt:kSettingTypeMA];
        machine.inputsLinked = [NSNumber numberWithBool:YES];
    }
	
	[self setCurrentMachine:machine];
    
    if(shouldDefault)
        [machine generateDefaults];
}

- (void)generateDefaults {
    [Grid  createGrid:  @"Default" ratio:DEFAULT_GRID_SPEED       assign:YES];
    [Plate createPlate: @"Base"    speed:DEFAULT_PLATE_SIZE_SMALL assign:YES base:YES];
    [Plate createPlate: @"Large"   speed:DEFAULT_PLATE_SIZE_LARGE assign:YES base:NO ];
    
    for (NSNumber *num in [Core getKVDefaults]) {
        [Setting createSetting:kSettingTypeKV value:[num doubleValue] assign:YES];
    }
    for (NSNumber *num in [Core getMADefaults]) {
        [Setting createSetting:kSettingTypeMA value:[num doubleValue] assign:YES];
    }
    for (NSNumber *num in [Core getSDefaults] ) {
        [Setting createSetting:kSettingTypeS  value:[num doubleValue] assign:YES];
    }
    
    [self loadData];
    
    [Setting setCurrentSetting:[[self getSettingsArrayOfType:kSettingTypeKV] objectAtIndex:0]];
    [Setting setCurrentSetting:[[self getSettingsArrayOfType:kSettingTypeMA] objectAtIndex:0]];
    [Setting setCurrentSetting:[[self getSettingsArrayOfType:kSettingTypeS]  objectAtIndex:0]];
}

- (void)loadData {
    if (platesArray) {
        [platesArray removeAllObjects];
    } else {
        platesArray = [[NSMutableArray alloc] init];
    }
    
    [platesArray addObjectsFromArray:[self.plates allObjects]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[platesArray sortUsingDescriptors:sortDescriptors];
    
    if (gridsArray) {
        [gridsArray removeAllObjects];
    } else {
        gridsArray = [[NSMutableArray alloc] init];
    }
    
    [gridsArray addObjectsFromArray:[self.grids allObjects]];
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[gridsArray sortUsingDescriptors:sortDescriptors];
    
    if (kvArray) {
        [kvArray removeAllObjects];
    } else {
        kvArray = [[NSMutableArray alloc] init];
    }
    
    for (Setting *thisSetting in self.settings) {
        if ([thisSetting.type intValue] == kSettingTypeKV)
            [kvArray addObject:thisSetting];
    }
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[kvArray sortUsingDescriptors:sortDescriptors];
    
    if (maArray) {
        [maArray removeAllObjects];
    } else {
        maArray = [[NSMutableArray alloc] init];
    }
    
    for (Setting *thisSetting in self.settings) {
        if ([thisSetting.type intValue] == kSettingTypeMA)
            [maArray addObject:thisSetting];
    }
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[maArray sortUsingDescriptors:sortDescriptors];
    
    if (sArray) {
        [sArray removeAllObjects];
    } else {
        sArray = [[NSMutableArray alloc] init];
    }
    
    for (Setting *thisSetting in self.settings) {
        if ([thisSetting.type intValue] == kSettingTypeS)
            [sArray addObject:thisSetting];
    }
	
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[sArray sortUsingDescriptors:sortDescriptors];
}

- (NSString*)getOutputTypeString {
    return [Setting getDisplayStringForType:[self.outputType intValue]];
}

#pragma mark - Plates

- (void)     addPlate:(Plate *) plate {
	[self addPlatesObject:plate];
	[self loadData];
}

- (void)     deletePlate:(Plate *) plate {
    [self removePlatesObject:plate];
    [self.platesArray removeObject:plate];
    [[Core getInstance].managedObjectContext deleteObject:plate];
}
- (NSArray *)getPlatesArray {
    if (!platesArray) {
		[self loadData];
	}
    
    return platesArray;
}
- (Plate   *)getLastPlate {
    if (!platesArray) {
		[self loadData];
	}
    
    return [platesArray lastObject];
}
- (Plate   *)getBasePlate {
    for (Plate *thisPlate in [self getPlatesArray]) {
        if ([thisPlate.isBase boolValue]) {
            return thisPlate;
        }
    }
    return nil;
}

#pragma mark - Grids

- (void)     addGrid:(Grid *) grid {
    [self addGridsObject:grid];
	[self loadData];
}
- (void)     deleteGrid:(Grid *) grid {
    [self removeGridsObject:grid];
    [self.gridsArray removeObject:grid];
    [[Core getInstance].managedObjectContext deleteObject:grid];
}
- (NSArray *)getGridsArray {
    if (!gridsArray) {
		[self loadData];
	}
    
    return gridsArray;
}
- (Grid    *)getLastGrid {
    if (!gridsArray) {
		[self loadData];
	}
    
    return [gridsArray lastObject];
}

#pragma mark - Settings

- (void)     addSetting:(Setting *) setting {
    setting.order = [NSNumber numberWithInt:[self.settings count]];
	[self addSettingsObject:setting];
	[self loadData];
}
- (void)     deleteSetting:(Setting *) setting {
    [self removeSettingsObject:setting];
    switch ([setting.type intValue]) {
        case kSettingTypeKV:
            [self.kvArray removeObject:setting];
            break;
            
        case kSettingTypeMA:
            [self.maArray removeObject:setting];
            break;
        
        case kSettingTypeS:
            [self.sArray removeObject:setting];
            break;
    }
    [[Core getInstance].managedObjectContext deleteObject:setting];
}
- (NSArray *)getSettingsArray {
    if (!kvArray || !maArray || !sArray) {
		[self loadData];
	}
    
    return [[[NSArray arrayWithArray:kvArray] arrayByAddingObjectsFromArray:maArray] arrayByAddingObjectsFromArray:sArray];
}
- (NSArray *)getSettingsArrayOfType:(kSettingType)type {
    switch (type) {
        case kSettingTypeKV:
            if(!kvArray) {
                [self loadData];
            }
            
            return kvArray;
            break;
            
        case kSettingTypeMA:
            if(!maArray) {
                [self loadData];
            }
            
            return maArray;
            break;
            
        case kSettingTypeS:
            if(!sArray) {
                [self loadData];
            }
            
            return sArray;
            break;
    }
    return nil;
}
- (Setting *)getSettingOfType:(kSettingType)type withValue:(double)value {
    for (Setting *thisSetting in [self getSettingsArrayOfType:type]) {
        if ([thisSetting.value doubleValue] == value) {
            return thisSetting;
        }
    }
    return nil;
}
- (Setting *)getLastSetting {
    return [[self getSettingsArray] lastObject];
}
- (Setting *)getLastSettingOfType:(kSettingType)type {
    return [[self getSettingsArrayOfType:type] lastObject];
}

@end
