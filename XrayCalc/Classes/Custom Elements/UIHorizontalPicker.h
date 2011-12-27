//
//  UIHorizontalPicker.h
//  XrayCalc
//
//  Created by Timothy Robb on 27/11/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _kHorizontalPickerType {
	kHorizontalPickerTypePlate = 0,
	kHorizontalPickerTypeGrid = 1
} kHorizontalPickerType;

@interface UIHorizontalPicker : UIView {
	kHorizontalPickerType pickerType;
	NSUInteger selectedRow;
	
	UIImageView *background;
	UIScrollView *scrollView;
	UIButton *button;
	
	UILabel *title;
}

@property (nonatomic, assign) kHorizontalPickerType pickerType;
@property (nonatomic, assign) NSUInteger selectedRow;

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *button;

@property (nonatomic, retain) UILabel *title;

-(id)initWithFrame:(CGRect)frame andType:(kHorizontalPickerType)type;
-(NSInteger)numberOfRows;
-(UIView *)getCurrentView;
-(void)animateTowardsNextRow;
-(void)animateToNextRow;

@end
