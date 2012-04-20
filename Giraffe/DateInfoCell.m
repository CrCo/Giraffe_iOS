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
    [user fetchIfNeeded];
    
    self.description.text = [aDate objectForKey:@"description"];
    [self.timeName setName:user.username];
    [self.timeName setDate:aDate.createdAt];
    
    PFFile *serializedImage = [user objectForKey:@"image"];
    if (serializedImage)
    {
        self.userImage.image = [UIImage imageWithData:[serializedImage getData]];
    }
}

@end
