//
//  UsernameController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UsernameController.h"
#import "Giraffe.h"
#import <Parse/Parse.h>

@interface UsernameController ()
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UITextField *username;
- (IBAction)onDone:(id)sender;

@end

@implementation UsernameController
@synthesize prompt;
@synthesize username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.prompt.font = [UIFont fontWithName:@"appetite" size:18.0];
}

- (void)viewDidUnload
{
    [self setPrompt:nil];
    [self setUsername:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDone:(id)sender {
    [PFUser currentUser].username = self.username.text;
    [[PFUser currentUser] saveInBackground];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
