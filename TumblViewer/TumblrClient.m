//
//  TumblrClient.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//


#import "TumblrClient.h"
#import "PostParser.h"

@implementation TumblrClient

- (void)searchPostsForUser:(NSString *)user
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {

    NSString *searchString = [NSString stringWithFormat:@"https://%@.tumblr.com/api/read/json", user];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error) {
                    completionBlock(false, nil);
                } else {
                    [self receivedPostsJSON:data
                                 completion:^(BOOL success, NSArray* posts) {
                                     if (success) {
                                         completionBlock(true, posts);
                                     } else {
                                         completionBlock(false, nil);
                                     }
                                     
                                 }];
                }
                
            }] resume];
}

- (void)receivedPostsJSON:(NSData *)objectNotation
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {
    NSError *error = nil;
    NSData *newData = [objectNotation subdataWithRange:(NSMakeRange(22, objectNotation.length - 24))];
    [PostParser postsFromJSON:newData error:error completion:^(BOOL success, NSArray *posts) {
        if (success) {
            completionBlock(true, posts);
        } else {
            completionBlock(false, nil);
        }
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if ( !error ) {
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    completionBlock(true,image);
                } else {
                    completionBlock(false,nil);
                }
            }] resume];
}

@end
