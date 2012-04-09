//
//  DollarsView.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SYMBOL @"$"

#define MAKE_FRAME_FOR_INDEX(index, char_width, extra_width) CGRectMake((char_width + extra_width)* index, 0, char_width, CGRectGetHeight(self.frame))

#import "DollarsView.h"

@interface DollarsView()

@property (nonatomic, strong) UILabel *dollar1;
@property (nonatomic, strong) UILabel *dollar2;
@property (nonatomic, strong) UILabel *dollar3;
@property (nonatomic, strong) UILabel *dollar4;
@property (nonatomic, strong) UILabel *dollar5;
@end


@implementation DollarsView

@synthesize dollar1, dollar2, dollar3, dollar4, dollar5;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIFont *font = [UIFont fontWithName:@"appetite" size:CGRectGetHeight(self.frame)];
        UIColor *color = [UIColor lightGrayColor];
        UIColor *background = [UIColor clearColor];
        CGFloat theWidth = [SYMBOL sizeWithFont:font].width;        
        CGFloat extraWidth = CGRectGetWidth(self.frame) / 5 - theWidth;
        
        self.dollar1 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(0, theWidth, extraWidth)];
        self.dollar2 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(1, theWidth, extraWidth)];
        self.dollar3 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(2, theWidth, extraWidth)];
        self.dollar4 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(3, theWidth, extraWidth)];
        self.dollar5 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(4, theWidth, extraWidth)];
        
        self.dollar1.text = SYMBOL;
        self.dollar2.text = SYMBOL;
        self.dollar3.text = SYMBOL;
        self.dollar4.text = SYMBOL;
        self.dollar5.text = SYMBOL;

        self.dollar1.font = font;
        self.dollar2.font = font;
        self.dollar3.font = font;
        self.dollar4.font = font;
        self.dollar5.font = font;
        
        self.dollar1.text = SYMBOL;
        self.dollar2.text = SYMBOL;
        self.dollar3.text = SYMBOL;
        self.dollar4.text = SYMBOL;
        self.dollar5.text = SYMBOL;
        
        self.dollar1.backgroundColor = background;
        self.dollar2.backgroundColor = background;
        self.dollar3.backgroundColor = background;
        self.dollar4.backgroundColor = background;
        self.dollar5.backgroundColor = background;
        
        self.dollar1.textColor = color;
        self.dollar2.textColor = color;
        self.dollar3.textColor = color;
        self.dollar4.textColor = color;
        self.dollar5.textColor = color;
        
        [self addSubview:self.dollar1];
        [self addSubview:self.dollar2];
        [self addSubview:self.dollar3];
        [self addSubview:self.dollar4];
        [self addSubview:self.dollar5];

    }
    return self;
}

- (void) updateView: (float) value
{
    self.dollar1.transform = CGAffineTransformMakeScale(1, MIN(value, 1.0));
    self.dollar2.transform = CGAffineTransformMakeScale(1, MIN(MAX(value - 1.0, 0), 1.0));
    self.dollar3.transform = CGAffineTransformMakeScale(1, MIN(MAX(value - 2.0, 0), 1.0));
    self.dollar4.transform = CGAffineTransformMakeScale(1, MIN(MAX(value - 3.0, 0), 1.0));
    self.dollar5.transform = CGAffineTransformMakeScale(1, MIN(MAX(value - 4.0, 0), 1.0));
}

@end
