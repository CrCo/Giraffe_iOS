//
//  DollarsView.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SYMBOL @"$"

#define SYM_SEP 5
#define MAKE_FRAME_FOR_INDEX(index, char_width) CGRectMake((char_width + SYM_SEP)* index, 0, char_width, CGRectGetHeight(self.frame))
#define VAL_SEP 10


#import "DollarsView.h"

@interface DollarsView()
{
    NSArray *_values;
}

@property (nonatomic, strong) UILabel *dollar1;
@property (nonatomic, strong) UILabel *dollar2;
@property (nonatomic, strong) UILabel *dollar3;
@property (nonatomic, strong) UILabel *dollar4;
@property (nonatomic, strong) UILabel *dollar5;
@property (nonatomic, strong) UILabel *dollarvalue;
@end


@implementation DollarsView

@synthesize dollar1, dollar2, dollar3, dollar4, dollar5, dollarvalue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIFont *font = [UIFont fontWithName:@"appetite" size:CGRectGetHeight(self.frame)];
        UIColor *color = [UIColor lightGrayColor];
        UIColor *background = [UIColor clearColor];
        CGFloat theWidth = [SYMBOL sizeWithFont:font].width;        
        
        self.dollar1 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(0, theWidth)];
        self.dollar2 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(1, theWidth)];
        self.dollar3 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(2, theWidth)];
        self.dollar4 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(3, theWidth)];
        self.dollar5 = [[UILabel alloc] initWithFrame:MAKE_FRAME_FOR_INDEX(4, theWidth)];
        
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
        
        CGFloat xPosition = CGRectGetMaxX(self.dollar5.frame) + VAL_SEP;
        
        self.dollarvalue = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, self.frame.size.width - xPosition, self.frame.size.height)];
        self.dollarvalue.text = @"free";
        self.dollarvalue.font = [UIFont systemFontOfSize:12];
        self.dollarvalue.backgroundColor = background;
        self.dollarvalue.textColor = color;
        
        [self addSubview:self.dollarvalue];
        
        _values = [NSArray arrayWithObjects:@"free", @"Up to $5", @"$5 - $10", @"$10 - $25", @"$25 to $50", @"$50 and up", nil];
        
        [self setCost:0.0];
    }
    return self;
}

- (void) setCost: (float) value
{
    self.dollarvalue.text = [_values objectAtIndex:(int)(value + 0.5)];
    
    self.dollar1.alpha = value > 0.5;
    self.dollar2.alpha = value > 1.5;
    self.dollar3.alpha = value > 2.5;
    self.dollar4.alpha = value > 3.5;
    self.dollar5.alpha = value > 4.5;
}

@end
