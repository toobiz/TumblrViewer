//
//  Post.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *photoUrl_75;
@property (strong, nonatomic) NSString *photoUrl_100;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;


@end
