//
//  Scale.m
//  OverlayView
//
//  Created by user on 07/05/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "Scale.h"

@implementation Scale

@synthesize unitMenu, menuText;
@synthesize unitMenuShowButton;
float SCREEN_WIDTH,SCREEN_HEIGHT;

- (id)initWithFrame:(CGRect)frame {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    SCREEN_WIDTH = result.width;
    SCREEN_HEIGHT = result.height;
    self.opaque = YES;
    self.layer.backgroundColor = [UIColor blackColor].CGColor;
    if (self = [super initWithFrame:frame]) {
        UIImageView * scaleBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
        scaleBackground.image = [UIImage imageNamed:@"blurimg.png"];
        [self addSubview:scaleBackground];
        
        menuText = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT/3,SCREEN_WIDTH/1.5, SCREEN_HEIGHT/12)];
        menuText.layer.borderColor = [UIColor blackColor].CGColor;
        menuText.text = @"   SELECT UNIT ";
        menuText.layer.borderWidth=scaleBorderWidth;
        [menuText setBackgroundColor:[UIColor whiteColor]];
        menuText.tag = selectorDefaultTag;
        [self addSubview:menuText];
        
        unitMenu = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, 5*SCREEN_HEIGHT/12, SCREEN_WIDTH/1.5, (SCREEN_HEIGHT/12)*4)];
        [unitMenu setBackgroundColor:[UIColor whiteColor]];
        unitMenuShowButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT/3,SCREEN_WIDTH/1.5, SCREEN_HEIGHT/12)];
        [unitMenuShowButton setImage:[UIImage imageNamed:@"dropDownButton.png"]  forState:UIControlStateNormal];
        [unitMenuShowButton addTarget:self action:@selector(unitMenuShow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unitMenuShowButton ];
        [self addSubview:unitMenu];
        
        
        UIButton *metre = [self createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/1.5,  SCREEN_HEIGHT/12) buttonTitle:@"METER"];
        metre.tag =metreTag;
        [metre addTarget:self action:@selector(unitMenuSelectionMade:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cm = [self createButtonWithFrame:CGRectMake(0, (SCREEN_HEIGHT/12), SCREEN_WIDTH/1.5,  SCREEN_HEIGHT/12) buttonTitle:@"CENTIMETER"];
        cm.tag =centimetersTag;
        [cm addTarget:self action:@selector(unitMenuSelectionMade:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *inch = [self createButtonWithFrame:CGRectMake(0, (SCREEN_HEIGHT/12)*2, SCREEN_WIDTH/1.5,  SCREEN_HEIGHT/12) buttonTitle:@"INCH"];
        inch.tag =inchTag;
        [inch addTarget:self action:@selector(unitMenuSelectionMade:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *foot = [self createButtonWithFrame:CGRectMake(0, (SCREEN_HEIGHT/12)*3, SCREEN_WIDTH/1.5,  SCREEN_HEIGHT/12) buttonTitle:@"FOOT"];
        foot.tag = footTag;
        [foot addTarget:self action:@selector(unitMenuSelectionMade:) forControlEvents:UIControlEventTouchUpInside];
        
        self.unitMenu.hidden = YES;
        [self addSubview:unitMenu];
        [unitMenu addSubview:metre];
        [unitMenu addSubview:cm];
        [unitMenu addSubview:inch];
        [unitMenu addSubview:foot];
        
    }
    
    
    return self;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame buttonTitle:(NSString *)title {
    
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth = scaleBorderWidth;
    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [button addTarget:self action:@selector(unitMenuSelectionMade:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}

- (IBAction)unitMenuShow:(UIButton *)sender
{
    
    if (sender.tag == selectorDefaultTag) {
        sender.tag = selectorPressed;
        self.unitMenu.hidden =NO;
        [sender setImage:[UIImage imageNamed:@"dropDownButton2.png"] forState:UIControlStateNormal];
    } else {
        sender.tag = selectorDefaultTag;
        self.unitMenu.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"dropDownButton.png"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)unitMenuSelectionMade:(UIButton *)sender
{
    self.menuText.text = [[NSString stringWithFormat:@"\t\t   " ] stringByAppendingString:sender.titleLabel.text];
    [self.unitMenuShowButton setImage:[UIImage imageNamed:@"dropDownButton.png"] forState:UIControlStateNormal];
    self.unitMenuShowButton.tag = selectorDefaultTag;
    self.unitMenu.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:@"scale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeFromSuperview];
    
}

@end
