//
//  TumblrManager.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "TumblrManager.h"
#import "PostParser.h"
#import "TumblrClient.h"

@implementation TumblrManager

- (void)fetchPostsForUser:(NSString*)username;
{
    [self.client searchPostsForUser:username];
}

- (void)receivedPostsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *posts = [PostParser postsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingPostsFailedWithError:error];
        
    } else {
        [self.delegate didReceivePosts:posts];
    }
}

- (void)fetchingPostsFailedWithError:(NSError *)error
{
    [self.delegate fetchingPostsFailedWithError:error];
}

@end
