//
//  GeoLocationHandler.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoLocationHandler.h"
#import "Giraffe.h"

@interface GeoLocationHandler()

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation GeoLocationHandler

@synthesize manager, delegate;

- (id) init
{
    self = [super init];
    if (self)
    {
        //Upon creation, initialize the manager and register to receive any events.
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.manager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.delegate retrievedInfo:[placemarks lastObject]];
    }];
    [self.manager stopMonitoringSignificantLocationChanges];
}

@end
