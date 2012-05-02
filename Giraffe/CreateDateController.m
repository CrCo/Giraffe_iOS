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
@property (strong, nonatomic) NSMutableArray *selectedThemes;

@property (nonatomic) NSInteger themeSideLength;
- (IBAction)createObj:(id)sender;
- (IBAction)cancel:(id)sender;

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
@synthesize themes, selectedThemes;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.themes = [NSArray arrayWithObjects:[ThemeItem itemWithTitle:@"Active"], [ThemeItem itemWithTitle:@"Adventure"], [ThemeItem itemWithTitle:@"Daytime"], [ThemeItem itemWithTitle:@"Drinks"], [ThemeItem itemWithTitle:@"Event"], [ThemeItem itemWithTitle:@"Food"], [ThemeItem itemWithTitle:@"Indoor"], [ThemeItem itemWithTitle:@"Low-Key"], [ThemeItem itemWithTitle:@"Night"], [ThemeItem itemWithTitle:@"Outdoor"], [ThemeItem itemWithTitle:@"Quick"], [ThemeItem itemWithTitle:@"Romantic"], nil];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Create Date" image:[UIImage imageNamed:@"AddDate"] tag:3];
        self.selectedThemes = [[NSMutableArray alloc] initWithCapacity:5];
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

    CGFloat themeSize = CGRectGetHeight(self.themesScroller.frame);
    
    for (int i = 0; i < [self.themes count]; i++)
    {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*themeSize, 0, themeSize, themeSize)];
        button.delegate = self;
        button.theme = [self.themes objectAtIndex:i];
        [self.themesScroller addSubview:button];
    }
    
    self.localeLabel.text = [NSString stringWithFormat:@"%@, %@", [Giraffe app].location.locality, [Giraffe app].location.administrativeArea];
    
    self.themesScroller.contentSize = CGSizeMake(self.themes.count *themeSize, themeSize);
    self.themesScroller.contentOffset = CGPointMake(25, 0);
    
    self.themeSideLength = CGRectGetHeight(self.themesPanel.frame);
    self.nextThemeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-self.themeSideLength - EXTRA_DISTANCE, 0, self.themeSideLength, self.themeSideLength)];
    [self.themesPanel addSubview:self.nextThemeImageView];
    [self setCharaterCount: self.descriptionTextView.text.length];
    [self.costView setCost:self.costSlider.value];
    
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

- (NSArray *) extractNames
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (ThemeItem *item in self.selectedThemes)
    {
        [newArray addObject:item.title];
    }
    return newArray;
}

- (IBAction) createObj:(id)sender {
    PFObject *testObject = [PFObject objectWithClassName:@"Date"];
    [testObject setObject:[NSNumber numberWithFloat:self.costSlider.value] forKey:@"cost"];
    [testObject setObject:self.descriptionTextView.text forKey:@"description"];
        
    [testObject setObject:[self extractNames] forKey:@"themes"];
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
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void) removeThemeIcon: (NSUInteger) index
{
    //Since we have a secret hidden view to the far left of the view, we need to add one.
    index += 1;
        
    //Change the visual elements
    UIImageView *selectedThemeView = [self.themesPanel.subviews objectAtIndex:index];
    
    //If we are removing the last one, we need to set the nextThemeView pointer one element back
    if (self.nextThemeImageView == selectedThemeView)
    {
        self.nextThemeImageView = [self.themesPanel.subviews objectAtIndex:index -1];
    }
    
    //Go through all elements in the view that come later and shift them to the left
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.nextThemeImageView .frame) - EXTRA_DISTANCE, 0);
    
    for (int i = index + 1; i < self.themesPanel.subviews.count; i++)
    {
        UIImageView *view = [self.themesPanel.subviews objectAtIndex:i];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.transform = transform;
        } completion:^(BOOL finished) {
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectApplyAffineTransform(view.frame, transform);
        }];
    }
    //Remove the item iteself
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        selectedThemeView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [selectedThemeView removeFromSuperview];
    }];
}

- (void) addThemeIcon: (ThemeItem *) theme
{
    CGFloat nextX = CGRectGetMaxX(self.nextThemeImageView.frame) + EXTRA_DISTANCE;
    //Create a new button
    self.nextThemeImageView = [[UIImageView alloc] initWithImage:theme.image]; 
    self.nextThemeImageView.frame = CGRectMake(nextX, 0, self.themeSideLength, self.themeSideLength);
    self.nextThemeImageView.alpha = 0.0;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.nextThemeImageView.alpha = 1.0;
    } completion: nil];
    
    [self.themesPanel addSubview:self.nextThemeImageView];
}

- (BOOL)themeButtonPressed:(ThemeItem *)theme
{
    NSUInteger indexOfTheme = [self.selectedThemes indexOfObject:theme];
    if (indexOfTheme != NSNotFound) 
    {
        //Manage the data model: the selected themes
        [self.selectedThemes removeObject:theme];
        
        [self removeThemeIcon:indexOfTheme];
    }
    else if (self.themesPanel.subviews.count <= 5)
    {
        //Manage the data model: the selected themes
        [self.selectedThemes addObject:theme];
        [self addThemeIcon:theme];
        return YES;
    }
    return NO;
}

- (void)changeCost:(UISlider *)sender
{
    [self.costView setCost:sender.value];
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
