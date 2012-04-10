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
#import "Giraffe.h"

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
@property (weak, nonatomic) IBOutlet DollarsView *costView;
@property (weak, nonatomic) IBOutlet UIView *themeView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
- (IBAction)toggleLike:(id)sender;

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


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageBorderView.layer.cornerRadius = 4.0;
    PFUser *user = [self.date objectForKey:@"user"];
    self.usernameLabel.text = user.username;
    self.timeAgoLabel.text = [Giraffe timeAgo:self.date.createdAt];
    
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

- (IBAction)toggleLike:(UIButton *)sender {
    if (sender.selected)
    {
        [self.date incrementKey:@"likes" byAmount:[NSNumber numberWithInt:-1]];
    }
    else
    {
        [self.date incrementKey:@"likes"];
    }
    [self.date saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSInteger numberOfLikes = ((NSNumber *)[self.date objectForKey:@"likes"]).intValue;

        self.likedInfoLabel.text = [NSString stringWithFormat: @"%d Likes", numberOfLikes];
    }];
    
    
    sender.selected = !sender.selected;
}
@end
