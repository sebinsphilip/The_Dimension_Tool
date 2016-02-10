//
//  oV.h
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "BFCropInterface.h"
#import <MediaPlayer/MediaPlayer.h>


@interface oV : UIView <UIAlertViewDelegate>
{
    UIButton *done;
    UILabel *labelSlider;
    MPMoviePlayerController * player;
    UIImageView * imgView;
    UIImageView * tutorialImageView;
    ScanButton *proceedButton;
    UILabel *distance;
    UILabel *instruction;
    UILabel *lensHeight;
    UISlider *slider;
    UIImage *maxImage;
    UIImage *minImage;
    float dist;
    float xPos1;
    float yPos1;
    double objectHeightOriginal;
    int yawChange;
    CGRect frame1;
    BOOL isRunMoreThanOnce;
    BOOL first;
}

@property CMMotionManager *motionManager;
@property (nonatomic, strong) BFCropInterface *cropper;
@property (nonatomic, strong) ViewController *vm;
@property UIImagePickerController *picker;

@end
