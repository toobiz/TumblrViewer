//
//  PostParser.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostParser : NSObject

+ (NSArray *)postsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
