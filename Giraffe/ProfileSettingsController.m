//
//  ProfileSettingsController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSettingsController.h"
#import "Giraffe.h"
#import <QuartzCore/QuartzCore.h>


@interface ProfileSettingsController ()
@property (weak, nonatomic) IBOutlet UIImageView *myPicture;
@property (weak, nonatomic) IBOutlet UIView *ImageBorderView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation ProfileSettingsController
@synthesize myPicture;
@synthesize ImageBorderView;
@synthesize usernameLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChange:) name:GFChangePic object:nil];
    }
    return self;
}

- (void) userChange: (NSNotification *) sender
{
    PFFile *currentImage = [[PFUser currentUser] objectForKey:@"image"];
    
    [currentImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.myPicture.image = [UIImage imageWithData:data];
    }];
    self.usernameLabel.text = [PFUser currentUser].username;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundwTopShadow"]];
    self.ImageBorderView.layer.cornerRadius = 4.0;
    
    PFFile *currentImage = [[PFUser currentUser] objectForKey:@"image"];
    
    if (currentImage)
    {
        self.myPicture.image = [UIImage imageWithData:[currentImage getData]];
    }
    self.usernameLabel.text = [PFUser currentUser].username;
}

- (void)viewDidUnload
{
    [self setMyPicture:nil];
    [self setImageBorderView:nil];
    [self setUsernameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIViewController *tutorial = [[UIStoryboard storyboardWithName:@"Tutorial" bundle:nil] instantiateViewControllerWithIdentifier:@"username"];
        [self presentViewController:tutorial animated:YES completion:nil];
    }
    else if (indexPath.section == 1)
    {
        [PFUser logOut];
        UIViewController *tutorial = [[UIStoryboard storyboardWithName:@"Tutorial" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:tutorial animated:YES completion:nil];
    }
}

@end
