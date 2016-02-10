//
//  BFCropInterface.h
//  OverlayView
//
//  Created by user on 22/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ScanButton.h"
@interface BFCropInterface : UIImageView{
    BOOL isPanning;
    MPMoviePlayerController * player;
    NSInteger currentTouches;
    CGPoint panTouch;
    CGFloat scaleDistance;
    UIView *currentDragView;
    UIView *topView;
    UIView *bottomView;
    UIView *leftView;
    UIView *rightView;
    UIView *topLeftView;
    UIView *topRightView;
    UIView *bottomLeftView;
    UIView *bottomRightView;
    UILabel *objHeight;
    UILabel *objWidth;
    float ratio;
    UILabel *label;
    UIView * help_v;
    BOOL isRunMoreThanOnce;
    UIImageView *tutorialImageView;
    UIImageView *imageView;
    UIView *tutorialView;
    UIButton *proceedButton;
    UIButton *gotItButton;
    UIButton *tutorialButton;
    UIButton *homeButton;
  
}

    @property (nonatomic, assign) CGRect crop;
    @property (nonatomic, strong) UIView *cropView;
    @property (nonatomic, strong) UIColor *shadowColor;
    @property (nonatomic, strong) UIColor *borderColor;
    @property float objectHeightOriginal;
    @property float objectWidthOriginal;
    - (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;;
@end
