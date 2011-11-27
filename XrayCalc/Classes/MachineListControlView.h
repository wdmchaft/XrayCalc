//
//  MachineListControlView.h
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineListControlView : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *table;
    NSMutableArray *machineList;
    
    BOOL hidesToolbar;
}
@property (nonatomic,retain) UITableView *table;
@property (nonatomic,retain) NSMutableArray *machineList;
@property (nonatomic,assign) BOOL hidesToolbar;

@end
