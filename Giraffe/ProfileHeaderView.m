//
//  ProfileHeaderView.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "ProfileHeaderButton.h"
#import <QuartzCore/QuartzCore.h>

#define POSITIONS 4
#define LINE_POSITION 44
#define POINT_HORIZONTAL_PORTION 0.2
#define POINT_HEIGHT 6

#define MAKE_RECT(index, width) CGRectMake(index * width, 0, width, CGRectGetHeight(self.frame))


@interface ProfileHeaderView(){
    NSMutableDictionary *_buttons;
    CGMutablePathRef _path;
    CAShapeLayer *_shapeLayer;
    NSString *_selectedHeader;
}

@end

@implementation ProfileHeaderView

@synthesize delegate;

- (CGPathRef) makeLineForFrame: (CGRect) frame
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p[] = {
        CGPointMake(0, LINE_POSITION), 
        CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * (1 - POINT_HORIZONTAL_PORTION) / 2, LINE_POSITION), 
        CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) / 2, LINE_POSITION - POINT_HEIGHT),
        CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * (1 + POINT_HORIZONTAL_PORTION) / 2, LINE_POSITION),
        CGPointMake(CGRectGetWidth(self.frame), LINE_POSITION)};
    
    CGPathAddLines(path, nil, p, 5);
    return path;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _buttons = [[NSMutableDictionary alloc] initWithCapacity:POSITIONS];
        
        _shapeLayer = [CAShapeLayer layer];
        
        _shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _shapeLayer.lineWidth = 1.0;
        _shapeLayer.fillColor = nil;
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

- (void) addHeader:(NSString *)title
{
    CGFloat eachWidth = CGRectGetWidth(self.frame) / POSITIONS;
    ProfileHeaderButton *button = [[ProfileHeaderButton alloc] initWithFrame:MAKE_RECT([_buttons count], eachWidth)];
    button.title = title;
    [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)]] ;
    
    [_buttons setObject:button forKey:title];
    [self addSubview:button];
    [button startLoading];
}

- (void)setNumber: (NSUInteger) number forHeader:(NSString *)title
{    
    ProfileHeaderButton *button = [_buttons objectForKey:title];
    [button setNumber:number];
}

- (void) selectHeader: (NSString *)title
{
    ProfileHeaderButton * newView = [_buttons objectForKey:title];
    
    //Animate the movement of the line
    CGPathRef newPath = [self makeLineForFrame:newView.frame];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = (__bridge id) _shapeLayer.path;
    animation.toValue = (__bridge id) newPath;
    [_shapeLayer addAnimation:animation forKey:@"shldklsd"];
    _shapeLayer.path = newPath;
    
    //Set the new view
    newView.selected = YES;
    
    //Unset the old one.
    ProfileHeaderButton * lastView = [_buttons objectForKey:_selectedHeader];
    lastView.selected = NO;
    
    //Update which of the headers is selected
    _selectedHeader = title;
}

- (void) buttonPressed: (UITapGestureRecognizer *) source
{
    [delegate didPressButton:((ProfileHeaderButton *)source.view).title];
}

@end
