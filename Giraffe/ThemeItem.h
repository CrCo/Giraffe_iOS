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

- (UIImage *) image;
- (UIImage *) selectedImage;

@property (nonatomic, strong) NSString *title;

@end
