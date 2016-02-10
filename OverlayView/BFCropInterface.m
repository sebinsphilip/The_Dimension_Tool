//
//  BFCropInterface.m
//  OverlayView
//
//  Created by user on 22/04/15.
//  Copyright (c) 2015 user. All rights reserved.
//
#import "BFCropInterface.h"

#import <QuartzCore/QuartzCore.h>


#define IMAGE_CROPPER_OUTSIDE_STILL_TOUCHABLE 40.0f
#define IMAGE_CROPPER_INSIDE_STILL_EDGE 20.0f

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

@implementation BFCropInterface

UIButton * scaleButton;
UIButton *scaleSelect;
static int afterProceedPressed = 0;
float SCREEN_HEIGTH;
float SCREEN_WIDTH;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
    
    self  =  [super initWithFrame:frame];
    
    if (self) {
        CGSize result  =  [[UIScreen mainScreen] bounds].size;
        SCREEN_HEIGTH = result.height;
        SCREEN_WIDTH = result.width;
        // Initialization code
        self.contentMode  =  UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled  =  YES;
        
        // set image to crop
        self.image  =  image;
        
        topView  =  [self newEdgeView];
        bottomView  =  [self newEdgeView];
        leftView  =  [self newEdgeView];
        rightView  =  [self newEdgeView];
        topLeftView  =  [self newCornerView];
        topRightView  =  [self newCornerView];
        bottomLeftView  =  [self newCornerView];
        bottomRightView  =  [self newCornerView];
        
        [self initialCropView];
    }
    
    // Initializing tutorial button
    tutorialButton = [self makeButtonWithFrame:CGRectMake(SCREEN_WIDTH-60, 10,50,50) imageName:@"qnMark.png" andSelector:@selector(tutorialButtonTouchUpInside)];
    
    [self intructionToFitInFrame];
    [self initializeObjectDimensions];
    [self insertScaleImage];
    //Initializing Proceed button
    proceedButton  =  [self makeButtonWithFrame:CGRectMake(self.cropView.center.x,self.cropView.center.y, buttonWidth,buttonHeight) imageName:@"goButton.png" andSelector:@selector(proceedButtonTouchUp:)];
    homeButton  =  [self makeButtonWithFrame:CGRectMake(10, 10, 40,40) imageName:@"home.png" andSelector:@selector(homeButtonTouchUpInside)];
    tutorialView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGTH)];
    
    isRunMoreThanOnce  =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
    if(!isRunMoreThanOnce)
    {
        [self ifRunFirstTimeWithFrame:frame];
    }
    return self;
}

// Instruction asking user to fit the object in the frame
- (void)intructionToFitInFrame {
    
    label = [[UILabel alloc]init];
    label.text = @"Fit the object in the frame then PROCEED";
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(2,2);
    label.layer.masksToBounds = NO;
    [label sizeToFit];
    label.center = CGPointMake(SCREEN_WIDTH/2, 70);
    [self addSubview:label];
}

// Initializing object height and width
- (void)initializeObjectDimensions {
    
    
    float xPOSh  = self.cropView.center.x+self.cropView.frame.size.width/2 +10;
    float yPOSh  = self.cropView.center.y;
    
    objHeight = [[UILabel alloc] initWithFrame:CGRectMake(xPOSh, yPOSh, 75, 30)];
    objHeight.text = [NSString stringWithFormat:@" "];
    objHeight.textColor = [UIColor whiteColor];
    
    CGAffineTransform trans  =  CGAffineTransformMakeRotation(M_PI *half);
    objHeight.transform = trans;
    
    float xPOSw  =  self.cropView.center.x;
    float yPOSw  = self.cropView.center.y + self.cropView.frame.size.height/2+ 5;
    objWidth = [[UILabel alloc] initWithFrame:CGRectMake(xPOSw, yPOSw, 75, 30)];
    objWidth.text = [NSString stringWithFormat:@" "];
    objWidth.textColor = [UIColor whiteColor];
    
}

