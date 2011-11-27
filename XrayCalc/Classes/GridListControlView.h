//
//  GridListControlView.h
//  XrayCalc
//
//  Created by Courtzie on 22/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridListControlView : UITableViewController <UITextFieldDelegate> {
    NSMutableArray *listOfItems;
    
    BOOL hidesToolbar;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;

@property (nonatomic, assign) BOOL hidesToolbar;

@end

