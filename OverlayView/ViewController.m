//
//  ViewController.m
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "ViewController.h"
#import "oV.h"
#import "Constants.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface ViewController (){
    oV *overlay;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setInteger:centimetersTag forKey:@"scale"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    overlay = nil;
    [self begin];
}

// Displays the first view with the appplication, tutorial and units buttons
- (void)begin {
    
    [self removeOverlay];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    SCREEN_HEIGTH=result.height;
    SCREEN_WIDTH=result.width;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGTH)];
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIView * yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH/1.3, SCREEN_WIDTH, SCREEN_HEIGTH/2)];
    
    [yellowView setBackgroundColor:[UIColor colorWithRed:redAmount green:greenAmount blue:blueAmount alpha:alphaYellowView]];
    [self.view addSubview:yellowView];
    
    
    UIButton *applicationTextButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,2*SCREEN_HEIGTH/5+20, SCREEN_WIDTH/2,SCREEN_HEIGTH/9) ];
    [applicationTextButton addTarget:self action:@selector(initiateView) forControlEvents:UIControlEventTouchUpInside];
    applicationTextButton.layer.borderWidth = layerBorderWidth;
    applicationTextButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [applicationTextButton setTitle:@"GET DIMENSIONS" forState:UIControlStateNormal];
    [applicationTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:applicationTextButton];
    
    //button to get dimensions
    [self createButtonWithFrame:CGRectMake(SCREEN_WIDTH/3,SCREEN_HEIGTH/5, SCREEN_WIDTH/3,SCREEN_HEIGTH/6) imageName:@"white-camera-icon-png.png" andSelector:@selector(initiateView)];
    //button to select units
    [self createButtonWithFrame:CGRectMake(3*SCREEN_WIDTH/5,6.5*SCREEN_HEIGTH/8, SCREEN_WIDTH/4 - 15,SCREEN_HEIGTH/7 - 15) imageName:@"scale.png" andSelector:@selector(scaleMeasure)];
    //button to display tutorial video
    [self createButtonWithFrame:CGRectMake(SCREEN_WIDTH/8 ,6.5*SCREEN_HEIGTH/8, SCREEN_WIDTH/4,SCREEN_HEIGTH/7) imageName:@"playbutton.png" andSelector:@selector(tutorialPressed)];
    
    // Tutorial label
    [self createLabelWithFrame:CGRectMake( SCREEN_WIDTH/6 , 6.5*SCREEN_HEIGTH/8 + SCREEN_HEIGTH/7,40, 20) labelText:@"TUTORIAL"];
    // Units label
    [self createLabelWithFrame:CGRectMake( 3*SCREEN_WIDTH/4 -40, 6.5*SCREEN_HEIGTH/8 + SCREEN_HEIGTH/7, 40, 20) labelText:@"UNITS"];
    
}

//to create application,scale and tutorial buttons
- (void)createButtonWithFrame:(CGRect)frame imageName:(NSString *)title  andSelector:(SEL)selector {
    
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

//to create tutorial and unit labels
- (void)createLabelWithFrame:(CGRect)frame labelText:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [label sizeToFit];
    [self.view addSubview:label];
    
}

// To remove overlayView each time the begin function is called
- (void)removeOverlay {
    
    for (UIView *view in [appDelegate window].subviews) {
        if ([view isKindOfClass:[oV class]]) {
            [view removeFromSuperview];
        }
    }
    
}


// To display the overlayView on the picker
- (void)initiateView {
    
    // To calculate the pitch every 1/60 seconds
    motionManager =[[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval=interval;
    [motionManager startDeviceMotionUpdates ];
    
    overlay = [[oV alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    overlay.motionManager = motionManager;
    // Create a new image picker instance:
    ImagePickerViewController *picker = [[ImagePickerViewController alloc] init];
    // Set the image picker source:
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    // Hide the controls:
    picker.showsCameraControls = NO;
    picker.navigationBarHidden = NO;
    // Make camera view full screen:
    picker.wantsFullScreenLayout = YES;
    //add overlay as subview
    [picker.view addSubview:overlay];
    // Show the picker:
    [self presentViewController:picker animated:YES completion:^{
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }];
    picker.view.multipleTouchEnabled = NO;
    
}

#pragma mark
#pragma mark Tutorial

//To  play the TUTORIAL video
- (void)tutorialPressed {
    NSString *url = [[NSBundle mainBundle] pathForResource:@"TheDimensionTool" ofType:@"mp4"];
    moviePlayer =[[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:url]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    //---play movie---
    
    moviePlayer.view.frame = CGRectMake(0, 0, (SCREEN_WIDTH)*(4/3), SCREEN_HEIGTH);
    [self.view addSubview:moviePlayer.view];
    [moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    tutorialBack = [self makeButtonWithFrame:CGRectMake(20, 20, buttonWidth,buttonHeight) imageName:@"BACK.png" andSelector:@selector(tutorialBackTouchUpInside)];
}

//to create tutorial button
- (UIButton *)makeButtonWithFrame:(CGRect)frame imageName:(NSString *)title  andSelector:(SEL)selector {
    
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
    
}
#pragma mark Video Delegate

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    
    moviePlayer = [aNotification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    [tutorialBack removeFromSuperview];
}

// To stop and remove the video view when the user presses back button
- (void)tutorialBackTouchUpInside {
    
    [tutorialBack removeFromSuperview];
    [moviePlayer.view removeFromSuperview];
    [moviePlayer stop];
    
}

// To add the units' selection view
- (void)scaleMeasure {
    
    Scale * s =[[Scale alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    [self.view addSubview:s];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

