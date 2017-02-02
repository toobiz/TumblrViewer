//
//  TumblrClient.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "TumblrClient.h"
#import "TumblrClientDelegate.h"
#import "PostParser.h"

@implementation TumblrClient

- (void)searchPostsForUser:(NSString*)user{
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"https://toobiz.tumblr.com/api/read/json"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error) {
                    [self.delegate fetchingPostsFailedWithError:error];
                } else {
                    [self receivedPostsJSON:data];
                }
                
            }] resume];
}

- (void)receivedPostsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSData *newData = [objectNotation subdataWithRange:(NSMakeRange(22, objectNotation.length - 24))];
    NSArray *posts = [PostParser postsFromJSON:newData error:&error];
    
}

@end
