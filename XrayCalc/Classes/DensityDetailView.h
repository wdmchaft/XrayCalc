//
//  DensityDetailView.h
//  XrayCalc
//
//  Created by Courtzie on 26/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DensityDetailView : UITableViewController <UITextFieldDelegate> {
    UILabel *minLabel;
    UILabel *maxLabel;
    UILabel *initialLabel;
    
    BOOL shouldCreateNew;
    BOOL shouldSave;
}

@property (nonatomic, retain) UILabel *minLabel;
@property (nonatomic, retain) UILabel *maxLabel;
@property (nonatomic, retain) UILabel *initialLabel;

@property (nonatomic, assign) BOOL shouldCreateNew;
@property (nonatomic, assign) BOOL shouldSave;

@end
