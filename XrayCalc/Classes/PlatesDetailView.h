//
//  PlatesDetailView.h
//  XrayCalc
//
//  Created by Courtzie on 26/09/11.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatesDetailView : UITableViewController  <UITextFieldDelegate> {
    UILabel *nameLabel;
    UILabel *valueLabel;
    
    BOOL shouldCreateNew;
    BOOL shouldSave;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *valueLabel;

@property (nonatomic, assign) BOOL shouldCreateNew;
@property (nonatomic, assign) BOOL shouldSave;


@end
