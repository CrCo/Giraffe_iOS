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
#import "ThemeButton.h"
#import "TimeNameView.h"

@interface DetailedDateController ()
{
    UIFont *_font;

}
@property (weak, nonatomic) IBOutlet UIView *imageBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet TimeNameView *timeName;
@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *likedInfoLabel;
@property (weak, nonatomic) IBOutlet DollarsView *costIconView;
@property (weak, nonatomic) IBOutlet UIView *themeIconView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
- (IBAction)toggleLike:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailedDateController
@synthesize tableView;
@synthesize themeIconView;
@synthesize costIconView;
@synthesize imageBorderView;
@synthesize image;
@synthesize timeName;
@synthesize themeTitleLabel;
@synthesize costTitleLabel;
@synthesize locationTitleLabel;
@synthesize descriptionText;
@synthesize likedInfoLabel;
@synthesize locationLabel;
@synthesize date;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _font = [UIFont fontWithName:@"appetite" size:16.0]; 
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [self.date objectForKey:@"user"];
    [user fetchIfNeeded];
    self.imageBorderView.layer.cornerRadius = 4.0;
    
    PFFile *serializedImage = [user objectForKey:@"image"];
    if (image)
    {
        self.image.image = [UIImage imageWithData:[serializedImage getData]];
    }
    [self.timeName setName:user.username];
    [self.timeName setDate:self.date.createdAt];
    
    self.descriptionText.text = [self.date objectForKey:@"description"];
    CGFloat sizeDifference = self.descriptionText.contentSize.height;
    CGRect frame = self.tableView.tableHeaderView.frame;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + sizeDifference);
    
    //Set up the footer (take up remainder of space)
    self.likedInfoLabel.text = [NSString stringWithFormat: @"%@ Likes", [self.date objectForKey:@"likes"]];
}

- (void)viewDidUnload
{
    [self setImageBorderView:nil];
    [self setImage:nil];
    [self setTimeName:nil];
    [self setThemeTitleLabel:nil];
    [self setCostTitleLabel:nil];
    [self setLocationTitleLabel:nil];
    [self setDescriptionText:nil];
    [self setLikedInfoLabel:nil];
    [self setCostIconView:nil];
    [self setThemeIconView:nil];
    [self setLocationLabel:nil];
    [self setTableView:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) 
    {
        return 70;
    }
    else 
    {
        return 40;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ThemeDatePartView" owner:self options:nil] objectAtIndex:0];
        self.themeTitleLabel.font = _font;
        NSArray *themes = [self.date objectForKey:@"themes"];
        CGFloat height = CGRectGetHeight(self.themeIconView.frame);
        for (int i = 0; i < themes.count; i++)
        {
            ThemeItem *item = [[ThemeItem alloc] init:[themes objectAtIndex:i]];
            ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*height, 0, height, height)];
            button.theme = item;
            [self.themeIconView addSubview:button];
        }
    }
    else if (indexPath.row == 1)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CostDatePartView" owner:self options:nil] objectAtIndex:0];
        self.costTitleLabel.font = _font;
        [self.costIconView setCost:((NSNumber *)[self.date objectForKey:@"cost"]).floatValue];

    }
    else
    {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"LocationDatePartView" owner:self options:nil] objectAtIndex:0];
        self.locationTitleLabel.font = _font;
        
        self.locationLabel.text = [self.date objectForKey:@"location"];
    }

    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //One extra to fill remaining space
    return 3;
}

@end
