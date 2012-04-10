//
//  GeoLocationHandler.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GeoLocationHandlerDelegate <NSObject>

- (void) retrievedInfo: (CLPlacemark *) placemark;

@end

@interface GeoLocationHandler : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<GeoLocationHandlerDelegate> delegate;

@end
