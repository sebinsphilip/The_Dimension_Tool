//
//  ScanButton.h
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ScanButton : UIButton {
    UIImageView *buttonImage ;
    float xPosScanButton;
    float yPosScanButton;

}

- (void)buttonPressed;
+ (int)getNumberOfTimesPressed;
+ (void)setNumberOfTimesPressed;
@end