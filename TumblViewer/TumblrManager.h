//
//  TumblrManager.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TumblrManagerDelegate.h"
#import "TumblrClientDelegate.h"

@class TumblrClient;

@interface TumblrManager : NSObject

@property (strong, nonatomic) TumblrClient *client;
@property (weak, nonatomic) id delegate;

- (void)fetchPostsForUser:(NSString*)username;

@end
