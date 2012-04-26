//
//  MyDateCell.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PFObject;

@interface MyDateCell : UITableViewCell

@property (nonatomic, strong) PFObject *date;

@end
