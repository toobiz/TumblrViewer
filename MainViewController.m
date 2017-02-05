//
//  MainViewController.m
//  TumblrViewer
//
//  Created by Michał Tubis on 01.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "MainViewController.h"
#import "TumblrClient.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.delegate = self;
    self.client = [[TumblrClient alloc] init];
    self.tableView.hidden = true;
    self.spinner.hidden = true;
    self.label.text = @"Tumblr Viewer";

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableView delegate


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
    
    cell.textLabel.text = [postDicationary valueForKey:@"date"];
    
//    cell.detailTextLabel.text = @"Post description";
    cell.imageView.image = [UIImage imageNamed:@"tumblr-icon"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([postDicationary valueForKey:@"photoUrl_75"] != nil)
    {
        
        NSURL *imageURL = [[NSURL alloc] initWithString:[postDicationary valueForKey:@"photoUrl_75"]];
        
        [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
//                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
//                });
            }
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *postDicationary = self.posts[indexPath.row];

    self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    self.detailViewController.photoUrl = [postDicationary valueForKey:@"photoUrl_500"];
    self.detailViewController.client = self.client;
    self.detailViewController.date = [postDicationary valueForKey:@"date"];
    [self.navigationController pushViewController:self.detailViewController animated:true];
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
    self.spinner.hidden = false;
    [self.spinner startAnimating];
    [self.client searchPostsForUser:searchText completion:^(BOOL success, NSArray* posts) {
        if (success) {
            if (posts.count > 0) {
                self.posts = [[NSMutableArray alloc] initWithArray:posts];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.tableView.hidden = false;
                    [self.spinner stopAnimating];
                    self.spinner.hidden = true;
                    self.label.text = @"";
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
                    self.tableView.hidden = true;
                    [self.spinner stopAnimating];
                    self.spinner.hidden = true;
                    self.label.text = @"Nothing found";
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.posts removeAllObjects];
                [self.tableView reloadData];
                self.tableView.hidden = true;
                [self.spinner stopAnimating];
                self.spinner.hidden = true;
                self.label.text = @"Nothing found";
            });
        }

    }];
}

// TODO:
// custom cell
// detailview

@end
