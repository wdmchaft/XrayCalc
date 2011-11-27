//
//  CoreNetwork.m
//  XrayCalc
//
//  Created by Timothy Robb on 10/11/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "CoreNetwork.h"

@implementation CoreNetwork

static CoreNetwork *instance;

+ (CoreNetwork *) getInstance { 
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

- (id) init {
	if([super init]) {
        RKClient *client = [RKClient clientWithBaseURL:SERVER_HOST];
		
		[client setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] forHTTPHeaderField:@"X-APP-NAME"];
        [client setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] forHTTPHeaderField:@"X-APP-VERSION"];
        [client setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"X-DEVICE-MODEL"];
        [client setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"X-DEVICE-OS"];
        [client setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    return self;
}

@end
