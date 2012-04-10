//
//  DetailedDateController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedDateController.h"
#import "DollarsView.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "ThemeItem.h"

@interface DetailedDateController ()
@property (weak, nonatomic) IBOutlet UIView *imageBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *likedInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet DollarsView *costView;
@property (weak, nonatomic) IBOutlet UIView *themeView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation DetailedDateController
@synthesize imageBorderView;
@synthesize image;
@synthesize timeAgoLabel;
@synthesize usernameLabel;
@synthesize themeTitleLabel;
@synthesize costTitleLabel;
@synthesize locationTitleLabel;
@synthesize descriptionText;
@synthesize likedInfoLabel;
@synthesize likeButton;
@synthesize costView;
@synthesize themeView;
@synthesize locationLabel;
@synthesize date;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageBorderView.layer.cornerRadius = 4.0;
    PFUser *user = [self.date objectForKey:@"user"];
    self.usernameLabel.text = user.username;
    self.timeAgoLabel.text = [self timeAgo:self.date.createdAt];
    
    UIFont *font = [UIFont fontWithName:@"appetite" size:30.0];
    self.themeTitleLabel.font = font;
    self.costTitleLabel.font = font;
    self.locationTitleLabel.font = font;
    
    self.descriptionText.text = [self.date objectForKey:@"description"];
    self.likedInfoLabel.text = [NSString stringWithFormat: @"%@ Likes", [self.date objectForKey:@"likes"]];
    
    NSArray *themes = [self.date objectForKey:@"themes"];
    CGFloat height = CGRectGetHeight(self.themeView.frame);
    for (int i = 0; i < themes.count; i++)
    {
        ThemeItem *item = [[ThemeItem alloc] init:[themes objectAtIndex:i]];
        UIButton *button = item.button;
        button.userInteractionEnabled = NO;
        button.frame = CGRectMake(i*(height + 10), 0, height, height);
        [self.themeView addSubview:button];
    }
    
    self.locationLabel.text = [self.date objectForKey:@"location"];
    [self.costView updateView:((NSNumber *)[self.date objectForKey:@"cost"]).floatValue];
}

- (void)viewDidUnload
{
    [self setImageBorderView:nil];
    [self setImage:nil];
    [self setTimeAgoLabel:nil];
    [self setUsernameLabel:nil];
    [self setThemeTitleLabel:nil];
    [self setCostTitleLabel:nil];
    [self setLocationTitleLabel:nil];
    [self setDescriptionText:nil];
    [self setLikedInfoLabel:nil];
    [self setLikeButton:nil];
    [self setCostView:nil];
    [self setThemeView:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
