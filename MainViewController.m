//
//  MainViewController.m
//  TumblrViewer
//
//  Created by Michał Tubis on 01.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.client = [[TumblrClient alloc] init];
    [self.client searchPostsForUser:@"toobiz" completion:^(BOOL success, NSArray* posts) {
        if (success) {
            NSLog(@"Great Success!");
//            NSLog(@"%@", posts[0]);
//            self.posts = posts;
            self.posts = [[NSMutableArray alloc] initWithArray:posts];
            [self.tableView reloadData];
        }
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *postDicationary = self.posts[indexPath.row];
    
//    if ([postDicationary valueForKey:@"title"] != nil) {
        cell.textLabel.text = [postDicationary valueForKey:@"type"];
//    }
    
    cell.detailTextLabel.text = @"Post description";
    cell.imageView.image = [UIImage imageNamed:@"launch-image"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([postDicationary valueForKey:@"photoUrl_75"] == nil) {}
    else if ([postDicationary valueForKey:@"photoUrl_75"] == (id)[NSNull null]) {
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSURL *imageURL = [[NSURL alloc] initWithString:[postDicationary valueForKey:@"photoUrl_75"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        });
    }
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(queue, ^{
////        NSURL *imageURL = [[NSURL alloc] initWithString:[postDicationary valueForKey:@"photoUrl_75"]];
//        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[postDicationary valueForKey:@"photoUrl_75"]];
//        UIImage *image = [[UIImage alloc] initWithData:imageData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = image;
//        });
//    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:self.detailViewController animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
