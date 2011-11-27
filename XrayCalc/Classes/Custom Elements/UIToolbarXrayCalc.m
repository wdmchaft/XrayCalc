//
//  UIToolbarXrayCalc.m
//  XrayCalc
//
//  Created by Tim Robb on 20110925.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

@interface UIToolbarXrayCalc : UIToolbar
@end

@implementation UIToolbarXrayCalc

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIImage imageNamed:@"Toolbar.png"] drawInRect:rect];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = BACKGROUND_COLOUR;
    }
    return self;
}

@end
