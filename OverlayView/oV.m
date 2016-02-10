//
//  oV.m
//  OverlayView
//
//  Created by user on 21/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "oV.h"

@implementation oV
UIView * tutorialView;
UIButton *go;
UIButton *gotItButton;
UIButton *tutorialButton;
UIButton *homeButton;


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        first=false;
        
        
        // Clear the background of the overlay:
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        frame.size.width=SCREEN_WIDTH;
        frame.size.height=SCREEN_HEIGTH;
        // Load the image to show in the overlay:
        UIImage *overlayGraphic = [UIImage imageNamed:@"crossfinal.png"];
        UIImageView *overlayGraphicView = [[UIImageView alloc] initWithImage:overlayGraphic];
        float xPosCrossHair = (frame.size.width - crossWidth) / 2;
        float yPosCrossHair = (frame.size.height - crossHeight) / 2;
        overlayGraphicView.frame = CGRectMake(xPosCrossHair, yPosCrossHair, crossWidth,crossHeight);
        
        //iphone 5 -yPos-86
        //ipad - ypos
        //iphone 6 -yPos-105
        
        [self addSubview:overlayGraphicView];
        //Checking the first running of the app
        isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
        if(!isRunMoreThanOnce){
            first=true;
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        tutorialButton = [self makeButtonWithFrame:CGRectMake(SCREEN_WIDTH-40,10,50,50) imageName:@"qnMark.png" andSelector:@selector(tutorialButtonTouchUpInside)];
        [self addSubview:tutorialButton];
        xPos1 = SCREEN_WIDTH /2;
        yPos1 = SCREEN_HEIGTH/1.7;
        
        
        CGRect frame = CGRectMake(-(SCREEN_WIDTH/2.5),SCREEN_HEIGTH/2,SCREEN_HEIGTH-(SCREEN_HEIGTH/4), SCREEN_WIDTH/20);
        
        //Slider
        maxImage=[UIImage imageNamed:@"maxImage.png"];
        maxImage =[maxImage stretchableImageWithLeftCapWidth:LCWidth topCapHeight:LCHeight];
        minImage=[UIImage imageNamed:@"min.png"];
        minImage =[minImage stretchableImageWithLeftCapWidth:LCWidth topCapHeight:LCHeight];
        slider = [[UISlider alloc] initWithFrame:frame];
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setUserInteractionEnabled:YES];
        slider.minimumValue = sliderMinValue;
        slider.maximumValue = sliderMaxValue;
        slider.continuous = YES;
        slider.value = sliderDefaultValue;
        slider.center = CGPointMake(self.center.x - self.frame.size.width/2.5, self.center.y);
        [slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
        minImage=nil;
        maxImage=nil;
        
        //Rotating slider to make it vertical
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * (-half));
        slider.transform=trans;
        [self addSubview:slider];
        
        //Checking the first running of the app
        if(first)
        {
            //Tutorial images for slider
            imgView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7,[self findSliderY:slider]-SCREEN_HEIGTH/4,SCREEN_WIDTH/3,SCREEN_HEIGTH/4)];
            imgView.image=[UIImage imageNamed:@"arrow.png"];
            [self addSubview:imgView];
            labelSlider=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3.6, [self findSliderY:slider]-220, 400, 60)];
            labelSlider.numberOfLines=2;
            labelSlider.text=@"Adjust the lens ht.\n~10cms less than your ht";
            labelSlider.shadowColor=[UIColor blackColor];
            labelSlider.textColor=[UIColor whiteColor];
            [labelSlider sizeToFit];
            [self addSubview:labelSlider];
            
            //done button
            done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            done.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGTH/5, 60, 30);
            [done setTitle:@"DONE" forState:UIControlStateNormal];
            [done setBackgroundColor:[UIColor greenColor]];
            [done showsTouchWhenHighlighted];
            [done buttonType];
            [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [done addTarget:self action:@selector(sliderTutorialFinish) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:done];
            
        }
        else
        {
            //App not running the first time
            [self objectBaseView];
        }
        
        lensHeight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6,[self findSliderY:slider], 100, 45)];
        lensHeight.center = CGPointMake(SCREEN_WIDTH/7,[self findSliderY:slider]);
        lensHeight.textColor = [UIColor whiteColor];
        [self UpdateScale];
        lensHeight.shadowColor = [UIColor blackColor];
        lensHeight.shadowOffset = CGSizeMake(2,2);
        lensHeight.layer.masksToBounds = NO;
        lensHeight.numberOfLines = twoLines;
        [lensHeight sizeToFit];
        [self addSubview:lensHeight];
        //end slider
        
        homeButton = [self makeButtonWithFrame:CGRectMake(10, 10,40, 40) imageName:@"home.png" andSelector:@selector(homeTouchUpInside)];
        homeButton.tag = homeButtonTag;
        [self addSubview:homeButton];
        
    }
    return self;
}
- (void)UpdateScale {
    
    int scaleTag = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"scale"];
    float scale_sliderInitValue;
    if(scaleTag == metreTag)
    {
        scale_sliderInitValue = slider.value / cmToMetre;
        lensHeight.text=[NSString stringWithFormat:@"Lens Height \n %0.3f m",scale_sliderInitValue];
    }
    else if(scaleTag == inchTag)
    {
        scale_sliderInitValue = slider.value * cmToInch;
        lensHeight.text=[NSString stringWithFormat:@"Lens Height \n %0.2f inch",scale_sliderInitValue];
    }
    else if(scaleTag == footTag)
    {
        scale_sliderInitValue = slider.value * cmToFoot;
        lensHeight.text=[NSString stringWithFormat:@"Lens Height \n %0.3f foot",scale_sliderInitValue];
    }
    else
        lensHeight.text = [NSString stringWithFormat:@"Lens Height \n %0.1f cm",slider.value];
    
}

