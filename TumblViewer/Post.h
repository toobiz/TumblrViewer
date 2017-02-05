//
//  Post.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSString *photoUrl_250;
@property (strong, nonatomic) NSString *photoUrl_500;
@property (strong, nonatomic) NSString *date;

@end
