//
//  DateInfoCell.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TimeNameView.h"

@interface DateInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UIImageView *userImage;
@property (nonatomic, weak) IBOutlet UIView *imageBorderView;
@property (nonatomic, weak) IBOutlet TimeNameView *timeName;

- (IBAction)toggleLike:(UIButton *)sender;

@property (nonatomic, strong) PFObject *date;
@end
