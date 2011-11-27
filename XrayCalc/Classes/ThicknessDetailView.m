//
//  ThicknessDetailView.m
//  XrayCalc
//
//  Created by MiniServe on 26/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThicknessDetailView.h"

@implementation ThicknessDetailView

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
    
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.view.backgroundColor = BACKGROUND_COLOUR;
    
    shouldSave = NO;
    
    self.title = @"Thickness";
    
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
        CURRENT_MACHINE.thicknessInitial = [NSNumber numberWithInt:[self.initialLabel.text intValue]];
        CURRENT_MACHINE.thicknessMin = [NSNumber numberWithInt:[self.maxLabel.text intValue]];
        CURRENT_MACHINE.thicknessMax = [NSNumber numberWithInt:[self.minLabel.text intValue]];
        [[Core getInstance] saveContext];
    } else {
        [[Core getInstance].managedObjectContext rollback];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    NSArray *fields = [NSArray arrayWithObjects:@"Initial:",@"Minimum:", @"Maximum:",  nil];
    cell.textLabel.text = [fields objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:26.0f/255 green:178.0f/255 blue:231.0f/255 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithRed:15.0f/255 green:15.0f/255 blue:15.0f/255 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;   
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.font  = [UIFont systemFontOfSize:15.0f];
    textField.textColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    if (indexPath.row == 0) {
        textField.tag = 1;
        textField.text = [[CURRENT_MACHINE.thicknessInitial stringValue] stringByAppendingString:@"%"];
        textField.frame = CGRectMake(80, 13.5f, 220, 44);
    } else if (indexPath.row == 1) {
        textField.tag = 2;
        textField.text = [[CURRENT_MACHINE.thicknessMin stringValue] stringByAppendingString:@"%"];
        textField.frame = CGRectMake(110, 13.5f, 190, 44);
    } else if (indexPath.row == 2) {
        textField.tag = 3;
        textField.text = [[CURRENT_MACHINE.thicknessMax stringValue] stringByAppendingString:@"%"];
        textField.frame = CGRectMake(112, 13.5f, 188, 44);
    }
    
    
    [cell addSubview:textField];
    [textField release];
    
    return  cell;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text length] > 0 && [[textField.text substringFromIndex:[textField.text length]-1] isEqualToString:@"%"])  {
        textField.text = [textField.text substringToIndex:[textField.text length]-1];
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        CURRENT_MACHINE.thicknessInitial = [NSNumber numberWithInt:[textField.text intValue]];
    } else if (textField.tag == 2) {
        CURRENT_MACHINE.thicknessMin = [NSNumber numberWithInt:[textField.text intValue]]; 
    } else {
        CURRENT_MACHINE.thicknessMax = [NSNumber numberWithInt:[textField.text intValue]];
    }
    if ([textField.text length] > 0 ) {
        textField.text = [textField.text stringByAppendingString:@"%"];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSNumberFormatter *f = [[[NSNumberFormatter alloc]init] autorelease];
    if (![string isEqualToString:@""]){
        if ( [f numberFromString:string])
            return  YES;
        return NO;
    }
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
