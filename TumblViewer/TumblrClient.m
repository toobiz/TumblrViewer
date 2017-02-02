//
//  TumblrClient.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "TumblrClient.h"

@implementation TumblrClient

- (void)searchPostsForUser:(NSString*)user{
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"https://unamourdephan.tumblr.com/api/read/json"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    NSLog(@"%@", data);
                }
                
            }] resume];
}

@end
