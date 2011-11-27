//
//  PlatesListControlView.h
//  XrayCalc
//
//  Created by Courtzie on 26/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatesListControlView.h"
#import "PlatesDetailView.h"

@interface PlatesListControlView : UITableViewController {
    NSMutableArray *listOfItems;
    
    BOOL hidesToolbar;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;

@property (nonatomic, assign) BOOL hidesToolbar;


@end

