//
//  ViewController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface MainScreenController : UIViewController <UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic) BOOL needsLogin;

@end
