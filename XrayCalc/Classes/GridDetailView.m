//
//  GridDetailView.m
//  XrayCalc
//
//  Created by Courtzie on 24/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "GridDetailView.h"

@implementation GridDetailView

@synthesize nameLabel;
@synthesize valueLabel;

@synthesize shouldCreateNew;
@synthesize shouldSave;

-(void) dealloc {
    [super dealloc];
    [nameLabel release];
    [valueLabel release];
}

-(void) save {
    shouldSave = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad { // do this once on load (generally the setup)
    [super viewDidLoad];
    
     self.tableView = [[UITableView alloc] initWithFrame:
     self.tableView.frame style:UITableViewStyleGrouped];
     self.view.backgroundColor = BACKGROUND_COLOUR;
    
    shouldSave = NO;
    
    [[Core getInstance] saveContext];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 100, 44)];
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 74, 100, 44)];
    if (shouldCreateNew) {
        self.title = @"New Grid";
        [Grid createGrid:@"New Grid" ratio:1 assign:NO];
             
    } else {
        self.title = @"Edit Grid";
        
    }
    
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
        if (shouldCreateNew)
            [CURRENT_MACHINE addGrid:CURRENT_GRID];
        [[Core getInstance] saveContext];
    } else {
        [[Core getInstance].managedObjectContext rollback];
    }
}

#pragma mark - Table View Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]; 
       // tableView.separatorColor = [UIColor  colorWithHue:50.0f/255 saturation:50.0f/255 brightness:50.0f/255 alpha:1];
       // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorColor = [UIColor clearColor];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
        background.image = [UIImage imageNamed:@"GroupedCellBackground.png"];
        [cell setBackgroundView:background];
        [self.view sendSubviewToBack:background];
        [background release];
        
        [cell autorelease];
    }
    NSArray *fields = [NSArray arrayWithObjects:@"Name:", @"Ratio:", nil];
    cell.textLabel.text = [fields objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:26.0f/255 green:178.0f/255 blue:231.0f/255 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithRed:15.0f/255 green:15.0f/255 blue:15.0f/255 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;   
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 13.5f, 220, 44)];
    textField.delegate = self;
    textField.font  = [UIFont systemFontOfSize:15.0f];
    textField.textColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    if (indexPath.row == 0) { // First (Name) cell
        textField.text = CURRENT_GRID.name;
        textField.tag = 1;
    } else { // Second (Ratio) cell
        textField.placeholder = @"Value:1";
        textField.text = [[CURRENT_GRID.ratio stringValue] stringByAppendingString:@":1"];
        textField.tag = 2;
      //  textField.text = [CURRENT_GRID.ratio stringValue];
       /* UILabel *ratioSuffix = [[UILabel alloc] initWithFrame:CGRectMake(280, -2, 20, 44)];
        ratioSuffix.text = @":1";
        ratioSuffix.backgroundColor = [UIColor clearColor];
        ratioSuffix.font = [UIFont systemFontOfSize:18.0f];
        ratioSuffix.textColor = [UIColor whiteColor];
        
        [cell addSubview:ratioSuffix];
        [ratioSuffix release];*/
        
    }
    [cell addSubview:textField];
    [textField release];

    return  cell;
}

#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *) textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 2 && [textField.text length] > 2 && [[textField.text substringFromIndex:[textField.text length]-2] isEqualToString:@":1"])  {
        textField.text = [textField.text substringToIndex:[textField.text length]-2];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        CURRENT_GRID.name = textField.text;
        
    } else {
        CURRENT_GRID.ratio = [NSNumber numberWithInt:[textField.text intValue]];
    }
    if (textField.tag == 2 && [textField.text length] > 0 ) {
        textField.text = [textField.text stringByAppendingString:@":1"];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
    if (textField.tag == 2 && ![string isEqualToString:@""]){
        if ([f numberFromString:string])
            return  YES;
        return NO;
    }
    return YES;
    
}


@end
