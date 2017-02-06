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
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.photoUrl != nil) {
    NSURL *imageURL = [[NSURL alloc] initWithString:self.photoUrl];
    
    [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    }];
    }
    self.label.text = self.date;
}

@end
