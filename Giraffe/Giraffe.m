//
//  Giraffe.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Giraffe.h"

@interface Giraffe()

@property (nonatomic, strong) ACAccountType *accountTypeTwitter;

@end


@implementation Giraffe

@synthesize accountStore, accountTypeTwitter, facebook;

static Giraffe *app;

- (id)init{
    self = [super init];
    if (self)
    {
        self.accountStore = [[ACAccountStore alloc] init];
        self.accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return self;
}

+ (Giraffe *) app
{
    if (!app)
    {
        app = [[Giraffe alloc] init];
    }
    return app;
}

- (ACAccount *)twitter
{
    NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountTypeTwitter];
    if ([accounts count] > 0)
    {
        return [accounts objectAtIndex:0];
    }
    return nil;
}

- (void) updateTwitter: (void (^)(BOOL)) allowed
{
    [self.accountStore requestAccessToAccountsWithType:self.accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            ACAccount *accountAllowed = [[accountStore accountsWithAccountType:accountTypeTwitter] objectAtIndex:0];
            if (accountAllowed)
            {
                [self.accountStore saveAccount:accountAllowed withCompletionHandler:^(BOOL success, NSError *error) {
                    allowed(YES);
                }];
            }
            else 
            {
                allowed(NO);
            }
        }
        else {
            allowed(NO);
        }
    }];
}

@end
