//
//  User.h
//  XrayCalc
//
//  Created by Timothy Robb on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Machine;

@interface User : NSManagedObject {
	NSMutableArray *machinesArray;
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, retain) Machine *defaultMachine;
@property (nonatomic, retain) NSSet *machines;
@property (nonatomic, retain) NSMutableArray *machinesArray;

+ (User *)	getCurrentUser;
+ (void)	setCurrentUser:(User *)User;
+ (User *)	createUser:(BOOL)set;

- (void)	loadData;

- (void)	addMachine:(Machine *) Machine;
- (void)	deleteMachine:(Machine *) Machine;

+ (NSArray *)getAll;
- (NSArray *)getMachinesArray;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addMachinesObject:(Machine *)value;
- (void)removeMachinesObject:(Machine *)value;
- (void)addMachines:(NSSet *)values;
- (void)removeMachines:(NSSet *)values;
@end
