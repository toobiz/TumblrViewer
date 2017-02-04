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

- (void)receivedPostsJSON:(NSData *)objectNotation
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock {
    NSError *error = nil;
    NSData *newData = [objectNotation subdataWithRange:(NSMakeRange(22, objectNotation.length - 24))];
//    NSArray *posts = [PostParser postsFromJSON:newData error:&error];
    [PostParser postsFromJSON:newData error:error completion:^(BOOL success, NSArray *posts) {
        completionBlock(success, posts);
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
