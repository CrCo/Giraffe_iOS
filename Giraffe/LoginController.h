//
//  LoginController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginController;

@protocol LoginControllerDelegate <NSObject>

- (void) loginControllerFinish:(LoginController *) loginCntl;

@end


@interface LoginController : UIViewController


@property (nonatomic, weak) id<LoginControllerDelegate> delegate;

@end
