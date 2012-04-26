//
//  Giraffe.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Giraffe.h"

@interface Giraffe()

@property (nonatomic, strong) GeoLocationHandler *handler;

@end


@implementation Giraffe

@synthesize location, handler;

static Giraffe *app;

- (id)init{
    self = [super init];
    if (self)
    {
        //Initialize parse
        [Parse setApplicationId:@"ogOmqw8RpCXhAqLe8RieMIIlYFbLQ9QwsgwEu59n" 
                      clientKey:@"1XXIo0ZxVKQwC45Yj81yBWupCKESLmFOL0KYk6uj"];
        [PFTwitterUtils initializeWithConsumerKey:@"GHfEXftNgi5I5hkp1wA39Q"
                                   consumerSecret:@"PwKG2JtmsD8uebk5szkAeFWg2C2vBKTROpQvxCU0M"];
        [PFFacebookUtils initializeWithApplicationId:@"346588532046959"];
                
        //Start our GeoLocation Handler
        self.handler = [[GeoLocationHandler alloc] init];
        self.handler.delegate = self;  
        [self.handler start];
        
        //Customize the appearance proxies for relevant objects
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar.png"] forBarMetrics:UIBarMetricsDefault];
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar.png"]];
        
        UIColor *tint = [UIColor colorWithRed:0.996 green:0.711 blue:0.035 alpha:1.0];
            
        [[UIBarButtonItem appearance] setTintColor:tint];
        [[UISegmentedControl appearance] setTintColor:tint];
        [[UIButton appearance] setTintColor:tint];
    }
    return self;
}

-(void)retrievedInfo:(CLPlacemark *)placemark
{
    self.location = placemark;
    //This is the end of the handler's lifecycle
}

+ (Giraffe *) app
{
    return app;
}

+ (void) kickstart
{
    app = [[Giraffe alloc] init];
}

@end
