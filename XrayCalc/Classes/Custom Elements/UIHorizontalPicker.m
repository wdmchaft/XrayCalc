//
//  UIHorizontalPicker.m
//  XrayCalc
//
//  Created by Timothy Robb on 27/11/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "UIHorizontalPicker.h"
#import "Entities.h"

@implementation UIHorizontalPicker

@synthesize pickerType;
@synthesize selectedRow;

@synthesize scrollView;
@synthesize background;
@synthesize button;

@synthesize title;

-(void)dealloc {
	[super dealloc];
	
	[scrollView release];
	[background release];
	[button release];
	
	[title release];
}

-(id)initWithFrame:(CGRect)frame andType:(kHorizontalPickerType)type {
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 126, 36)]) {
		self.pickerType = type;
		
		self.background = [[[UIImageView alloc] initWithImage:[Core getScaledImage:[UIImage imageNamed:@"picker.png"]]] autorelease];
		self.background.userInteractionEnabled = NO;
		
		[self addSubview:self.background];
		
		UIView *currentView = [self getCurrentView];
		self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
		self.scrollView.userInteractionEnabled = NO;
		self.scrollView.contentSize = CGSizeMake(currentView.frame.size.width, currentView.frame.size.height*[self numberOfRows]*1.5);
		
		[self.scrollView addSubview:currentView];
		[self addSubview:self.scrollView];
		
		self.button = [UIButton buttonWithType:UIButtonTypeCustom];
		self.button.frame = self.bounds;
		self.button.exclusiveTouch = YES;
		
		[self.button addTarget:self action:@selector(animateTowardsNextRow) forControlEvents:UIControlEventTouchDown];
		[self.button addTarget:self action:@selector(animateToNextRow) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.button];
		
		UIFont *font = [UIFont systemFontOfSize:12.0f];
		NSString *titleString;
		UITextAlignment alignment;
		NSInteger offset;
		if (type == kHorizontalPickerTypeGrid) {
			titleString = @"Grid";
			alignment = UITextAlignmentRight;
			offset = frame.size.width-[titleString sizeWithFont:font].width-20;
		} else if (type == kHorizontalPickerTypePlate) {
			titleString = @"Plate";
			alignment = UITextAlignmentLeft;
			offset = 20;
		}
		if (titleString) {
			self.title = [[[UILabel alloc] initWithFrame:CGRectMake(offset, -20, [titleString sizeWithFont:font].width, 17)] autorelease];
			self.title.text = titleString;
			self.title.textAlignment = alignment;
			self.title.font = font;
			self.title.textColor = [UIColor whiteColor];
			self.title.backgroundColor = [UIColor clearColor];
			
			[self addSubview:self.title];
		}
	}
	return self;
}

-(NSInteger)numberOfRows {
	if (self.pickerType == kHorizontalPickerTypePlate) {
		return [[CURRENT_MACHINE getPlatesArray] count];
	} else if (self.pickerType == kHorizontalPickerTypeGrid) {
		return [[CURRENT_MACHINE getGridsArray] count];
	}
	return 0;
}

-(UIView *)getCurrentView {
	// Create a view with two labels in the right positions with the data
	UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 70, self.frame.size.height)];
	UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 3, 30, self.frame.size.height)];
	
	firstLabel.backgroundColor = [UIColor clearColor];
	secondLabel.backgroundColor = [UIColor clearColor];
	firstLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1];
	secondLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1];
	firstLabel.font = [UIFont systemFontOfSize:17.0f];
	secondLabel.font = [UIFont systemFontOfSize:14.0f];
	firstLabel.adjustsFontSizeToFitWidth = YES;
	secondLabel.adjustsFontSizeToFitWidth = YES;
	firstLabel.numberOfLines = 2;
	secondLabel.numberOfLines = 2;
	firstLabel.textAlignment = UITextAlignmentLeft;
	secondLabel.textAlignment = UITextAlignmentCenter;
	
	if (self.pickerType == kHorizontalPickerTypeGrid) {
		firstLabel.text = CURRENT_GRID.name;
		secondLabel.text = [NSString stringWithFormat:@"%d:1",[CURRENT_GRID.ratio intValue]];
	} else if (self.pickerType == kHorizontalPickerTypePlate) {
		firstLabel.text = CURRENT_PLATE.name;
		secondLabel.text = [NSString stringWithFormat:@"%d ISO",[CURRENT_PLATE.speed intValue]];
	}
	
	UIView *view = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
	view.backgroundColor = [UIColor clearColor];
	[view addSubview:firstLabel];
	[view addSubview:secondLabel];
	
	[firstLabel release];
	[secondLabel release];
	return view;
}

-(BOOL)willIncrement {
	if (self.selectedRow+1 != [self numberOfRows]) {
		return YES;
	}
	return NO;
}
		 
-(void)animateTowardsNextRow {
	if ([self numberOfRows] > 1) {
		if ([self willIncrement]) {
			[UIView animateWithDuration:0.05 animations:^{
				[self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y-3) animated:NO];
			}];
		} else {
			[UIView animateWithDuration:0.05 animations:^{
				[self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y+3) animated:NO];
			}];
		}
	}
}

-(void)animateToNextRow {
	if ([self numberOfRows] < 2) {
		return;
	}
	
	for (UIView *subview in [self.scrollView subviews]) {
		subview.tag = 1;
	}
	
	NSInteger newY;
	
	if ([self willIncrement]) {
		self.selectedRow++;
		newY = ((self.scrollView.frame.size.height*self.selectedRow)+3);
	} else {
		self.selectedRow = 0;
		newY = 0;
	}
	
	if (self.pickerType == kHorizontalPickerTypeGrid) {
		[Grid setCurrentGrid:[[CURRENT_MACHINE getGridsArray] objectAtIndex:self.selectedRow]];
	} else if (self.pickerType == kHorizontalPickerTypePlate) {
		[Plate setCurrentPlate:[[CURRENT_MACHINE getPlatesArray] objectAtIndex:self.selectedRow]];
	}
	
	UIView *newView = [self getCurrentView];
	CGRect newFrame = newView.frame;
	newFrame.origin.y = newY;
	newView.frame = newFrame;
	
	[self.scrollView addSubview:newView];
	
	[UIView animateWithDuration:0.3 animations:^{
		[Core update];
		[self.scrollView setContentOffset:CGPointMake(0, newY) animated:NO];
	} completion:^(BOOL finished) {
		for (UIView *subview in [self.scrollView subviews]) {
			if (subview.tag == 1) {
				[subview removeFromSuperview];
			}
		}
	}];
}

@end
