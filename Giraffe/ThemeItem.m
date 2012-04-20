//
//  ThemeItem.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeItem.h"

@implementation ThemeItem

@synthesize title=_title;

- (id)init: (NSString *)title
{
    self = [super init];
    if (self)
    {
        self.title = title;
    }
    return self;
}

- (UIImage *)image
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon", self.title]];
}

- (UIImage *) selectedImage
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon_selected", self.title]];
}

+ (id) itemWithTitle: (NSString *) title
{
    return [[ThemeItem alloc] init:title];
}

@end