// Inserting a scale button to change unit
- (void)insertScaleImage {
    
    UIImage *scaleImage = [UIImage imageNamed:@"scaleWhite.png"];
    scaleButton  =  [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20,10, 40, 40)];
    [scaleButton addTarget:self action:@selector(scaleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [scaleButton setBackgroundImage:scaleImage forState:UIControlStateNormal];
    [self addSubview:scaleButton];
    scaleButton.hidden = YES;
    
}

// To display the guide running for the first time
- (void)ifRunFirstTimeWithFrame: (CGRect)frame  {
    
    [self addSubview:tutorialView];
    imageView  =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imageView.image  =  [UIImage imageNamed:@"blurimg.png"];
    [tutorialView addSubview:imageView];
    tutorialImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,SCREEN_HEIGTH/9,SCREEN_WIDTH/1.5,SCREEN_HEIGTH/3)];
    tutorialImageView.image  =  [UIImage imageNamed:@"tutorialFrameObject.png"];
    tutorialImageView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/3);
    [tutorialView addSubview:tutorialImageView];
    gotItButton  =  [self makeButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGTH/1.5, buttonWidth, buttonHeight) imageName:@"gotit.png" andSelector:@selector (gotItButtonTouchUpInside)];
    gotItButton.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/1.5);
    [tutorialView addSubview:gotItButton];
    
}

- (UIButton *)makeButtonWithFrame:(CGRect)frame imageName:(NSString *)title  andSelector:(SEL)selector {
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
    
}

- (void)scaleSelectTouchUpInside {
    
    [self updateDimensionsToSelectedUnit];
    [scaleSelect removeFromSuperview];
}

- (void)scaleTouchUpInside {
    
    Scale * s  = [[Scale alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGTH)];
    [scaleSelect removeFromSuperview];
    scaleSelect = [[UIButton alloc]initWithFrame:CGRectMake(0,0,buttonWidth ,buttonHeight)];
    [scaleSelect setBackgroundImage:[UIImage imageNamed:@"goButton"] forState:UIControlStateNormal];
    scaleSelect.center = self.cropView.center;
    [scaleSelect addTarget:self action:@selector(scaleSelectTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scaleSelect];
    [self addSubview:s];
    [self updateDimensionsToSelectedUnit];
    
}

- (void)updateDimensionsToSelectedUnit {
    int scaleTag  =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"scale"];
    float scaledObjHeight;
    float scaledObjWidth;
    switch (scaleTag) {
        case metreTag:
        {
            scaledObjHeight  =  self.objectHeightOriginal / cmToMetre;
            scaledObjWidth  =  self.objectWidthOriginal / cmToMetre;
            objHeight.text = [NSString stringWithFormat:@"Height: %.4f m",scaledObjHeight];
            objWidth.text = [NSString stringWithFormat:@"Width: %.4f m",scaledObjWidth];
            break;
        }
        case centimetersTag:
        {
            scaledObjHeight = self.objectHeightOriginal;
            scaledObjWidth = self.objectWidthOriginal;
            objHeight.text = [NSString stringWithFormat:@"Height: %.2f cm",scaledObjHeight];
            objWidth.text = [NSString stringWithFormat:@"Width: %.2f cm",scaledObjWidth];
            break;
        }
        case inchTag:
        {
            scaledObjHeight  =  self.objectHeightOriginal * cmToInch;
            scaledObjWidth  =  self.objectWidthOriginal * cmToInch;
            objHeight.text = [NSString stringWithFormat:@"Height: %.2f inch",scaledObjHeight];
            objWidth.text = [NSString stringWithFormat:@"Width: %.2f inch",scaledObjWidth];
            break;
        }
        case footTag:
        {
            scaledObjHeight  =  self.objectHeightOriginal * cmToFoot;
            scaledObjWidth  =  self.objectWidthOriginal * cmToFoot;
            objHeight.text = [NSString stringWithFormat:@"Height: %.3f foot ",scaledObjHeight];
            objWidth.text = [NSString stringWithFormat:@"Width: %.3f foot",scaledObjWidth];
            break;
        }
        default:  break;
    }
    [objHeight sizeToFit];
    [objWidth sizeToFit];
}

