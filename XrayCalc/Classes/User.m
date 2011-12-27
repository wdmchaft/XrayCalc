//
//  User.m
//  XrayCalc
//
//  Created by Timothy Robb on 11/12/11.
//  Copyright (c) 2011 Invader Tim. All rights reserved.
//

#import "User.h"
#import "Machine.h"

@implementation User

@dynamic email;
@dynamic username;
@dynamic name;

@dynamic defaultMachine;
@dynamic machines;
@synthesize machinesArray;

static User *currentUser;

+ (User *)fetchUser {
	NSArray *a = [self getAll];
	if (a && [a count] > 0) {
		return [a objectAtIndex:0];
	}
	return nil;
}

+ (User *)getCurrentUser {
	if (!currentUser) {
		currentUser = [self fetchUser];
	}
	return currentUser;
}

+ (void)setCurrentUser:(User *)user {
	if (user != currentUser) {
    	[currentUser release];
    	currentUser = [user retain];
    }
}

+ (User *)createUser:(BOOL)set {
	User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[Core getInstance].managedObjectContext];
	
	if (set) {
		[self setCurrentUser:user];
	}
	
	return user;
}

- (void)loadData {
	if (machinesArray) {
        [machinesArray removeAllObjects];
    } else {
        machinesArray = [[NSMutableArray alloc] init];
    }
    
    [machinesArray addObjectsFromArray:[self.machines allObjects]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [sortDescriptor release];
	[machinesArray sortUsingDescriptors:sortDescriptors];
}

- (void)addMachine:(Machine *)machine {
	[self addMachinesObject:machine];
	[self loadData];
}

- (void)deleteMachine:(Machine *)machine {
	if ([self.defaultMachine isEqual:machine]) {
		self.defaultMachine = nil;
	}
	[self removeMachinesObject:machine];
    [self.machinesArray removeObject:machine];
    [[Core getInstance].managedObjectContext deleteObject:machine];
}

+ (NSArray *)getAll {
	NSManagedObjectContext *context = [Core getInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [request setIncludesSubentities:NO];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error: &error];
    
    [request release];
    
    return objects;
}

- (NSArray *)getMachinesArray {
	if (!machinesArray) {
		[self loadData];
	}
    
    return machinesArray;
}

@end
