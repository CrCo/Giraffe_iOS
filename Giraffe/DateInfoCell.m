//
//  DateInfoCell.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Giraffe.h"

@implementation DateInfoCell

@synthesize timeName, userImage, description, date=_date, imageBorderView, likeButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleLike:(UIButton *)sender {
    BOOL likedAlready = [((NSArray *)[[PFUser currentUser] objectForKey:@"likes"]) containsObject:self.date];
    if (likedAlready)
    {
        NSMutableArray *likes = [NSMutableArray arrayWithArray:[[PFUser currentUser] objectForKey:@"likes"]];
        [likes removeObject:self.date];
        [[PFUser currentUser] setObject:likes forKey:@"likes"];
    }
    else 
    {
        NSArray *likesArray = [[PFUser currentUser] objectForKey:@"likes"];
        if (likesArray)
        {
            likesArray = [likesArray arrayByAddingObject:self.date];
        }
        else
        {
            likesArray = [NSArray arrayWithObject:self.date];
        }
        
        [[PFUser currentUser] setObject:likesArray forKey:@"likes"];
    }
    [[PFUser currentUser] saveInBackground];
    [[NSNotificationCenter defaultCenter] postNotificationName:GFLikeDate object:self.date userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:!likedAlready], @"liked", nil]];
}

- (void) dateLikeChange: (NSNotification *) sender
{
    self.likeButton.selected = ((NSNumber *)[sender.userInfo objectForKey:@"liked"]).boolValue;
}

- (void)setDate:(PFObject *)aDate
{
    _date = aDate;
    
    //The wiring when instantiating the uitableviewcell from a storyboard isn't
    //done before initWithCoder is called. Thus, we need to do some of the configuration
    //later
    self.imageBorderView.layer.cornerRadius = 4.0;
    
    PFUser * user = [aDate objectForKey:@"user"];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error)
        {
            NSLog(@"Object %@ couldn't be loaded: %@", object, [error localizedDescription]);
        } 
        else {
            [self.timeName setName:user.username];
            PFFile *serializedImage = [user objectForKey:@"image"];
            if (serializedImage)
            {
                NSLog(@"Is the image for %@ already in memory? %d", user.username, serializedImage.isDataAvailable);
                [serializedImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.userImage.image = [UIImage imageWithData:data];
                }];
            }
        }
    }];
    
    self.description.text = [aDate objectForKey:@"description"];
    [self.timeName setDate:aDate.createdAt];
    self.likeButton.selected = [((NSArray *)[[PFUser currentUser] objectForKey:@"likes"]) containsObject:aDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateLikeChange:) name:GFLikeDate object:self.date];
}

@end
