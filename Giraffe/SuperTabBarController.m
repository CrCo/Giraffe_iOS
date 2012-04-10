//
//  SuperTabBarController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SuperTabBarController.h"
#import "MainScreenController.h"
#import "CreateDateController.h"
#import "GFNavView.h"
#import "TutorialViewController.h"
#import "Giraffe.h"

@interface SuperTabBarController ()

@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, strong) GFNavView *navView;
@property (nonatomic, strong) UIViewController *main;

@end

@implementation SuperTabBarController

@synthesize currentController, navView, main;

- (id)init
{
    self = [super init];
    if (self) {
        UIViewController *make = [[UIStoryboard storyboardWithName:@"MakeDate" bundle:nil] instantiateInitialViewController];
        [self addChildViewController:make];
        self.main = [[UIStoryboard storyboardWithName:@"MainScreen" bundle:nil] instantiateInitialViewController];
        [self addChildViewController:self.main];
        UIViewController *profile = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
        [self addChildViewController:profile];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDate:) name:GFCreatedDate object:nil];
        
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void) newDate:(id) sender
{
    [self didSelectForController:self.main];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentController= [self.childViewControllers objectAtIndex:1];
    [self.view addSubview:self.currentController.view];
    [self.currentController didMoveToParentViewController:self];
    
    self.navView = [[GFNavView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 134, 320, 134)];
    self.navView.delegate = self;
    [self.navView setControllers: self.childViewControllers];
    [self.view addSubview:self.navView];
            
}

- (void) didSelectForController :(UIViewController *)controller
{
    if (self.currentController != controller)
    {
        [self transitionFromViewController:self.currentController toViewController:controller duration:1.0 options:0 animations:nil completion:^(BOOL finished) {
            [controller didMoveToParentViewController:self];
            self.currentController = controller;
            [self.view addSubview:self.navView];
        }];        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
