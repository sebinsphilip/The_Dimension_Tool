//
//  ViewController.h
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ImagePickerViewController.h"
#import "Scale.h"
#import "Constants.h"

float SCREEN_WIDTH, SCREEN_HEIGTH;

@interface ViewController : UIViewController<UIAlertViewDelegate>
{
    CMMotionManager *motionManager;
    AppDelegate *appDelegate;
    UIImageView *imageView;
    MPMoviePlayerController *moviePlayer;
    UIButton *tutorialBack;
}
@end

