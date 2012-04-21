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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageSpinner;

@end

@implementation ProfileSettingsController
@synthesize myPicture;
@synthesize ImageBorderView;
@synthesize imageSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
}

- (void)viewDidUnload
{
    [self setMyPicture:nil];
    [self setImageBorderView:nil];
    [self setImageSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
    [sheet showInView:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if(buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        //cancel
        return;
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIGraphicsBeginImageContextWithOptions(self.myPicture.frame.size, NO, 0.0);
    [image drawInRect:self.myPicture.frame];
    self.myPicture.image = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    self.myPicture.alpha = 0.0;
    [self.imageSpinner startAnimating];
    
    PFFile *serializedImage = [PFFile fileWithData:UIImagePNGRepresentation(self.myPicture.image)];
    [serializedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[PFUser currentUser] setObject:serializedImage forKey:@"image"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.myPicture.alpha = 1.0;
            [self.imageSpinner stopAnimating];

            [[NSNotificationCenter defaultCenter] postNotificationName:GFChangePic object:nil];
        }];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
