//
//  Scale.h
//  OverlayView
//
//  Created by user on 07/05/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Constants.h"
@interface Scale : UIView
@property (nonatomic, strong) IBOutlet UILabel *menuText;
@property (nonatomic, strong) IBOutlet UIView *unitMenu;
@property (nonatomic, strong) IBOutlet UIButton *unitMenuShowButton;

- (IBAction)unitMenuShow:(UIButton *)sender;
- (IBAction)unitMenuSelectionMade:(UIButton *)sender;
@end
