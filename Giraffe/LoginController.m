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
#import "UsernameController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation LoginController
@synthesize delegate, twitterButton, facebookButton;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UsernameController *cntlr =  (UsernameController *) segue.destinationViewController;
    if (self.twitterButton == sender)
    {
        [PFTwitterUtils logInWithBlock: ^(PFUser *user, NSError *error) {
        }];
    }
    else if (self.facebookButton == sender) 
    {
        [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects: nil] block:^(PFUser * user, NSError *error) {
            
        }];   
    }
    cntlr.delegate = self.delegate;
}

@end
