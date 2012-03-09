//
//  RotatingWheel.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotatingWheel.h"

@interface RotatingWheel()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RotatingWheel

@synthesize imageView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record.jpeg"]];
        self.imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)rotate:(double)points
{
    self.imageView.transform = CGAffineTransformMakeRotation(-points / self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
