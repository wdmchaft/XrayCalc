//
//  MachineListControlView.m
//  XrayCalc
//
//  Created by Tim Robb on 20110920.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MachineListControlView.h"
#import "MachineDetailControlView.h"

@implementation MachineListControlView

@synthesize hidesToolbar;
@synthesize table;
@synthesize machineList;

-(void)dealloc {
    [super dealloc];
    [machineList release];
    [table release];
}

-(void)pushDetail:(UIButton*)sender {
    MachineDetailControlView *detailControlView = [[MachineDetailControlView alloc] init];
    detailControlView.machineToEdit = [self.machineList objectAtIndex:sender.tag];
    [self.navigationController pushViewController:detailControlView animated:YES];
    [detailControlView release];
}

#pragma mark - View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Machines";
    self.view.backgroundColor = BACKGROUND_COLOUR;
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.backgroundColor = BACKGROUND_COLOUR;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    // load image
    UIImage *plusButton = [UIImage imageNamed:@"BlankButtonWide.png"];
    // set up button
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 61, 30);
    [button addTarget:self action:@selector(pushNew) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:plusButton forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"BlankButtonWidePressed.png"] forState:UIControlEventTouchDown];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    UIBarButtonItem *addButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    // load image
    UIImage *deleteButton = [UIImage imageNamed:@"Delete.png"];
    // set up button
    UIButton *delete = [[UIButton alloc] init];
    delete.frame = CGRectMake(0, 0, 61, 30);
    [delete addTarget:self action:@selector(pushNew) forControlEvents:UIControlEventTouchUpInside];
    [delete setBackgroundImage:deleteButton forState:UIControlStateNormal];
    [delete setBackgroundImage:[UIImage imageNamed:@"DeletePressed.png"] forState:UIControlEventTouchDown];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    delete.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    UIBarButtonItem *deleteButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:delete] autorelease];
    
    
    UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:addButtonItem,flex,deleteButtonItem,nil];
    [self setToolbarItems:array animated:NO];    
    
    
    
    self.machineList = [[[Core getInstance] getMachineArray] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.machineList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"Machine%d",indexPath.row+1];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.textLabel.text = ((Machine*)[self.machineList objectAtIndex:indexPath.row]).name;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ListCellGradient.png"]] autorelease];
        
        UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24.5f, 24)];
        accessoryButton.tag = indexPath.row;
        [accessoryButton setImage:[UIImage imageNamed:@"DisclosureButton.png"] forState:UIControlStateNormal];
        [accessoryButton addTarget:self action:@selector(pushDetail:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = accessoryButton;
        [accessoryButton release];
    }
    
    if([CURRENT_MACHINE isEqual:[self.machineList objectAtIndex:indexPath.row]]) {
        [cell.imageView setImage:[Core getScaledImage:[UIImage imageNamed:@"Tick.png"]]];
    } else {
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *previous = [NSIndexPath indexPathForRow:[self.machineList indexOfObject:CURRENT_MACHINE] inSection:0];
    if (previous.row != indexPath.row) {
        [Machine setCurrentMachine:[self.machineList objectAtIndex:indexPath.row]];
        [CURRENT_MACHINE loadData];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:previous,indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end