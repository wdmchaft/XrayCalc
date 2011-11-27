//
//  Core.h
//  XrayCalc
//
//  Created by Tim Robb on 20110917.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entities.h"

#define CURRENT_MACHINE [Machine getCurrentMachine]
#define CURRENT_GRID    [Grid    getCurrentGrid]
#define CURRENT_PLATE   [Plate   getCurrentPlate]
#define CURRENT_SETTING_KV [Setting getCurrentSetting:kSettingTypeKV]
#define CURRENT_SETTING_MA [Setting getCurrentSetting:kSettingTypeMA]
#define CURRENT_SETTING_S  [Setting getCurrentSetting:kSettingTypeS]

enum {
    kScreenIPhone = 0,
    kScreenRetina = 1,
    kScreenIPad = 2
};
typedef NSUInteger kScreenType;

@protocol CoreUpdates <NSObject>

-(void)coreUpdate;

@end

@interface Core : NSObject {
    kScreenType screenType;
    UIImage *currentTexture;
    
    id<CoreUpdates> delegate;
}

@property (nonatomic,assign) kScreenType screenType;
@property (nonatomic,retain) UIImage *currentTexture;

@property (nonatomic,retain) id<CoreUpdates> delegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Core *)      getInstance;
+ (UIImage*)    getScaledImage:(UIImage*)image;
+ (NSArray*)    getKVDefaults;
+ (NSArray*)    getMADefaults;
+ (NSArray*)    getSDefaults;

+ (Setting *)   findClosestValue:(double)needle inSettingArray:(NSArray*)haystack;
+ (Setting *)   findClosestOrder:(double)value inSettingArray:(NSArray*)haystack;
+ (Setting *)   calculateSettingFromMachine:(Machine*)machine type:(kSettingType)type;

+ (void)        update:(Setting*)setting;

+(UIImage *)    rotateImage:(UIImage*)image by:(CGFloat)radians degrees:(BOOL)isDegrees;

- (id)          init;
- (void)        launchInitalization;

- (void)        saveContext;
- (NSArray*)    getMachineArray;
- (NSURL *)     applicationDocumentsDirectory;

@end
