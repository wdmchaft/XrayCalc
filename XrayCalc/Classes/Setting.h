//
//  Setting.h
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum {
    kSettingTypeKV = 0,
    kSettingTypeMA = 1,
    kSettingTypeS  = 2
};
typedef NSUInteger kSettingType;

@class Machine;

@interface Setting : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * type;

@property (nonatomic, retain) Machine *machine;

+ (Setting *)getCurrentSetting:(kSettingType)type;
+ (void)setCurrentSetting:(Setting *)setting;

+ (void)createSetting:(kSettingType)type value:(double)value assign:(BOOL)assign;

+ (NSString*)getDisplayStringForType:(kSettingType)type;

@end
