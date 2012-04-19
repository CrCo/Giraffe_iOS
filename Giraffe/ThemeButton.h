//
//  ThemeButtonController.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeItem.h"

@protocol ThemeButtonDelegate <NSObject>

- (BOOL) themeButtonPressed:(ThemeItem *)theme;

@end


@interface ThemeButton : UIView

@property (nonatomic, strong) ThemeItem *theme;
@property (nonatomic, weak) id<ThemeButtonDelegate> delegate;

@end