- (void)homeTouchUpInside {
    [homeButton removeFromSuperview];
    [self removeFromSuperview];
    
    [ScanButton setNumberOfTimesPressed];
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[appDelegate window].rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)sliderTutorialFinish {
    
    //----Tutorial for pointing to base----
    [done removeFromSuperview];
    [imgView removeFromSuperview];
    [labelSlider removeFromSuperview];
    tutorialView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGTH)];
    imgView.image = [UIImage imageNamed:@"blurimg.png"];
    [tutorialView addSubview:imgView];
    
    gotItButton = [self makeButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGTH/1.5, buttonWidth, buttonHeight) imageName:@"gotit.png" andSelector:@selector(baseTutorialFinish)];
    gotItButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.5);
    [tutorialView addSubview:gotItButton];
    tutorialImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,SCREEN_HEIGTH/9,SCREEN_WIDTH/1.5,SCREEN_HEIGTH/3)];
    tutorialImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/3);
    tutorialImageView.image = [UIImage imageNamed:@"basePoint.png"];
    [tutorialView addSubview:tutorialImageView];
    [self addSubview:tutorialView];
}
- (void)baseTutorialFinish {
    [tutorialView removeFromSuperview];
    [self objectBaseView];
    
}
- (void)objectBaseView {
    [instruction removeFromSuperview];
    proceedButton = [[ScanButton alloc] initWithFrame:CGRectMake(xPos1, yPos1,buttonWidth,buttonHeight)];
    proceedButton.center = CGPointMake(xPos1, yPos1);
    // Add a target action for the button:
    [self addSubview:proceedButton];
    [proceedButton addTarget:self action:@selector(proceedButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    float xPos3 = (self.frame.size.width - baseLabelWidth) / 2.7;
    float yPos3 = ((self.frame.size.height - baseLabelHeight) / 2)-160;
    instruction=[[UILabel alloc] initWithFrame:CGRectMake(xPos3, yPos3, baseLabelWidth, baseLabelHeight)];
    instruction.textColor = [UIColor whiteColor];
    instruction.text=@"Point to object base";
    instruction.shadowColor = [UIColor blackColor];
    instruction.shadowOffset = CGSizeMake(2,2);
    instruction.layer.masksToBounds = NO;
    instruction.font = [UIFont fontWithName:@"Courier" size: 18.0];
    [instruction sizeToFit];
    [self addSubview:instruction];
    
}

- (void)proceedButtonTouchUpInside {
    //Checking the first running of the app
    if(first)
    {
        //Retake button pressed
        if ([ScanButton getNumberOfTimesPressed]%2 == firstPressed)
        {   [instruction removeFromSuperview];
            //----Tutorial for pointing to top----
            [tutorialView addSubview:imgView];
            
            [gotItButton addTarget:self action:@selector(topTutorialFinish) forControlEvents:UIControlEventTouchUpInside];
            [tutorialView addSubview:gotItButton];
            tutorialImageView.image = [UIImage imageNamed:@"toppoint.png"];
            [tutorialView addSubview:tutorialImageView];
            [tutorialView addSubview:gotItButton];
            [self addSubview:tutorialView];
            [UIView animateWithDuration:0.3f
                             animations:^
             {
                 
                 go.center= CGPointMake(xPos1+100, yPos1+24);
             }
                             completion:^(BOOL finished)
             
             {
             }
             ];
            
        }
        else{
            tutorialImageView.image = [UIImage imageNamed:@"basePoint.png"];
            [tutorialView addSubview:imgView];
            [tutorialView addSubview:tutorialImageView];
            
            instruction.text = @"Point to object base";
            [tutorialView addSubview:gotItButton];
            [self addSubview:tutorialView];
            [go removeFromSuperview];
        }
    }
    else{
        
        [self topTutorialFinish];
    }
}

- (void)topTutorialFinish {
    //Checking the first running of the app
    if(first)[proceedButton removeFromSuperview];
    instruction.text = @"";
    instruction.text = @"Point to object top";
    [instruction sizeToFit];
    [self addSubview:instruction];
    CMAttitude *attitude;
    CMDeviceMotion *motion =  _motionManager.deviceMotion;
    attitude = motion.attitude;
    double angle = attitude.pitch;
    if(angle<0)
        angle = -angle;
    if (attitude.yaw<0)
        yawChange = 0;
    else
        yawChange = 1;
    double height = slider.value;
    
    dist = tan(angle) * height;
    
    
    if ([ScanButton getNumberOfTimesPressed]%2) {
        distance = [[UILabel alloc] initWithFrame:CGRectMake(xPos1-100,yPos1+75, 300, 200)];
        distance.textColor = [UIColor whiteColor];
        distance.text = @"Distance to obj: ";
        distance.shadowColor = [UIColor blackColor];
        distance.shadowOffset = CGSizeMake(2,2);
        distance.layer.masksToBounds = NO;
        int scaleTag = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"scale"];
        float scale_dist;
        if(scaleTag == metreTag)
        {
            scale_dist = dist/cmToMetre;
            distance.text = [distance.text stringByAppendingString:[NSString stringWithFormat:@"%0.3f m",scale_dist] ];
        }
        else if(scaleTag == inchTag)
        {
            scale_dist = dist*cmToInch;
            distance.text=[distance.text stringByAppendingString:[NSString stringWithFormat:@"%0.3f inch",scale_dist] ];
        }
        else if(scaleTag == footTag)
        {
            scale_dist = dist*cmToFoot;
            distance.text = [distance.text stringByAppendingString:[NSString stringWithFormat:@"%0.3f foot",scale_dist] ];
        }
        else
            distance.text = [distance.text stringByAppendingString:[NSString stringWithFormat:@"%0.3f cm",dist ]];
        
        
        
        [distance sizeToFit];
        [self addSubview:distance];
        go = [self makeButtonWithFrame:CGRectMake(xPos1,yPos1, buttonWidth, buttonHeight) imageName:@"goButton.png" andSelector:@selector(goTouchUpInside:)];
        go.center = CGPointMake(xPos1,yPos1);
        [self addSubview:go];
        go.tag = goButtonTag;
        
        //---animation for the buttons
        [UIView animateWithDuration:0.3f
                         animations:^
         {
             
             go.center = CGPointMake(xPos1+100, yPos1+24);
         }
                         completion:^(BOOL finished)
         
         {
         }
         ];
        
        
        
    }
    //----Retake View---
    
    else{
        
        [distance removeFromSuperview];
        [go removeFromSuperview];
        instruction.text = @"Point to object base ";
        [instruction sizeToFit];
    }
    
    [tutorialImageView removeFromSuperview];
    [gotItButton removeFromSuperview];
    [imgView removeFromSuperview];
    
}

- (UIButton *)makeButtonWithFrame:(CGRect)frame imageName:(NSString *)title  andSelector:(SEL)selector {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}


-(void)tutorialButtonTouchUpInside{
    
    
    UIImageView *tutorialOverlay=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGTH)];
    tutorialOverlay.image=[UIImage imageNamed:@"tutorialAllThree.png"];
    [self addSubview:tutorialOverlay];
    [UIView animateWithDuration:10.0f
                     animations:^
     {
         self.userInteractionEnabled = NO;
         [tutorialOverlay setAlpha:0];
     }
                     completion:^(BOOL finished)
     
     {
         self.userInteractionEnabled = YES;
         [tutorialOverlay removeFromSuperview];
     }
     ];
    
    
}

