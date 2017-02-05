//
//  PostParser.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "PostParser.h"
#import "Post.h"

@implementation PostParser

+ (void)postsFromJSON:(NSData *)objectNotation error:(NSError *)error
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {

    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
//        *error = localError;
//        return nil;
    }
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"posts"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *postDic in results) {
        Post *post = [[Post alloc] init];
        
        for (NSString *key in postDic) {
            if ([post respondsToSelector:NSSelectorFromString(key)]) {
                [post setValue:[postDic valueForKey:@"photo-url-75"] forKey:@"photoUrl_75"];
                [post setValue:[postDic valueForKey:@"photo-url-100"] forKey:@"photoUrl_100"];
                [post setValue:[postDic valueForKey:@"regular-title"] forKey:@"title"];
                [post setValue:[postDic valueForKey:@"id"] forKey:@"id"];
                [post setValue:[postDic valueForKey:@"type"] forKey:@"type"];
                [post setValue:[postDic valueForKey:@"date"] forKey:@"date"];

            }
        }
        
        [posts addObject:post];
    }
    completionBlock(TRUE, posts);
//    return posts;
}

@end
