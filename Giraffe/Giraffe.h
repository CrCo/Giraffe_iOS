//
//  Giraffe.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define GFCreatedDate @"GF_CREATE_DATE"

#import <CoreLocation/CoreLocation.h>
#import "GeoLocationHandler.h"
#import <Parse/Parse.h>

@interface Giraffe : NSObject <GeoLocationHandlerDelegate>

@property (nonatomic, strong) CLPlacemark *location;

+ (Giraffe *) app;
+ (void) kickstart;

@end