//---Invoked during Slider movement------
- (void)sliderAction:(id)sender {
    
    lensHeight.center = CGPointMake(SCREEN_WIDTH/7,[self findSliderY:slider]);
    
    [self UpdateScale];
    
    [lensHeight sizeToFit];
    
}

//--Position of slider thumb--
- (float)findSliderY:(UISlider *)aSlider {
    
    float sliderRange,sliderOrigin,sliderValueToPixels,correctionFactor=-120-(aSlider.value/30);
    sliderRange = aSlider.frame.size.height - aSlider.currentThumbImage.size.height;
    sliderOrigin = aSlider.frame.origin.y + (aSlider.currentThumbImage.size.height / 2.0);
    sliderValueToPixels = (((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue )) * sliderRange) + sliderOrigin;
    return ((0.95*((SCREEN_HEIGTH-sliderValueToPixels+correctionFactor)+SCREEN_HEIGTH/6))-20);
}

- (void)goTouchUpInside:(id)sender {
    
    self.cropper = nil;
    for (UIView *anyView in self.subviews) {
        if (anyView.tag != goButtonTag || anyView.tag != homeButtonTag ) {
            [anyView removeFromSuperview];
        }
        else{
            [go setCenter:CGPointMake(xPos1+600, yPos1-600)];
        }
    }
    self.cropper = [[BFCropInterface alloc]initWithFrame:self.bounds andImage:nil];
    
    CMAttitude *attitude;
    CMDeviceMotion *motion =  _motionManager.deviceMotion;
    attitude = motion.attitude;
    double angle = attitude.pitch;
    
    if(angle<0)
        angle = -angle;
    double cameraLensHeight = slider.value;
    if(((attitude.yaw<0) && (yawChange == 0))||(attitude.yaw>0 && (yawChange == 1)))
    {
        
        objectHeightOriginal = cameraLensHeight - (dist / tan(angle));
        
    }
    else{
        
        objectHeightOriginal = cameraLensHeight + (dist / tan(angle));
    }
    
    if(objectHeightOriginal <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Oops"
                                    message:@"You must have missed something \nPlease try again"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    }
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.objectHeightOriginal = objectHeightOriginal;
    
    [self addSubview:self.cropper];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self homeTouchUpInside];
}


@end
