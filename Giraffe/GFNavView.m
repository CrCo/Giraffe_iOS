//
//  GFBottomNavView.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GFNavView.h"
#import <objc/runtime.h>

#define TAB_BODY_HEIGHT 88
#define TAP_TRANSITION_SPEED 0.4
#define OPEN_TRANSFORM CGAffineTransformMakeTranslation(0, -TAB_BODY_HEIGHT)

@implementation GFNavView

static char CONTROLLER_KEY;

@synthesize delegate;

CGAffineTransform _initialTransform;
BOOL _lastKnownStateOpen;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame) - 46, frame.size.width, frame.size.height)];
    if (self)
    {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomTab"]];
        [self addSubview:background];
        
        UIView *tabSelectionView = [[UIView alloc] initWithFrame:CGRectMake(117, 0, 86, 46)];
        tabSelectionView.userInteractionEnabled = YES;
        [tabSelectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
        [tabSelectionView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)]];
        [self addSubview:tabSelectionView];
    }
    return self;
}

- (void)setOpen:(BOOL)open
{
    if (open)
    {
        [UIView animateWithDuration:TAP_TRANSITION_SPEED animations:^{
            self.transform = OPEN_TRANSFORM;
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:TAP_TRANSITION_SPEED animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];        
    }
}

- (BOOL)isOpen
{
    return !CGAffineTransformIsIdentity(self.transform);
}

- (void)setControllers:(NSArray *)controllers
{    
    NSInteger yVal = 46 + (88 - 44) / 2;
    NSInteger xSpace = self.bounds.size.width / controllers.count - 44; 
    NSInteger xVal = xSpace;
        
    for (UIViewController *controller in controllers)
    {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xVal, yVal, 44, 44);
        objc_setAssociatedObject(button, &CONTROLLER_KEY, controller,
                                 OBJC_ASSOCIATION_ASSIGN);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:controller.tabBarItem.image forState:UIControlStateNormal];
        [self addSubview:button];
        xVal +=xSpace;        
    }
}

- (void) buttonClicked: (UIButton *) sender
{
    [self.delegate didSelectForController:objc_getAssociatedObject(sender, &CONTROLLER_KEY)];
    [self setOpen:NO];
}

- (void) didTap:(UITapGestureRecognizer *)recognizer {
    [self setOpen:!self.isOpen];
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _initialTransform = self.transform;
        _lastKnownStateOpen = self.isOpen;
    }
    else if( recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGAffineTransform resultTransform = CGAffineTransformTranslate(_initialTransform, 0, [recognizer translationInView:self].y);
        if (resultTransform.ty > -88)
        {
            self.transform = resultTransform;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //Sanity check: If the user hasn't made a move in the right direction, don't change
        //the state
        if ((_lastKnownStateOpen && self.transform.ty > -88) || (!_lastKnownStateOpen && self.transform.ty < 0))
        {
            [self setOpen:!_lastKnownStateOpen];            
        }  
        else 
        {
            [self setOpen:_lastKnownStateOpen];
        }
    }
}

@end
