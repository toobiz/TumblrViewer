//
//  PostParser.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostParser : NSObject

+ (void)postsFromJSON:(NSData *)objectNotation error:(NSError *)error
           completion:(void (^)(BOOL success, NSArray* posts))completionBlock;
@end
