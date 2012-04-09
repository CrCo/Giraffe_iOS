//
//  DateInfoCell.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateInfoCell.h"

@implementation DateInfoCell

@synthesize timeLabel, username, userImage, description, liked;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
