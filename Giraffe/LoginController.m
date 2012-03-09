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

@interface LoginController ()

- (IBAction)loginUsingFacebook:(id)sender;
- (IBAction)loginUsingTwitter:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *twButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LoginController
@synthesize twButton;
@synthesize label;

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
    self.label.font = FONT;
}

- (void)viewDidUnload
{
    [self setTwButton:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginUsingFacebook:(id)sender {
    [[Giraffe app].facebook authorize:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginUsingTwitter:(id)sender {
    
    [[Giraffe app] updateTwitter:^(BOOL success) {
        if(success)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self dismissModalViewControllerAnimated:YES];
              });
        }
    }];
}

@end
