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
#import <CoreLocation/CoreLocation.h>
#import "GeoLocationHandler.h"

@interface Giraffe : NSObject <GeoLocationHandlerDelegate>

@property (nonatomic, strong) ACAccountStore *accountStore;

@property (nonatomic, strong) Facebook *facebook;

@property (nonatomic, strong) CLPlacemark *location;
@property (nonatomic, strong) UIImage *myPic;


- (ACAccount *) twitter;
- (void) updateTwitter: (void (^)(BOOL)) completion;

+ (Giraffe *) app;
+ (void) kickstart;

@end
