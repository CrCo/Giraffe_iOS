//
//  ThemeItem.h
//  Giraffe
//
//  Created by Stephen Visser on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeItem : NSObject

+ itemWithTitle: (NSString *) title;

- (id)init: (NSString *)title;

@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) NSString *title;

@end