// Tutorial removed from view
- (void)gotItButtonTouchUpInside {
    
    [tutorialView removeFromSuperview];
    
}

// Go to initial view in viewController
- (void)homeButtonTouchUpInside {
    
    [homeButton removeFromSuperview];
    [self removeFromSuperview];
    [ScanButton setNumberOfTimesPressed];
    AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window].rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

// Display guide to fit object into the frame
- (void)tutorialButtonTouchUpInside {
    
    UIImageView *tutorialOverlay = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,SCREEN_HEIGTH/9,SCREEN_WIDTH,SCREEN_WIDTH/1.4)];
    tutorialOverlay.center  =  CGPointMake(self.frame.size.width/2,self.frame.size.height/2 );
    tutorialOverlay.image = [UIImage imageNamed:@"tutorialFrameObject.png"];
    [self addSubview:tutorialOverlay];
    [UIView animateWithDuration:5.0f
                     animations:^
     {
         self.userInteractionEnabled  =  NO;
         [tutorialOverlay setAlpha:0];
     }
                     completion:^(BOOL finished)
     
     {
         self.userInteractionEnabled  =  YES;
         [tutorialOverlay removeFromSuperview];
     }
     ];
    
}

- (void) proceedButtonTouchUp:(id)sender {
    
    afterProceedPressed++;
    scaleButton.hidden = NO;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunMoreThanOnce"];
        [[NSUserDefaults standardUserDefaults ]synchronize];
    }
    
    AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.objectHeightOriginal  =  appDelegate.objectHeightOriginal;
    ratio  =  self.objectHeightOriginal / self.cropView.frame.size.height;
    self.objectWidthOriginal =  ratio * self.cropView.frame.size.width ;
    [self updateDimensionsToSelectedUnit];
    [self dimensionPositionAlignment];
    [self addSubview:objHeight];
    [self addSubview:objWidth];
    label.center  =  CGPointMake(SCREEN_WIDTH/2, 70);
    if(SCREEN_WIDTH<ipadScreenWidth){
        label.text  =  @"Measure the dimensions of any object \n at the same distance";
        label.numberOfLines = 2;
    }
    else
        label.text  =  @"Measure the dimensions of any object at the same distance";
    [label sizeToFit];
    [proceedButton removeFromSuperview];
    
}

