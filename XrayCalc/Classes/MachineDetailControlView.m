//
//  MachineDetailControlView.m
//  XrayCalc
//
//  Created by Tim Robb and Courtzie Jayne on 20110925.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "MachineDetailControlView.h"
#import "ThicknessDetailView.h"
#import "DensityDetailView.h"
#import "PlatesListControlView.h"
#import "GridListControlView.h"

@implementation MachineDetailControlView

@synthesize machineToEdit;
@synthesize table;
@synthesize listOfItems;



-(void)dealloc {
    [super dealloc];
    [table release];
    [listOfItems release];
    [machineToEdit release];
}

-(void)viewDidLoad {
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.view.backgroundColor = BACKGROUND_COLOUR;
    self.table.backgroundColor = BACKGROUND_COLOUR;
    self.title = self.machineToEdit.name;
    [self.view addSubview:self.table];
    
    NSArray *settingsList = [NSArray arrayWithObjects:@"Thickness", @"Density", @"Plates", @"Grids", @"Dials", @"Output", nil];
    [self.listOfItems setArray:settingsList];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    } else if (section == 1 ) {
        return 2;
    } else if (section == 2 ) {
        return 2;
    }
    return  0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
            NSString *cellIdentifier = @"Cell";
            cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
            
           if(cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
           // Put any details about the cell that won't change, e.g background, colour, text size, text colour.
                                          
            cell.textLabel.textColor = [UIColor colorWithRed:26.0f/255 green:178.0f/255 blue:231.0f/255 alpha:1];
               cell.textLabel.backgroundColor = [UIColor clearColor];

               
             /*  UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
               background.image = [UIImage imageNamed:@"cellButtonBackground.png"];
               [cell setBackgroundView:background];
               [self.view sendSubviewToBack:background];
               [background release];
               */
               tableView.separatorColor = [UIColor clearColor];
               
               UIImage *image = [UIImage imageNamed:@"CellButtonSettingsBackground.png"];
               UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
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
               
        } 
           // Put here any details about the cell that DO change, e.g setting values/text, like below:
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //thickness
            cell.textLabel.text = @"Thickness";
            
        } else if (indexPath.row == 1) {
            // density
            cell.textLabel.text = @"Density";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // plates
            cell.textLabel.text = @"Plates";
        } else if (indexPath.row == 1) {
            // grids
            cell.textLabel.text =@"Grids";
        }
    } else if (indexPath.section == 2) {
        if(indexPath.row == 0) {
            //dials
            cell.textLabel.text = @"Dials";
        } else if(indexPath.row == 1) {
            //output
            cell.textLabel.text = @"Output";
        }
    }
    
    [cell autorelease];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //thickness
            ThicknessDetailView *infoViewController = [[ThicknessDetailView alloc] init];
            [self.navigationController pushViewController:infoViewController animated:YES];
            [infoViewController release];
            
            
        } else if (indexPath.row == 1) {
            // density
            DensityDetailView *infoViewController = [[DensityDetailView alloc] init];
            [self.navigationController pushViewController:infoViewController animated:YES];
            [infoViewController release];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // plates
            PlatesListControlView *infoViewController = [[PlatesListControlView alloc] init];
            [self.navigationController pushViewController:infoViewController animated:YES];
            [infoViewController release];
        } else if (indexPath.row == 1) {
            // grids
            GridListControlView *infoViewController = [[GridListControlView alloc] init];
            [self.navigationController pushViewController:infoViewController animated:YES];
            [infoViewController release];
        }
    } else if (indexPath.section == 2) {
        if(indexPath.row == 0) {
            //dials
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //output
        }
    }
    
}

@end