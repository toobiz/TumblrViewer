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

- (void)searchPostsForUser:(NSString *)user
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"https://toobiz.tumblr.com/api/read/json"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error) {
                    [self.delegate fetchingPostsFailedWithError:error];
                    completionBlock(FALSE, nil);
                } else {
                    [self receivedPostsJSON:data
                                 completion:^(BOOL success, NSArray* posts) {
                                     if (success) {
                                         completionBlock(TRUE, posts);
                                     } else {

                                     }
                                     
                                 }];
                }
                
            }] resume];
}

//- (void)searchPostsForUser:(NSString*)user{
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:@"https://toobiz.tumblr.com/api/read/json"]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error) {
//                if (error) {
//                    [self.delegate fetchingPostsFailedWithError:error];
//                } else {
//                    [self receivedPostsJSON:data];
//                }
//                
//            }] resume];
//}

- (void)receivedPostsJSON:(NSData *)objectNotation
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {
    NSError *error = nil;
    NSData *newData = [objectNotation subdataWithRange:(NSMakeRange(22, objectNotation.length - 24))];
//    NSArray *posts = [PostParser postsFromJSON:newData error:&error];
    [PostParser postsFromJSON:newData error:error completion:^(BOOL success, NSArray *posts) {
        completionBlock(success, posts);
    }];
}

//    completionBlock(TRUE, posts);

@end
