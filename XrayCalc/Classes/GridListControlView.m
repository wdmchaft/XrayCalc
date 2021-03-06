//
//  GridListControlView.m
//  XrayCalc
//
//  Created by Courtzie on 22/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "GridListControlView.h"
#import "GridDetailView.h"

@implementation GridListControlView

@synthesize listOfItems;
@synthesize hidesToolbar;

- (void)dealloc {
    [listOfItems release];
    [super dealloc];
}

-(void)pushNew {
    GridDetailView *detailView = [[GridDetailView alloc] init];
    detailView.shouldCreateNew = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad { // do this once on load (generally the setup)
    [super viewDidLoad];
    
    // Title
    self.navigationItem.title = @"Grids";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BACKGROUND_COLOUR;
    self.hidesToolbar = NO;
   
    UIImageView *footer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 11)];
    UIImage *footerImage = [Core getScaledImage:[UIImage imageNamed:@"ShadowBottom.png"]];
    
    footer.image = footerImage;

    self.tableView.tableFooterView = footer;
    [footer release];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 11)];
    UIImage *headerImage = [Core getScaledImage:[UIImage imageNamed:@"ShadowTop.png"]];
    
    header.image = headerImage;
    
    self.tableView.tableHeaderView = header;
    [header release];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-11, 0, -11, 0)];
    
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
    
    [self setToolbarItems:[NSArray arrayWithObjects:addButtonItem, flex, deleteButtonItem, nil]];
    [button release];
    
    UIImage *edit = [UIImage imageNamed:@"BlankButtonWide.png"];
    UIButton *editButton = [[UIButton alloc]init];
    editButton.frame = CGRectMake(0, 50, 61, 30);
    [editButton addTarget:self action:@selector(pushNew) forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:edit forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"BlankButtonWidePressed.png"] forState:UIControlEventTouchDown];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];

    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    [editButton release];

    self.listOfItems = [[NSMutableArray alloc] init];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CURRENT_MACHINE loadData];
    [self.listOfItems setArray:[CURRENT_MACHINE getGridsArray]];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listOfItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CellIdentifier] autorelease];
            
    }
    //set up cell
    Grid *cellValue = (Grid*)[self.listOfItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:1", [cellValue.ratio intValue]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:35.0f/255 green:183.0f/255 blue:233.0f/255 alpha:1];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithRed:33.0f/255 green:33.0f/255 blue:33.0f/255 alpha:1];
        
    UIImage *image = [UIImage imageNamed:@"ListCellGradient.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //imageView.contentMode = UIViewContentModeScaleToFill;
    //imageView.frame = cell.frame;
    cell.backgroundView = imageView;
    [imageView release];

    // load image
    UIImage *accessoryImage = [UIImage imageNamed:@"DisclosureButton.png"];
    // set up image
    UIImageView *accImageView = [[UIImageView alloc] init];
    accImageView.frame = CGRectMake(0, 0, 24.5, 24);
    accImageView.userInteractionEnabled = YES;
    accImageView.image = accessoryImage;
    cell.accessoryView = accImageView;
    [accImageView release];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Grid setCurrentGrid:[self.listOfItems objectAtIndex:indexPath.row]];
    GridDetailView *detailView = [[GridDetailView alloc] init];
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}

@end