- (void)initialCropView {
    CGFloat width;
    CGFloat height;
    CGFloat x;
    CGFloat y;
    
    width   =  self.frame.size.width / 4 * 3;
    height  =  self.frame.size.height / 4 * 3;
    x       =  (self.frame.size.width - width) / 2;
    y       =  (self.frame.size.height - height) / 2;
    UIView* cropView  =  [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    cropView.autoresizingMask  =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cropView.layer.borderColor  =  [[UIColor whiteColor] CGColor];
    cropView.layer.borderWidth  =  1.0;
    cropView.backgroundColor  =  [UIColor clearColor];
    
    UIImage *nodeImage  =  [UIImage imageNamed:@"node.png"];
    UIImageView *tlnode  =  [[UIImageView alloc]initWithImage:nodeImage];
    UIImageView *trnode  =  [[UIImageView alloc]initWithImage:nodeImage];
    UIImageView *blnode  =  [[UIImageView alloc]initWithImage:nodeImage];
    UIImageView *brnode  =  [[UIImageView alloc]initWithImage:nodeImage];
    tlnode.frame  =  CGRectMake(cropView.bounds.origin.x - 13, cropView.bounds.origin.y -13, 26, 26);
    trnode.frame  =  CGRectMake(cropView.frame.size.width - 13, cropView.bounds.origin.y -13, 26, 26);
    blnode.frame  =  CGRectMake(cropView.bounds.origin.x - 13, cropView.frame.size.height - 13, 26, 26);
    brnode.frame  =  CGRectMake(cropView.frame.size.width - 13, cropView.frame.size.height - 13, 26, 26);
    
    tlnode.autoresizingMask  =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    trnode.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    blnode.autoresizingMask  =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    brnode.autoresizingMask  =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [cropView addSubview:tlnode];
    [cropView addSubview:trnode];
    [cropView addSubview:blnode];
    [cropView addSubview:brnode];
    
    self.cropView  =  cropView;
    [self addSubview:self.cropView];
    
    [self updateBounds];
}

#pragma mark - setters

//Set a shadow around the frame
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor  =  shadowColor;
    topView.backgroundColor  =  _shadowColor;
    bottomView.backgroundColor  =  _shadowColor;
    leftView.backgroundColor  =  _shadowColor;
    rightView.backgroundColor  =  _shadowColor;
    topLeftView.backgroundColor  =  _shadowColor;
    topRightView.backgroundColor  =  _shadowColor;
    bottomLeftView.backgroundColor  =  _shadowColor;
    bottomRightView.backgroundColor  =  _shadowColor;
}


- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor  =  borderColor;
    self.cropView.layer.borderColor  =  _borderColor.CGColor;
}

#pragma mark - motion

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self updateDimensionsToSelectedUnit];
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches  =  [event allTouches];
    currentTouches  =  oneTouch;
    isPanning  =  NO;
    CGFloat insetAmount  =  IMAGE_CROPPER_INSIDE_STILL_EDGE;
    
    CGPoint touch  =  [[allTouches anyObject] locationInView:self];
    if (CGRectContainsPoint(CGRectInset(self.cropView.frame, insetAmount, insetAmount), touch)) {
        isPanning  =  YES;
        panTouch  =  touch;
        return;
    }
    
    CGRect frame  =  self.cropView.frame;
    CGFloat x  =  touch.x;
    CGFloat y  =  touch.y;
    
    currentDragView  =  nil;
    
    if (CGRectContainsPoint(CGRectInset(topLeftView.frame, -insetAmount, -insetAmount), touch)) {
        currentDragView  =  topLeftView;
        
        if (CGRectContainsPoint(topLeftView.frame, touch)) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin  =  touch;
        }
    }
    else if (CGRectContainsPoint(CGRectInset(topRightView.frame, -insetAmount, -insetAmount), touch)) {
        currentDragView  =  topRightView;
        
        if (CGRectContainsPoint(topRightView.frame, touch)) {
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin.y  =  y;
            frame.size.width  =  x - CGOriginX(frame);
        }
    }
    else if (CGRectContainsPoint(CGRectInset(bottomLeftView.frame, -insetAmount, -insetAmount), touch)) {
        currentDragView  =  bottomLeftView;
        
        if (CGRectContainsPoint(bottomLeftView.frame, touch)) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.size.height  =  y - CGOriginY(frame);
            frame.origin.x  =  x;
        }
    }
    else if (CGRectContainsPoint(CGRectInset(bottomRightView.frame, -insetAmount, -insetAmount), touch)) {
        currentDragView  =  bottomRightView;
        
        if (CGRectContainsPoint(bottomRightView.frame, touch)) {
            frame.size.width  =  x - CGOriginX(frame);
            frame.size.height  =  y - CGOriginY(frame);
        }
    }
    else if (CGRectContainsPoint(CGRectInset(topView.frame, 0, -insetAmount), touch)) {
        currentDragView  =  topView;
        
        if (CGRectContainsPoint(topView.frame, touch)) {
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin.y  =  y;
        }
    }
    else if (CGRectContainsPoint(CGRectInset(bottomView.frame, 0, -insetAmount), touch)) {
        currentDragView  =  bottomView;
        
        if (CGRectContainsPoint(bottomView.frame, touch)) {
            frame.size.height  =  y - CGOriginY(frame);
        }
    }
    else if (CGRectContainsPoint(CGRectInset(leftView.frame, -insetAmount, 0), touch)) {
        currentDragView  =  leftView;
        
        if (CGRectContainsPoint(leftView.frame, touch)) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.origin.x  =  x;
        }
    }
    else if (CGRectContainsPoint(CGRectInset(rightView.frame, -insetAmount, 0), touch)) {
        currentDragView  =  rightView;
        
        if (CGRectContainsPoint(rightView.frame, touch)) {
            frame.size.width  =  x - CGOriginX(frame);
        }
    }
    
    self.cropView.frame  =  frame;
    
    [self updateBounds];
    
    
}

