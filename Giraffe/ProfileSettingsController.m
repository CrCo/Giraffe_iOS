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

@end

@implementation ProfileSettingsController
@synthesize myPicture;
@synthesize ImageBorderView;

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
}

- (void)viewDidUnload
{
    [self setMyPicture:nil];
    [self setImageBorderView:nil];
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
    self.myPicture.image = image;
    PFFile *serializedImage = [PFFile fileWithData:UIImagePNGRepresentation(image)];
    [serializedImage save];
    [[PFUser currentUser] setObject:serializedImage forKey:@"image"];
    [[PFUser currentUser] save];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
