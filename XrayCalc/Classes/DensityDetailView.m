//
//  DensityDetailView.m
//  XrayCalc
//
//  Created by Courtzie on 26/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "DensityDetailView.h"

@implementation DensityDetailView
@synthesize minLabel;
@synthesize maxLabel;
@synthesize initialLabel;
@synthesize shouldCreateNew;
@synthesize shouldSave;

-(void) dealloc {
    [super dealloc];
    [minLabel release];
    [maxLabel release];
    [minLabel release];
}

-(void) save {
    shouldSave = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Lifecycle

-(void) viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:
    self.tableView.frame style:UITableViewStyleGrouped];
    self.view.backgroundColor = BACKGROUND_COLOUR;
    
    shouldSave = NO;
    
    self.title = @"Density";
    
    // load image
    UIImage *saveButton = [UIImage imageNamed:@"BlankButtonWide.png"];
    // set up button
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 61, 30);
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:saveButton forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"BlankButtonWidePressed.png"] forState:UIControlEventTouchDown];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    [button release];
   
}

-(void) viewWillDisappear:(BOOL)animated {
    if (shouldSave) {
        CURRENT_MACHINE.densityInitial = [NSNumber numberWithInt:[self.initialLabel.text intValue]];
        CURRENT_MACHINE.densityMaximum = [NSNumber numberWithInt:[self.maxLabel.text intValue]];
        CURRENT_MACHINE.densityMinimum = [NSNumber numberWithInt:[self.minLabel.text intValue]];
        [[Core getInstance] saveContext];
    } else {
        [[Core getInstance].managedObjectContext rollback];
    }
}

@end