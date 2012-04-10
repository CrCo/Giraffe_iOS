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

- (IBAction)doneEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
- (IBAction)loginUsingFacebook:(id)sender;
- (IBAction)loginUsingTwitter:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (nonatomic, strong) NSArray *allAccounts;

@end

@implementation LoginController
@synthesize twitterButton;
@synthesize facebookButton;
@synthesize usernameField;
@synthesize UsernameLabel;
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
    self.UsernameLabel.font = [UIFont fontWithName:@"appetite" size:24.0];
    [self.usernameField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setUsernameLabel:nil];
    [self setTwitterButton:nil];
    [self setFacebookButton:nil];
    [self setUsernameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginUsingFacebook:(id)sender {
    [PFFacebookUtils linkUser:[PFUser currentUser] permissions:[NSArray arrayWithObjects: nil] block:^(BOOL succeeded, NSError *error) {

        [self.delegate loginControllerFinish:self];
    }];
}

- (IBAction)loginUsingTwitter:(id)sender {
    [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
        [self.delegate loginControllerFinish:self];
    }];
}

- (IBAction)doneEditing:(id)sender {
    //We always want a user to exist
    PFUser *newUser = [PFUser user];

    newUser.username = self.usernameField.text;
    newUser.password = @"2(*^(%#HJSHFIUHOGT(&#O*GK3453563";
    NSError *err = nil;
    [newUser signUp: &err];
    if (err)
    {
        [[[UIAlertView alloc] initWithTitle:@"Problem" message:[NSString stringWithFormat: @"Error: %@", err.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}
@end
