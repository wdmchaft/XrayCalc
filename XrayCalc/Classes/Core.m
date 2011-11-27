//
//  Core.m
//  XrayCalc
//
//  Created by Tim Robb on 20110917.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "Core.h"

@implementation Core

@synthesize screenType;
@synthesize currentTexture;

@synthesize delegate;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static Core *instance;

+ (Core *) getInstance { 
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

-(void)dealloc {
    [currentTexture release];
    [delegate release];
    
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

+(UIImage*)getScaledImage:(UIImage*)image {
    CGSize newSize = CGSizeMake(image.size.width/2, image.size.height/2);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSArray*)getKVDefaults {
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:50],
            [NSNumber numberWithInt:60],
            [NSNumber numberWithInt:70],
            [NSNumber numberWithInt:80],
            [NSNumber numberWithInt:90],
           nil];
}

+(NSArray*)getMADefaults {
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:15],
            [NSNumber numberWithInt:30],
            [NSNumber numberWithInt:25],
            [NSNumber numberWithInt:20],
            [NSNumber numberWithInt:15],
           nil];
}

+(NSArray*)getSDefaults {
    return [NSArray arrayWithObjects:
            [NSNumber numberWithFloat:0.02],
            [NSNumber numberWithFloat:0.04],
            [NSNumber numberWithFloat:0.08],
            [NSNumber numberWithFloat:0.1],
            [NSNumber numberWithFloat:0.15],
            [NSNumber numberWithFloat:0.2],
            [NSNumber numberWithFloat:0.25],
            [NSNumber numberWithFloat:0.3],
            [NSNumber numberWithFloat:0.4],
            [NSNumber numberWithFloat:0.5],
            [NSNumber numberWithFloat:0.6],
            [NSNumber numberWithFloat:0.8],
            [NSNumber numberWithInt:1],
            [NSNumber numberWithFloat:1.5],
            [NSNumber numberWithInt:2],
            [NSNumber numberWithFloat:2.5],
            [NSNumber numberWithInt:3],
            [NSNumber numberWithFloat:3.5],
            [NSNumber numberWithInt:4],
            [NSNumber numberWithInt:5],
            [NSNumber numberWithInt:6],
            [NSNumber numberWithInt:7],
            [NSNumber numberWithInt:8],
            [NSNumber numberWithInt:10],
           nil];
}

+ (Setting *) findClosestValue:(double)needle inSettingArray:(NSArray*)haystack {
	double ret = [((Setting*)[haystack objectAtIndex:0]).value doubleValue];
	int ii = 0;
	double diff = fabs(ret - needle);
	for (int i=1; i<[haystack count]; i++) {
		if (ret != [((Setting*)[haystack objectAtIndex:i]).value doubleValue]) {
			double newdiff = fabs([((Setting*)[haystack objectAtIndex:i]).value doubleValue] - needle);
			if (newdiff < diff) {
				ret = [((Setting*)[haystack objectAtIndex:i]).value doubleValue];
				diff = newdiff;
				ii = i;
			}
		}
	}
	
	return (Setting*)[haystack objectAtIndex:ii];
}

+ (Setting *) findClosestOrder:(double)value inSettingArray:(NSArray*)haystack {
	int order = ceilf(value);
    if (order >= [haystack count]) {
        return (Setting*)[haystack lastObject];
    } else if (order < 0) {
        return (Setting*)[haystack objectAtIndex:0];
    }
    return (Setting*)[haystack objectAtIndex:order];
}

+ (Setting *)calculateSettingFromMachine:(Machine *)machine type:(kSettingType)type {
    if(!machine || !type)
        return nil;
    
    double thickness   = [machine.thicknessValue doubleValue] + 3;
    double density     = [machine.densityValue doubleValue] * 6;
    double fudgefactor = FUDGE*[machine.fudge intValue];
    
    double kV          = pow([CURRENT_SETTING_KV.value doubleValue]/50, 1.9); // increase kV to power of 5!! Wow
    double mA          = [CURRENT_SETTING_MA.value doubleValue];
    double s           = [CURRENT_SETTING_S.value doubleValue];
    
    double plate       = 1/([CURRENT_PLATE.speed floatValue]/[[machine getBasePlate].speed floatValue]);
    double grid        = [CURRENT_GRID.ratio doubleValue]; // Default value is 6
    
    double value       = -999;
    
    if (type == kSettingTypeS) {
        value          = mA * (thickness - density) * (fudgefactor * plate * grid) / kV;
    } else if (type == kSettingTypeKV) {
        value          = mA * (thickness - density) * (fudgefactor * plate * grid) * s;
    } else if (type == kSettingTypeMA) {
        value          = s  / (thickness - density) * (fudgefactor * plate * grid) / kV;
    }
    
    //NSLog(@"%.2f = %.2f * (%.2f - %.2f) * (%.2f * %.2f * %.2f) / %.2f",value,mA,thickness,density,fudgefactor,plate,grid,kV);    
    //NSLog(@"%.2f",[[self findClosestValue:value inSettingArray:[machine getSettingsArrayOfType:type]].value  doubleValue]);
    
    if(value == -999)
        return nil;
    
    return [self findClosestValue:value inSettingArray:[machine getSettingsArrayOfType:type]];
}

+ (void) update:(Setting *)setting {
    [Setting setCurrentSetting:setting];
    if ([[Core getInstance].delegate conformsToProtocol:@protocol(CoreUpdates)] && [[Core getInstance].delegate respondsToSelector:@selector(coreUpdate)])
        [[Core getInstance].delegate coreUpdate];
}

-(id)init {
    if([super init]) {
        CGSize size = [UIScreen mainScreen].currentMode.size;
        // iphone = 320x480, retina = 640x960, ipad = 768x1024
        switch ((int)size.width) {
            case 960:
            case 640:
                self.screenType = kScreenRetina;
                self.currentTexture = TEXTURE_RETINA;
                break;
                
            case 1024:
            case 768:
                self.screenType = kScreenIPad;
                self.currentTexture = nil;
                break;
                
            default:
                self.screenType = kScreenIPhone;
                self.currentTexture = TEXTURE_NORMAL;
                break;
        }
    }
    
    return self;
}

-(void)launchInitalization {
    [Machine createMachine:@"Atomscope 903A" withSourceType:kMachineSourceTypeDefault defaults:YES];
    [Machine createMachine:@"Another Machine" withSourceType:kMachineSourceTypeCustom defaults:YES];
    [Machine setCurrentMachine:[[self getMachineArray] objectAtIndex:0]];
    
    [Core update:[Core calculateSettingFromMachine:CURRENT_MACHINE type:[CURRENT_MACHINE.outputType intValue]]];
}

+(UIImage *)rotateImage:(UIImage*)image by:(CGFloat)radians degrees:(BOOL)isDegrees {
    if (isDegrees) {
        radians = radians * M_PI / 180;
    }
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Core Data stack

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XrayCalc" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XrayCalc.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSArray*)getMachineArray {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Machine" inManagedObjectContext:context]];
    [request setIncludesSubentities:NO];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error: &error];
    
    [request release];
    
    return objects;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
