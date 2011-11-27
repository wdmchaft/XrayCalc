//
//  CoreNetwork.h
//  XrayCalc
//
//  Created by Timothy Robb on 10/11/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

#define SERVER_HOST @"http://vetcalc.heroku.com/"

@interface CoreNetwork : NSObject

+ (CoreNetwork *) getInstance;

- (id) init;

@end
