//
//  UINavigationBlueBar.m
//  XrayCalc
//
//  Created by Tim Robb on 20110918.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "UINavigationBlueBar.h"

@implementation UINavigationBlueBar

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIImage imageNamed:@"NavigationBar.png"] drawInRect:rect];
}

@end
