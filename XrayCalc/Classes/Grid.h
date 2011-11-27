//
//  Grid.h
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Machine;

@interface Grid : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ratio;

@property (nonatomic, retain) Machine *machine;

+ (Grid *)getCurrentGrid;
+ (void)setCurrentGrid:(Grid *)grid;
+ (void)createGrid:(NSString*)name ratio:(double)ratio assign:(BOOL)assign;

@end