// To make the dimensions visible irrespecitve of the frame size
- (void)dimensionPositionAlignment {
    if(self.cropView.frame.size.width>(SCREEN_WIDTH/1.5)||self.cropView.frame.size.height>SCREEN_HEIGTH/1.2)
    {
        
        objHeight.center  =  CGPointMake(self.cropView.center.x+self.cropView.frame.size.width/2 -20,self.cropView.center.y);
        objWidth.center  =  CGPointMake(self.cropView.center.x, self.cropView.center.y+self.cropView.frame.size.height/2 -20);
        
    }
    else
    {
        objHeight.center  =  CGPointMake(self.cropView.center.x+self.cropView.frame.size.width/2 +30, self.cropView.center.y);
        objWidth.center  =  CGPointMake(self.cropView.center.x, self.cropView.center.y+self.cropView.frame.size.height/2 +30);
    }
    objHeight.shadowColor = [UIColor blackColor];
    objWidth.shadowColor = [UIColor blackColor];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches  =  [event allTouches];
    CGPoint touch  =  [[allTouches anyObject] locationInView:self];
    
    if (isPanning) {
        CGPoint touchCurrent  =  [[allTouches anyObject] locationInView:self];
        CGFloat x  =  touchCurrent.x - panTouch.x;
        CGFloat y  =  touchCurrent.y - panTouch.y;
        
        self.cropView.center  =  CGPointMake(self.cropView.center.x + x, self.cropView.center.y + y);
        
        panTouch  =  touchCurrent;
    }
    else if ((CGRectContainsPoint(self.bounds, touch))) {
        CGRect frame  =  self.cropView.frame;
        CGFloat x  =  touch.x;
        CGFloat y  =  touch.y;
        
        if (x > self.frame.size.width)
            x  =  self.frame.size.width;
        
        if (y > self.frame.size.height)
            y  =  self.frame.size.height;
        
        if (currentDragView  ==  topView) {
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin.y = y;
        }
        else if (currentDragView  ==  bottomView) {
            frame.size.height  =  y - CGOriginY(frame);
        }
        else if (currentDragView  ==  leftView) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.origin.x  =  x;
        }
        else if (currentDragView  ==  rightView) {
            
            frame.size.width  =  x - CGOriginX(frame);
        }
        else if (currentDragView  ==  topLeftView) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin  =  touch;
        }
        else if (currentDragView  ==  topRightView) {
            frame.size.height +=  CGOriginY(frame) - y;
            frame.origin.y  =  y;
            frame.size.width  =  x - CGOriginX(frame);
        }
        else if (currentDragView  ==  bottomLeftView) {
            frame.size.width +=  CGOriginX(frame) - x;
            frame.size.height  =  y - CGOriginY(frame);
            frame.origin.x  = x;
        }
        else if ( currentDragView  ==  bottomRightView) {
            frame.size.width  =  x - CGOriginX(frame);
            frame.size.height  =  y - CGOriginY(frame);
        }
        
        self.cropView.frame  =  frame;
    }
    
    [self updateBounds];
    
    proceedButton.center  =  self.cropView.center;
    [self dimensionPositionAlignment];
    
    if(afterProceedPressed >= firstPressed){
        self.objectWidthOriginal =  ratio*self.cropView.frame.size.width ;
        self.objectHeightOriginal  =  self.cropView.frame.size.height*ratio;
        [self updateDimensionsToSelectedUnit];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    scaleDistance  =  0;
    [scaleSelect removeFromSuperview];
    [self dimensionPositionAlignment];
    currentTouches  =  [[event allTouches] count];
    
}

