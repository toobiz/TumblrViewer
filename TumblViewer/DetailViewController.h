//
//  DetailViewController.h
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrClient.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) TumblrClient *client;

@end
