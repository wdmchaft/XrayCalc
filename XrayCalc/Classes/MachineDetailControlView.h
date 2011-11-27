//
//  MachineDetailControlView.h
//  XrayCalc
//
//  Created by Tim Robb on 20110925.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineDetailControlView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    Machine *machineToEdit;
    NSMutableArray *listOfItems;
    UITableView *table;

}
@property (nonatomic, retain) Machine *machineToEdit;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) UITableView *table;


@end
