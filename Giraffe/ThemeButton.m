//
//  ThemeButtonController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeButton.h"

#define TITLE_HEIGHT 20

@interface ThemeButton()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ThemeButton

@synthesize theme=_theme, delegate, title, button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat themeSize = frame.size.width;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, themeSize - TITLE_HEIGHT - 3, themeSize, TITLE_HEIGHT)];
        self.title.font = [UIFont boldSystemFontOfSize:10];
        self.title.textColor = [UIColor grayColor];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:self.title];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)]];
    }
    return self;
}

- (void)setTheme:(ThemeItem *)theme
{
    _theme = theme;
    [self.button removeFromSuperview];
    
    CGFloat themeSize = self.frame.size.width;
    
    self.button = _theme.button;
    self.button.userInteractionEnabled = NO;
    self.button.frame = CGRectMake(TITLE_HEIGHT / 2, 4, themeSize - TITLE_HEIGHT, themeSize - TITLE_HEIGHT);
    self.button.showsTouchWhenHighlighted = YES;
    [self addSubview:self.button];

    title.text = _theme.title;
}

- (void) buttonPressed: (id) sender
{
    self.button.selected = [self.delegate themeButtonPressed:self.theme];
}

@end
