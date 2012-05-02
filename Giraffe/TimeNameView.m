//
//  TimeNameView.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeNameView.h"

#define SEP_PX 4

@interface TimeNameView()
{
    UIFont *_smallFont;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TimeNameView

@synthesize nameLabel, timeLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _smallFont = [UIFont systemFontOfSize:10];
        NSUInteger width = self.frame.size.width / 2;
        NSUInteger height = self.frame.size.height;
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.timeLabel.font = _smallFont;
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = UITextAlignmentRight;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        self.nameLabel.font = _smallFont;
        self.nameLabel.textColor = [UIColor colorWithRed:0.988 green:0.69 blue:0.251 alpha:1.0];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.timeLabel];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (NSString *) timeAgo: (NSDate *) aDate
{
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSSecondCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *components = [sysCalendar  components:unitFlags fromDate:aDate  toDate:[[NSDate alloc] init]  options:0];
    
    if (components.year > 0)
    {
        return [NSString stringWithFormat: @"%d years ago", components.year];
    }
    else if(components.month > 0)
    {
        return [NSString stringWithFormat: @"%d months ago", components.month];
    }
    else if(components.week > 0)
    {
        return [NSString stringWithFormat: @"%d weeks ago", components.week];
    }
    else if(components.day > 0)
    {
        return [NSString stringWithFormat: @"%dd ago", components.day];
    }
    else if(components.hour > 0)
    {
        return [NSString stringWithFormat: @"%dh ago", components.hour];
    }
    else if(components.hour > 0)
    {
        return [NSString stringWithFormat: @"%dm ago", components.minute];
    }
    else
    {
        return @"Mere seconds ago";
    }
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
    CGFloat width = [name sizeWithFont:_smallFont].width;
    self.nameLabel.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
    self.timeLabel.frame = CGRectMake(0, 0, self.frame.size.width - width - SEP_PX, self.frame.size.height);
}

- (void)setDate:(NSDate *)date
{
    self.timeLabel.text = [self timeAgo:date];
}

@end
