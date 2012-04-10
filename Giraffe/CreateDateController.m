//
//  CreateDateController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateDateController.h"
#import "GFNavView.h"
#import "DollarsView.h"
#import <Parse/Parse.h>
#import "Giraffe.h"
#import "ThemeItem.h"

#define EXTRA_DISTANCE 10


@interface CreateDateController ()

@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIView *themesPanel;
@property (weak, nonatomic) IBOutlet UIScrollView *themesScroller;
@property (strong, nonatomic) UIImageView *nextThemeImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet DollarsView *costView;
@property (weak, nonatomic) IBOutlet UISlider *costSlider;
@property (strong, nonatomic) NSArray *themes;

@property (nonatomic) NSInteger themeSideLength;
- (IBAction)createObj:(id)sender;

- (IBAction) changeCost:(id)sender;

@end

@implementation CreateDateController
@synthesize localeLabel;
@synthesize characterCountLabel;
@synthesize themesPanel;
@synthesize themesScroller;
@synthesize themeSideLength;
@synthesize nextThemeImageView;
@synthesize descriptionTextView;
@synthesize costView;
@synthesize costSlider;
@synthesize themes;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.themes = [NSArray arrayWithObjects:[ThemeItem itemWithTitle:@"Active"], [ThemeItem itemWithTitle:@"Adventure"], [ThemeItem itemWithTitle:@"Daytime"], [ThemeItem itemWithTitle:@"Drinks"], [ThemeItem itemWithTitle:@"Event"], [ThemeItem itemWithTitle:@"Food"], [ThemeItem itemWithTitle:@"Indoor"], [ThemeItem itemWithTitle:@"Low-Key"], [ThemeItem itemWithTitle:@"Night"], [ThemeItem itemWithTitle:@"Outdoor"], [ThemeItem itemWithTitle:@"Quick"], [ThemeItem itemWithTitle:@"Romantic"], nil];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Create Date" image:[UIImage imageNamed:@"AddDate"] tag:3];
   }
    return self;
}

- (void) setCharaterCount: (NSUInteger) characterCount
{
    NSInteger charactersLeft = 140 - characterCount;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", charactersLeft];
    if (charactersLeft < 0)
    {
        self.characterCountLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.characterCountLabel.textColor = [UIColor lightGrayColor];
    }   
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (int i = 0; i < [self.themes count]; i++)
    {
        UIButton *button = ((ThemeItem *)[self.themes objectAtIndex:i]).button;
        button.frame = CGRectMake(i*60, 0, 60, 60);
        [button addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        [self.themesScroller addSubview:button];
    }
    
    self.localeLabel.text = [NSString stringWithFormat:@"%@, %@", [Giraffe app].location.locality, [Giraffe app].location.administrativeArea];
    
    self.themesScroller.contentSize = CGSizeMake(720, 60);
    
    self.themeSideLength = CGRectGetHeight(self.themesPanel.frame);
    self.nextThemeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.themeSideLength, self.themeSideLength)];
    [self.themesPanel addSubview:self.nextThemeImageView];
    [self setCharaterCount: self.descriptionTextView.text.length];
    [self.costView updateView:self.costSlider.value];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWShadow"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBarLogo"]];
}

- (void)viewDidUnload
{
    [self setCharacterCountLabel:nil];
    [self setThemesPanel:nil];
    [self setThemesScroller:nil];
    [self setDescriptionTextView:nil];
    [self setCostView:nil];
    [self setCostSlider:nil];
    [self setLocaleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) createObj:(id)sender {
    PFObject *testObject = [PFObject objectWithClassName:@"Date"];
    [testObject setObject:[NSNumber numberWithFloat:self.costSlider.value] forKey:@"cost"];
    [testObject setObject:self.descriptionTextView.text forKey:@"description"];
    
    NSMutableArray *allThemes = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < [self.themesScroller.subviews count]; i++)
    {
        UIButton *view = [self.themesScroller.subviews objectAtIndex:i];
        if (view.selected)
        {
            [allThemes addObject:((ThemeItem *)[self.themes objectAtIndex:i]).title];
        }
    }
    
    [testObject setObject:allThemes forKey:@"themes"];
    [testObject setObject:[PFUser currentUser] forKey:@"user"];
    [testObject setObject:[NSNumber numberWithInt:0] forKey:@"likes"];
    [testObject setObject:self.localeLabel.text forKey:@"location"];
    
    NSError *error = nil;
    [testObject save: &error];
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GFCreatedDate object:testObject];
}

- (void)selectTheme:(UIButton *)sender
{
    if (sender.selected) 
    {
        CGAffineTransform transform = CGAffineTransformIdentity;
        for (UIImageView *view in self.themesPanel.subviews)
        {
            if (!CGAffineTransformIsIdentity(transform))
            {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    view.transform = transform;
                } completion:^(BOOL finished) {
                    view.transform = CGAffineTransformIdentity;
                    view.frame = CGRectApplyAffineTransform(view.frame, transform);
                }];
            }
            else if (view.image == sender.imageView.image)
            {
                transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(view.frame) - EXTRA_DISTANCE, 0);
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    view.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }
        }
    }

    sender.selected = !sender.selected;
    if (sender.selected)
    {
        self.nextThemeImageView.image = sender.imageView.image;
        self.nextThemeImageView.alpha = 0.0;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.nextThemeImageView.alpha = 1.0;
        } completion: nil];

        self.nextThemeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nextThemeImageView.frame) + EXTRA_DISTANCE, 0, self.themeSideLength, self.themeSideLength)];
        [self.themesPanel addSubview:self.nextThemeImageView];
        
    }
}

- (void)changeCost:(UISlider *)sender
{
    [self.costView updateView:sender.value];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    
    NSString *stringToBe = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self setCharaterCount:stringToBe.length];
    
    return YES;
}

@end
