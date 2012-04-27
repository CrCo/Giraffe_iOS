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
{
    PF_FBRequest *usernameReq;
    PF_FBRequest *picReq;
    BOOL outstandingImageSave;
}

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

- (void) checkIfDone
{
    if( !(picReq || usernameReq || outstandingImageSave))
    {
        [self performSegueWithIdentifier:@"username" sender:self];
    }
}

-(void)request:(PF_FBRequest *)request didLoad:(id)result
{
    if (request == usernameReq)
    {
        NSString *name = [result objectForKey:@"username"];
        if (!name)
        {
            name = [result objectForKey:@"name"];
        }
        [PFUser currentUser].username = name;
        usernameReq = nil;
    }
    else if (request == picReq)
    {
        
        PFFile *profilePic = [PFFile fileWithData:result];
        [profilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[PFUser currentUser] setObject:profilePic forKey:@"image"];
            outstandingImageSave = NO;
            //If the requests have completed and any saves required have been performed
            [self checkIfDone];
        }];
        outstandingImageSave = YES;
        picReq = nil;
    }
    
    //If the requests have completed and any saves required have been performed
    [self checkIfDone];
}

//This moves the login mechanism out of view of the user, and a loading message in
-(void) shuttleMessage
{
    [self.activity startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.shuttleView.transform = CGAffineTransformMakeTranslation(-320, 0);
    } completion:^(BOOL finished) {
        self.shuttleView.frame = CGRectApplyAffineTransform(self.shuttleView.frame, self.shuttleView.transform);
        self.shuttleView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)facebookLogin:(id)sender {
    //Once we are logged in get the username of this person from Facebook.
    [PFFacebookUtils logInWithPermissions:[NSArray array] block:^(PFUser * user, NSError *error)
    {
        [self shuttleMessage];
        //Parse assigns a default username for first-time logins which should never be 
        //visible to the user. We need to perform a sanity check and if it fails, we will
        //populate the username with the username of Facebook.
        if ([[PFUser currentUser].username length] > 18)
        {
            usernameReq = [[PFFacebookUtils facebook] requestWithGraphPath:@"me" andDelegate:self];            
        }
        
        //We will first check if the user already has an images. If so, we leave it because
        //the user will probably not want it to be overwritten by the facebook value.
        PFFile *lastImage = [[PFUser currentUser] objectForKey:@"image"];
        if (!lastImage)
        {
            picReq = [[PFFacebookUtils facebook] requestWithGraphPath:@"me/picture" andDelegate:self];
        }
        
        //Call this to handle the case where we neither want to get a FB picture nor
        //username.
        [self checkIfDone];
    }];
}

- (IBAction)twitterLogin:(id)sender {
    [PFTwitterUtils logInWithBlock: ^(PFUser *user, NSError *error) {
        [self shuttleMessage];
        [PFUser currentUser].username = [[PFTwitterUtils twitter] screenName];
        
        //We will first check if the user already has an images. If so, we leave it because
        //the user will probably not want it to be overwritten by the facebook value.
        PFFile *lastImage = [[PFUser currentUser] objectForKey:@"image"];
        if (!lastImage)
        {
            TWRequest *imageRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/users/profile_image/"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[[PFTwitterUtils twitter] screenName], @"screen_name", nil] requestMethod:TWRequestMethodGET];

            [imageRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                PFFile *profilePic = [PFFile fileWithData:responseData];
                [profilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [[PFUser currentUser] setObject:profilePic forKey:@"image"];
                    outstandingImageSave = NO;
                    //If the requests have completed and any saves required have been performed
                    [self performSegueWithIdentifier:@"username" sender:self];
                }];

            }];
        }
        else 
        {
            [self performSegueWithIdentifier:@"username" sender:self];
        }
        
    }];

}
@end
