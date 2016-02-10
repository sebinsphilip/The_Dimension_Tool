//
//  ScanButton.m
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "ScanButton.h"
#import "ViewController.h"
@implementation ScanButton
static int numberOfTimesPressed =0;
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // Set button image:
        buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
        buttonImage.image = [UIImage imageNamed:@"goButton.png"];
        
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside]; // for future use
        
        [self addSubview:buttonImage];
    }
    
    xPosScanButton = SCREEN_WIDTH / 2;
    yPosScanButton = SCREEN_HEIGTH/1.7 ;
    return self;
}

+(int)getNumberOfTimesPressed{
    
    return numberOfTimesPressed;
}
+ (void) setNumberOfTimesPressed{
    numberOfTimesPressed = 0;
}
- (void)buttonPressed {
    numberOfTimesPressed++;
    
    if(numberOfTimesPressed%2)
    {
        
        buttonImage.image = [UIImage imageNamed:@"retake1.png"];
        [UIView animateWithDuration:0.3f
                         animations:^
         {
             self.center= CGPointMake(xPosScanButton-100,yPosScanButton+24);
             
         }
                         completion:^(BOOL finished){}
         
         ];
        
    }
    else
    {
        
        buttonImage.image = [UIImage imageNamed:@"goButton.png"];
        //restore animation
        [UIView animateWithDuration:0.3f
                         animations:^
         {
             self.center= CGPointMake(xPosScanButton,yPosScanButton);
             
         }
                         completion:^(BOOL finished){}
         
         ];
        
    }
    // TODO: Could toggle a button state and/or image
}

@end
