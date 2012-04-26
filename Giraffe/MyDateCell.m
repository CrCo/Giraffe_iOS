//
//  MyDateCell.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDateCell.h"
#import <Parse/Parse.h>
#import "TimeNameView.h"


@interface MyDateCell()

@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UILabel *likeText;
@property (nonatomic, weak) IBOutlet TimeNameView *timeName;

@end

@implementation MyDateCell

@synthesize description, likeText, timeName, date=_date;

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

- (void)setDate:(PFObject *)date
{
    _date = date;

    [date fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.description.text = [date objectForKey:@"description"];
        [self.timeName setDate:date.createdAt];
    }];
}

@end
