//
//  ProfileHeaderButton.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileHeaderButton.h"
#define BOTTOM_HEIGHT 20

@interface ProfileHeaderButton()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation ProfileHeaderButton

@synthesize numberLabel, titleLabel, selected=_selected, spinner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - BOTTOM_HEIGHT)];
        self.numberLabel.font = [UIFont fontWithName:@"appetite" size:30.0];
        self.numberLabel.textAlignment = UITextAlignmentCenter;
        self.numberLabel.textColor = [UIColor lightGrayColor];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.frame = self.numberLabel.frame;
        self.spinner.hidesWhenStopped = YES;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - BOTTOM_HEIGHT, frame.size.width, BOTTOM_HEIGHT)];
        self.titleLabel.font = [UIFont fontWithName:@"appetite" size:14.0];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:self.numberLabel];
        [self addSubview:self.titleLabel];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) startLoading
{
    [self.spinner startAnimating];
}

- (void)setTitle:(NSString *)title
{    
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected)
    {
        self.numberLabel.textColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.numberLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

- (NSString *) title
{
    return self.titleLabel.text;
}

- (void)setNumber:(NSUInteger)number
{
    self.numberLabel.text = [NSString stringWithFormat:@"%d", number];
    [self.spinner stopAnimating];
}

@end
