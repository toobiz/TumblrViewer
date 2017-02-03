//
//  TumblrClient.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TumblrClientDelegate;

@interface TumblrClient : NSObject
@property (weak, nonatomic) id delegate;

- (void)searchPostsForUser:(NSString *)user
                completion:(void (^)(BOOL success, NSArray* posts))completionBlock;

@end
