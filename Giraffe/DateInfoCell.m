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

@synthesize timeLabel, username, userImage, description, date=_date, imageBorderView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    self.username.text = ((PFUser *)[[aDate objectForKey:@"user"] fetchIfNeeded]).username;
    self.description.text = [aDate objectForKey:@"description"];
    self.timeLabel.text = [Giraffe timeAgo:aDate.createdAt];

}



@end
