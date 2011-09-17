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

static Core *instance;

+ (Core *) getInstance { 
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

+(UIImage*)getScaledImage:(UIImage*)image {
    CGSize newSize = CGSizeMake(image.size.width/2, image.size.height/2);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

@end
