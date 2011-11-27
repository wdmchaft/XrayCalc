//
//  Setting.m
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "Setting.h"
#import "Machine.h"


@implementation Setting

@dynamic value;
@dynamic order;
@dynamic type;

@dynamic machine;

static Setting *currentKVSetting;
static Setting *currentMASetting;
static Setting *currentSSetting;

+ (Setting *)getCurrentSetting:(kSettingType)type {
    switch (type) {
        case kSettingTypeKV:
            return currentKVSetting;
            break;
            
        case kSettingTypeMA:
            return currentMASetting;
            break;
            
        case kSettingTypeS:
            return currentSSetting;
            break;
            
        default:
            break;
    }
    
    return nil;
}

+ (void)setCurrentSetting:(Setting *)setting {
    switch ([setting.type intValue]) {
        case kSettingTypeKV:
            if (setting != currentKVSetting) {
                [currentKVSetting release];
                currentKVSetting = [setting retain];
            }
            break;
            
        case kSettingTypeMA:
            if (setting != currentMASetting) {
                [currentMASetting release];
                currentMASetting = [setting retain];
            }
            break;
            
        case kSettingTypeS:
            if (setting != currentSSetting) {
                [currentSSetting release];
                currentSSetting = [setting retain];
            }
            break;
            
        default:
            break;
    }
    
}

+ (void)createSetting:(kSettingType)type value:(double)value assign:(BOOL)assign {
	Setting *setting = (Setting *)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:[Core getInstance].managedObjectContext];
    setting.type = [NSNumber numberWithInteger:type];
    setting.value = [NSNumber numberWithDouble:value];
    if(assign) {
        //setting.machine = CURRENT_MACHINE;
        [CURRENT_MACHINE addSetting:setting];
    }
	
	[self setCurrentSetting:setting];
}

+ (NSString*)getDisplayStringForType:(kSettingType)type {
    switch (type) {
        case kSettingTypeKV:
            return @"kV";
            break;
            
        case kSettingTypeMA:
            return @"mA";
            break;
            
        case kSettingTypeS:
            return @"s";
            break;
            
        default:
            return @"";
            break;
    }
}

@end
