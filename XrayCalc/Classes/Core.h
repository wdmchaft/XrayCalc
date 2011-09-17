//
//  Core.h
//  XrayCalc
//
//  Created by Tim Robb on 20110917.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kScreenIPhone = 0,
    kScreenRetina = 1,
    kScreenIPad = 2
};

@interface Core : NSObject {
    NSInteger screenType;
    UIImage *currentTexture;
}

@property (nonatomic,assign) NSInteger screenType;
@property (nonatomic,retain) UIImage *currentTexture;

+ (Core *) getInstance;
+ (UIImage*) getScaledImage:(UIImage*)image;
- (id) init;

@end
