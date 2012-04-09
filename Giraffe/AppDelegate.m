//
//  AppDelegate.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScreenController.h"
#import "Giraffe.h"
#import "SuperTabBarController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL) checkFacebookCredentials
{
    [Giraffe app].facebook = [[Facebook alloc] initWithAppId:@"346588532046959" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [Giraffe app].facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [Giraffe app].facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    return [[Giraffe app].facebook isSessionValid];
}

- (BOOL) checkTwitterCredentials
{    
    return [Giraffe app].twitter != nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Set our application ID for Parse.
    [Parse setApplicationId:@"ogOmqw8RpCXhAqLe8RieMIIlYFbLQ9QwsgwEu59n" 
                  clientKey:@"1XXIo0ZxVKQwC45Yj81yBWupCKESLmFOL0KYk6uj"];
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[[SuperTabBarController alloc] init]];
    [self.window makeKeyAndVisible];
    
//    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
//    [root.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWShadow"] forBarMetrics:UIBarMetricsDefault];
    
    //    self.navigationController.navigationBar.topItem.title = 

        
//    if (!([self checkFacebookCredentials] || [self checkTwitterCredentials]))
//    {
//        ((MainScreenController *)root.topViewController).needsLogin = YES;
//    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[Giraffe app].facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Giraffe app].facebook handleOpenURL:url]; 
}
        
#pragma mark Facebook Delegate
        
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[Giraffe app].facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[Giraffe app].facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    PFUser *user = [PFUser user];
    user.username = @"lvr123";
    user.password = @"my pass";
    user.email = @"email@example.com";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSLog(@"There was a tragic error: %@", [[error userInfo] objectForKey:@"error"]);
            // Show the errorString somewhere and let the user try again.
        }
    }];

}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}

- (void)fbDidLogout
{
    
}

- (void)fbSessionInvalidated
{
    
}

@end
