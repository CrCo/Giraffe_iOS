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
#import <Parse/Parse.h>
#import "UsernameController.h"

@interface LoginController ()

- (IBAction)facebookLogin:(id)sender;
- (IBAction)twitterLogin:(id)sender;

@end

@implementation LoginController

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

- (IBAction)facebookLogin:(id)sender {
    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects: nil] block:^(PFUser * user, NSError *error) {
        [self performSegueWithIdentifier:@"username" sender:self];
    }];
}

- (IBAction)twitterLogin:(id)sender {
    
    [PFTwitterUtils logInWithBlock: ^(PFUser *user, NSError *error) {
        [self performSegueWithIdentifier:@"username" sender:self];
    }];

}
@end
