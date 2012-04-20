//
//  ThemeButtonController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeButton.h"

#define ICON_PERCENT 0.4
#define MIDDLE_SPLIT_PERCENT 0.1
#define MARGIN_PERCENT 0.15

@interface ThemeButton()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation ThemeButton

@synthesize theme=_theme, delegate, title, icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat iconHeight = frame.size.height * ICON_PERCENT;
        CGFloat middleSplit = frame.size.height * MIDDLE_SPLIT_PERCENT;
        CGFloat margin = frame.size.height * MARGIN_PERCENT;
        CGFloat labelHeight = frame.size.height * (1 - ICON_PERCENT - 2*MARGIN_PERCENT - MIDDLE_SPLIT_PERCENT);
        CGFloat totalWidth = frame.size.width;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, iconHeight + margin + middleSplit, totalWidth, labelHeight)];
        self.
        self.title.font = [UIFont boldSystemFontOfSize:10];
        self.title.textColor = [UIColor grayColor];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = UITextAlignmentCenter;
        self.title.adjustsFontSizeToFitWidth = YES;
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake((totalWidth - iconHeight) / 2, margin, iconHeight, iconHeight)];
        
        [self addSubview:self.icon];        
        [self addSubview:self.title];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)]];
    }
    return self;
}

- (void)setTheme:(ThemeItem *)theme
{
    _theme = theme;
    self.icon.image = _theme.image;
    self.icon.highlightedImage = _theme.selectedImage;
    self.title.text = _theme.title;
}

- (void) buttonPressed: (id) sender
{
    self.icon.highlighted = [self.delegate themeButtonPressed:self.theme];
}

@end
