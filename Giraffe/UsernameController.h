//
//  UsernameController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface UsernameController : UIViewController

@property (nonatomic, weak) id<LoginControllerDelegate> delegate;

@end
