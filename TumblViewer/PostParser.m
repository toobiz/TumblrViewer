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

+ (NSArray *)postsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *postDic in results) {
        Post *post = [[Post alloc] init];
        
        for (NSString *key in postDic) {
            if ([post respondsToSelector:NSSelectorFromString(key)]) {
                [post setValue:[postDic valueForKey:key] forKey:key];
            }
        }
        
        [groups addObject:post];
    }
    
    return groups;
}

@end
