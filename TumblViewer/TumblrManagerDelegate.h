//
//  TumblrManagerDelegate.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TumblrManagerDelegate <NSObject>

- (void)didReceivePosts:(NSArray *)posts;
- (void)fetchingPostsFailedWithError:(NSError *)error;

@end