- (void)constrainCropToImage {
    CGRect frame  =  self.cropView.frame;
    
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    
    BOOL change  =  NO;
    
    do {
        change  =  NO;
        
        if (CGOriginX(frame) < 0) {
            frame.origin.x  =  0;
            change  =  YES;
        }
        
        if (CGWidth(frame) > CGWidth(self.cropView.superview.frame)) {
            frame.size.width  =  CGWidth(self.cropView.superview.frame);
            change  =  YES;
        }
        
        if (CGWidth(frame) < frameMinWidth) {
            frame.size.width  =  frameMinWidth;
            change  =  YES;
        }
        
        if (CGOriginX(frame) + CGWidth(frame) > CGWidth(self.cropView.superview.frame)) {
            frame.origin.x  =  CGWidth(self.cropView.superview.frame) - CGWidth(frame);
            change  =  YES;
        }
        
        if (CGOriginY(frame) < 0) {
            frame.origin.y  =  0;
            change  =  YES;
        }
        
        if (CGHeight(frame) > CGHeight(self.cropView.superview.frame)) {
            frame.size.height  =  CGHeight(self.cropView.superview.frame);
            change  =  YES;
        }
        
        if (CGHeight(frame) < frameMinHeight) {
            frame.size.height  =  frameMinHeight;
            change  =  YES;
        }
        
        if (CGOriginY(frame) + CGHeight(frame) > CGHeight(self.cropView.superview.frame)) {
            frame.origin.y  =  CGHeight(self.cropView.superview.frame) - CGHeight(frame);
            change  =  YES;
        }
    } while (change);
    
    self.cropView.frame  =  frame;
}

//Updating the frame bounds as per user's touch
- (void)updateBounds {
    [self constrainCropToImage];
    
    CGRect frame  =  self.cropView.frame;
    CGFloat x  =  CGOriginX(frame);
    CGFloat y  =  CGOriginY(frame);
    CGFloat width  =  CGWidth(frame);
    CGFloat height  =  CGHeight(frame);
    
    CGFloat selfWidth  =  CGWidth(self.frame);
    CGFloat selfHeight  =  CGHeight(self.frame);
    
    topView.frame  =  CGRectMake(x, 0, width , y);
    
    bottomView.frame  =  CGRectMake(x, y + height, width, selfHeight - y - height);
    leftView.frame  =  CGRectMake(0, y, x + 1, height);
    rightView.frame  =  CGRectMake(x + width, y, selfWidth - x - width, height);
    
    topLeftView.frame  =  CGRectMake(0, 0, x, y);
    topRightView.frame  =  CGRectMake(x + width, 0, selfWidth - x - width, y);
    bottomLeftView.frame  =  CGRectMake(0, y + height, x, selfHeight - y - height);
    bottomRightView.frame  =  CGRectMake(x + width, y + height, selfWidth - x - width, selfHeight - y - height);
    
    [self didChangeValueForKey:@"crop"];
}

- (UIView*)newEdgeView {
    
    UIView *view  =  [[UIView alloc] init];
    view.backgroundColor  =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    [self addSubview:view];
    return view;
}

- (UIView*)newCornerView {
    UIView *view  =  [self newEdgeView];
    view.backgroundColor  =  [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    return view;
}


@end
