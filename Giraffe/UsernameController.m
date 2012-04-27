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
#import <QuartzCore/QuartzCore.h>

@interface UsernameController ()
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UITextField *username;
- (IBAction)onDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *currentPicture;
@property (weak, nonatomic) IBOutlet UIView *pictureFrame;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *clickPromptLabel;

- (void)selectImage:(id)sender;

@end

@implementation UsernameController
@synthesize currentPicture;
@synthesize pictureFrame;
@synthesize spinner;
@synthesize warningLabel;
@synthesize okButton;
@synthesize clickPromptLabel;
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
    
    self.clickPromptLabel.font = [UIFont fontWithName:@"appetite" size:12];
    
    [self.username becomeFirstResponder];
        
    [self.currentPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)]];

    self.prompt.font = [UIFont fontWithName:@"appetite" size:18.0];
    self.username.text = [PFUser currentUser].username;
    
    self.pictureFrame.layer.cornerRadius = 12;
    
    PFFile *pic = [[PFUser currentUser] objectForKey:@"image"];
    
    if(pic)
    {
        self.clickPromptLabel.hidden = YES;
        [self.spinner startAnimating];
    }
    
    [pic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.currentPicture.image = [UIImage imageWithData:data];
        [self.spinner stopAnimating];
    }];

}

- (void)viewDidUnload
{
    [self setPrompt:nil];
    [self setUsername:nil];
    [self setCurrentPicture:nil];
    [self setPictureFrame:nil];
    [self setSpinner:nil];
    [self setWarningLabel:nil];
    [self setOkButton:nil];
    [self setClickPromptLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDone:(id)sender {
    NSUInteger usernameLength = [self.username.text length];
    
    if (usernameLength > 3 && usernameLength < 18)
    {
        [PFUser currentUser].username = self.username.text;
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            if (error)
            {
                if (error.code == kPFErrorUsernameTaken)
                {
                    self.warningLabel.text = @"Username taken";                    
                }
                else 
                {
                    self.warningLabel.text = @"Unknown error";
                }
            }
            else 
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:GFChangePic object:nil];
                [self dismissModalViewControllerAnimated:YES];
            }
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSUInteger usernameLength = [self.username.text length];
    return usernameLength > 3 && usernameLength < 18;
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
        return;
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.spinner startAnimating];
    self.clickPromptLabel.hidden = YES;

    UIGraphicsBeginImageContextWithOptions(self.currentPicture.frame.size, NO, 0.0);
    [image drawInRect:self.currentPicture.frame];
    self.currentPicture.image = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    self.currentPicture.alpha = 0.0;
    
    PFFile *serializedImage = [PFFile fileWithData:UIImagePNGRepresentation(self.currentPicture.image)];
    [serializedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[PFUser currentUser] setObject:serializedImage forKey:@"image"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.currentPicture.alpha = 1.0;
            [self.spinner stopAnimating];
        }];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectImage:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
    [sheet showInView:self.view];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger characterCount = [textField.text length] + [string length] - range.length;
        
    if (characterCount < 3)
    {
        self.warningLabel.text = @"Username is too short";
        self.okButton.enabled = NO;
    }
    else if (characterCount > 18)
    {
        self.warningLabel.text = @"Username cannot be longer than 18 characters";
        self.okButton.enabled = NO;
    }
    else 
    {
        self.warningLabel.text = @"";
        self.okButton.enabled = YES;
    }
    
    return YES;
}


@end
