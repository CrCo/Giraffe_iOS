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

+ (NSString *) timeAgo: (NSDate *) aDate
{
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSSecondCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *components = [sysCalendar  components:unitFlags fromDate:aDate  toDate:[[NSDate alloc] init]  options:0];
    
    if (components.year > 0)
    {
        return [NSString stringWithFormat: @"%d years ago", components.year];
    }
    else if(components.month > 0)
    {
        return [NSString stringWithFormat: @"%d months ago", components.month];
    }
    else if(components.week > 0)
    {
        return [NSString stringWithFormat: @"%d weeks ago", components.week];
    }
    else if(components.day > 0)
    {
        return [NSString stringWithFormat: @"%dd ago", components.day];
    }
    else if(components.hour > 0)
    {
        return [NSString stringWithFormat: @"%dh ago", components.hour];
    }
    else if(components.hour > 0)
    {
        return [NSString stringWithFormat: @"%dm ago", components.minute];
    }
    else
    {
        return @"Mere seconds ago";
    }
}

@end
