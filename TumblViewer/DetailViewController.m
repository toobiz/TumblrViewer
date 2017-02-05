//
//  DetailViewController.m
//  TumblrViewer
//
//  Created by Michał Tubis on 02.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.photoUrl != nil) {
    NSURL *imageURL = [[NSURL alloc] initWithString:self.photoUrl];
    
    [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            self.imageView.image = image;
        }
    }];
    }
    self.label.text = self.date;
}

@end
