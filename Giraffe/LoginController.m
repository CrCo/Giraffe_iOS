//
//  LoginController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "Giraffe.h"
#import "StyleSettings.h"
#import <Parse/Parse.h>

@interface LoginController ()

- (IBAction)loginUsingFacebook:(id)sender;
- (IBAction)loginUsingTwitter:(id)sender;

@property (nonatomic, strong) NSArray *allAccounts;

@end

@implementation LoginController
@synthesize delegate,allAccounts;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)loginUsingFacebook:(id)sender {
    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects: nil] block:^(PFUser *user, NSError *error) {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Hmmmm" message:[NSString stringWithFormat:@"Something went wrong: %@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        [self.delegate loginControllerFinish:self];
    }];
}

- (IBAction)loginUsingTwitter:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Hmmmm" message:[NSString stringWithFormat:@"Something went wrong: %@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        [self.delegate loginControllerFinish:self];
    }];
}

@end
