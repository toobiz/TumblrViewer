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
            self.label.text = self.date;
        }
    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
