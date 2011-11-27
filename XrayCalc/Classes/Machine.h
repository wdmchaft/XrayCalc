//
//  Machine.h
//  XrayCalc
//
//  Created Tim Robb 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Setting.h"

enum {
    kMachineSourceTypeDefault = 0,
    kMachineSourceTypeCustom = 1
};
typedef NSUInteger kMachineSourceType;

@class Grid, Plate;

@interface Machine : NSManagedObject {
    NSMutableArray * platesArray;
    NSMutableArray * gridsArray;
    NSMutableArray * kvArray;
    NSMutableArray * maArray;
    NSMutableArray * sArray;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * fudge;
@property (nonatomic, retain) NSNumber * sourceType;
@property (nonatomic, retain) NSNumber * outputType;
@property (nonatomic, retain) NSNumber * inputsLinked;

@property (nonatomic, retain) NSNumber * leftSetting;
@property (nonatomic, retain) NSNumber * rightSetting;

@property (nonatomic, retain) NSNumber * thicknessMin;
@property (nonatomic, retain) NSNumber * thicknessMax;
@property (nonatomic, retain) NSNumber * thicknessValue;
@property (nonatomic, retain) NSNumber * thicknessInitial;

@property (nonatomic, retain) NSString * densityLeftTitle;
@property (nonatomic, retain) NSString * densityRightTitle;
@property (nonatomic, retain) NSNumber * densityMinimum;
@property (nonatomic, retain) NSNumber * densityMaximum;
@property (nonatomic, retain) NSNumber * densityValue;
@property (nonatomic, retain) NSNumber * densityInitial;

@property (nonatomic, retain) NSMutableArray * platesArray;
@property (nonatomic, retain) NSMutableArray * gridsArray;
@property (nonatomic, retain) NSMutableArray * kvArray;
@property (nonatomic, retain) NSMutableArray * maArray;
@property (nonatomic, retain) NSMutableArray * sArray;

@property (nonatomic, retain) NSSet *plates;
@property (nonatomic, retain) NSSet *grids;
@property (nonatomic, retain) NSSet *settings;

+ (Machine *)getCurrentMachine;
+ (void)     setCurrentMachine:(Machine *)machine;
+ (void)     createMachine:(NSString*)name withSourceType:(kMachineSourceType)sourceType defaults:(BOOL)shouldDefault;

- (void)     generateDefaults;

- (void)     loadData;

- (NSString*)getOutputTypeString;

- (void)     addPlate:(Plate *) plate;
- (void)     deletePlate:(Plate *) plate;
- (NSArray *)getPlatesArray;
- (Plate   *)getLastPlate;
- (Plate   *)getBasePlate;

- (void)     addGrid:(Grid *) grid;
- (void)     deleteGrid:(Grid *) grid;
- (NSArray *)getGridsArray;
- (Grid    *)getLastGrid;

- (void)     addSetting:(Setting *) setting;
- (void)     deleteSetting:(Setting *) setting;
- (NSArray *)getSettingsArray;
- (NSArray *)getSettingsArrayOfType:(kSettingType)type;
- (Setting *)getSettingOfType:(kSettingType)type withValue:(double)value;
- (Setting *)getLastSetting;
- (Setting *)getLastSettingOfType:(kSettingType)type;

@end

@interface Machine (CoreDataGeneratedAccessors)

- (void)addPlatesObject:(Plate *)value;
- (void)removePlatesObject:(Plate *)value;
- (void)addPlates:(NSSet *)values;
- (void)removePlates:(NSSet *)values;

- (void)addGridsObject:(Grid *)value;
- (void)removeGridsObject:(Grid *)value;
- (void)addGrids:(NSSet *)values;
- (void)removeGrids:(NSSet *)values;

- (void)addSettingsObject:(Setting *)value;
- (void)removeSettingsObject:(Setting *)value;
- (void)addSettings:(NSSet *)values;
- (void)removeSettings:(NSSet *)values;
@end
