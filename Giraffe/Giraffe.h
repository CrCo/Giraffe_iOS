//
//  Giraffe.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "FBConnect.h"

@interface Giraffe : NSObject

@property (nonatomic, strong) ACAccountStore *accountStore;

@property (nonatomic, strong) Facebook *facebook;

- (ACAccount *) twitter;
- (void) updateTwitter: (void (^)(BOOL)) completion;

+ (Giraffe *) app;

@end
