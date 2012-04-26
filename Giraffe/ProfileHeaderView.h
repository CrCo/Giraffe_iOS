//
//  ProfileHeaderView.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileHeaderViewDelegate <NSObject>

- (void) didPressButton: (NSString *) title;

@end

@interface ProfileHeaderView : UIView

@property (nonatomic, weak) id<ProfileHeaderViewDelegate> delegate;

- (void)setNumber: (NSUInteger) number forHeader:(NSString *)title;
- (void) addHeader:(NSString *)title;
- (void) selectHeader: (NSString *)title;

@end
