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
@property (weak, nonatomic) IBOutlet UIView *shuttleView;
@property (weak, nonatomic) IBOutlet UILabel *signupMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation LoginController
@synthesize shuttleView;
@synthesize signupMessage;
@synthesize activity;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.signupMessage.font = [UIFont fontWithName:@"appetite" size:16];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setShuttleView:nil];
    [self setSignupMessage:nil];
    [self setActivity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)request:(PF_FBRequest *)request didLoad:(NSDictionary *)result
{
    [PFUser currentUser].username = [result objectForKey:@"name"];
    [self performSegueWithIdentifier:@"username" sender:self];
}

- (void) shuttleMessage
{
    [self.activity startAnimating];
    [UIView animateWithDuration:0.75 animations:^{
        self.shuttleView.transform = CGAffineTransformMakeTranslation(-320, 0);
    } completion:^(BOOL finished) {
        self.shuttleView.frame = CGRectApplyAffineTransform(self.shuttleView.frame, self.shuttleView.transform);
        self.shuttleView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)facebookLogin:(id)sender {
    [self shuttleMessage];
    [PFFacebookUtils logInWithPermissions:[NSArray array] block:^(PFUser * user, NSError *error)
    {
        //Once we are logged in get the username of this person from Facebook.
        [[PFFacebookUtils facebook] requestWithGraphPath:@"me" andDelegate:self];
    }];
}

- (IBAction)twitterLogin:(id)sender {
    [self shuttleMessage];
    [PFTwitterUtils logInWithBlock: ^(PFUser *user, NSError *error) {
        [PFUser currentUser].username = [[PFTwitterUtils twitter] screenName];
        [self performSegueWithIdentifier:@"username" sender:self];
    }];

}
@end
