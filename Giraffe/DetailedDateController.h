//
//  DetailedDateController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface DetailedDateController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFObject *date;

@end
