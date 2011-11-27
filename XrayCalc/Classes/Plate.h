//
//  Plate.h
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Machine;

@interface Plate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * isBase;

@property (nonatomic, retain) Machine *machine;

+ (Plate *)getCurrentPlate;
+ (void)setCurrentPlate:(Plate *)plate;
+ (void)createPlate:(NSString*)name speed:(double)speed assign:(BOOL)assign base:(BOOL)base;

@end
