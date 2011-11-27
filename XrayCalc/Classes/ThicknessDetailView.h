//
//  ThicknessDetailView.h
//  XrayCalc
//
//  Created by MiniServe on 26/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThicknessDetailView : UITableViewController <UITextFieldDelegate> {
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
