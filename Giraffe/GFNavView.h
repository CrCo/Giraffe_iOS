//
//  GFBottomNavView.h
//  Giraffe
//
//  Created by Stephen Visser on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFNavView;

@protocol GFNavViewDelegate <NSObject>

- (void) navView: (GFNavView *) view didSelectForController: (UIViewController *)controller;

@end

@interface GFNavView : UIView

@property (nonatomic, weak) id<GFNavViewDelegate> delegate;
@property (nonatomic, getter=isOpen) BOOL open;
- (void) setControllers: (NSArray *) controllers;


@end
