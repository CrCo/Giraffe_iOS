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

@synthesize timeName, userImage, description, date=_date, imageBorderView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageBorderView.layer.cornerRadius = 4.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleLike:(UIButton *)sender {
    if (sender.selected)
    {
        [self.date incrementKey:@"likes" byAmount:[NSNumber numberWithInt:-1]];
    }
    else
    {
        [self.date incrementKey:@"likes"];
    }
    [self.date saveEventually];
    sender.selected = !sender.selected;
}

- (void)setDate:(PFObject *)aDate
{
    _date = aDate;
    PFUser * user = [aDate objectForKey:@"user"];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.timeName setName:user.username];
        PFFile *serializedImage = [user objectForKey:@"image"];
        if (serializedImage)
        {
            NSLog(@"Is the image for %@ already in memory? %d", user.username, serializedImage.isDataAvailable);
            [serializedImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.userImage.image = [UIImage imageWithData:data];
            }];
        }
    }];
    
    self.description.text = [aDate objectForKey:@"description"];
    [self.timeName setDate:aDate.createdAt];
    
}

@end
