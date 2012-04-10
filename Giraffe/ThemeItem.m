//
//  ThemeItem.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeItem.h"

@implementation ThemeItem

@synthesize title=_title, button=_button;

- (id)init: (NSString *)title
{
    self = [super init];
    if (self)
    {
        self.title = title;
    }
    return self;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Icon", self.title]] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Icon_selected", self.title]] forState:UIControlStateSelected];
    }
    return _button;
}

+ (id) itemWithTitle: (NSString *) title
{
    return [[ThemeItem alloc] init:title];
}

@end
