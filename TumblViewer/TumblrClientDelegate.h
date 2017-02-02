//
//  TumblrClientDelegate.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TumblrClientDelegate <NSObject>

- (void)receivedPostsJSON:(NSData *)objectNotation;
- (void)fetchingPostsFailedWithError:(NSError *)error;

@end
