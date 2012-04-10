//
//  SuperTabBarController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFNavView.h"

@interface SuperTabBarController : UIViewController <GFNavViewDelegate>

@property (nonatomic) BOOL needsLogin;
@end
