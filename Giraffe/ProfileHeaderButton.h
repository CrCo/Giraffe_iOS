//
//  ProfileHeaderButton.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderButton : UIView

@property (nonatomic, strong) NSString *title;

- (void) setNumber: (NSUInteger) number;
- (void) startLoading;
@property (nonatomic) BOOL selected;

@end
