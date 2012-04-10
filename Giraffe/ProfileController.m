//
//  ProfileController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UIButton *datesTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *herdNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *herdTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *newsNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *newsTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *likedNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *likedTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *datesNumberButton;
@end

@implementation ProfileController
@synthesize datesTitleButton;
@synthesize herdNumberButton;
@synthesize herdTitleButton;
@synthesize newsNumberButton;
@synthesize newsTitleButton;
@synthesize likedNumberButton;
@synthesize likedTitleButton;
@synthesize datesNumberButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"ProfileButton"] tag:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *font = [UIFont fontWithName:@"appetite" size:30.0];

    self.datesNumberButton.titleLabel.font = font;
    self.herdNumberButton.titleLabel.font = font;
    self.newsNumberButton.titleLabel.font = font;
    self.likedNumberButton.titleLabel.font = font;

    font = [UIFont fontWithName:@"appetite" size:14.0];    
    self.herdTitleButton.titleLabel.font = font;
    self.newsTitleButton.titleLabel.font = font;
    self.datesTitleButton.titleLabel.font = font;
    self.likedTitleButton.titleLabel.font = font;
    
    
    self.datesNumberButton.selected = YES;
    self.datesTitleButton.selected = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWShadow"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBarLogo"]];
}

- (void)viewDidUnload
{
    [self setDatesNumberButton:nil];
    [self setDatesTitleButton:nil];
    [self setHerdNumberButton:nil];
    [self setHerdTitleButton:nil];
    [self setNewsNumberButton:nil];
    [self setNewsTitleButton:nil];
    [self setLikedNumberButton:nil];
    [self setLikedTitleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
