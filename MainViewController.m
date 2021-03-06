//
//  MainViewController.m
//  TumblrViewer
//
//  Created by Michał Tubis on 01.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "MainViewController.h"
#import "TumblrClient.h"
#import "TumblrCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.title = @"Tumblr Viewer";
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(147/255.0) blue:(33/255.0) alpha:1.0];
    self.searchBar.backgroundImage = [UIImage new];
    self.client = [[TumblrClient alloc] init];
    self.tableView.hidden = true;
    self.spinner.hidden = true;
    self.label.text = @"Search for Tumblr users";
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"TumblrCell" bundle:nil] forCellReuseIdentifier:@"TumblrCell"];
    TumblrCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TumblrCell"];

    NSDictionary *postDicationary = self.posts[indexPath.row];
    self.photoUrl_small = [postDicationary valueForKey:@"photoUrl_250"];
    self.postTitle = [postDicationary valueForKey:@"title"];
    self.bodyString = [postDicationary valueForKey:@"body"];
    self.dateString = [postDicationary valueForKey:@"date"];
    
    cell.postImage.image = [UIImage imageNamed:@"tumblr-icon"];
    cell.postImage.contentMode = UIViewContentModeCenter;
    
    if (self.photoUrl_small != nil) {
        NSURL *imageURL = [[NSURL alloc] initWithString:self.photoUrl_small];
        [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.postImage.image = image;
                    cell.postLabel.text = self.dateString;
                });
            }
        }];
    }
    
    if (self.postTitle == (id)[NSNull null] || self.postTitle == nil ) {
        
        NSAttributedString * bodyText = [[NSAttributedString alloc] initWithData:[self.bodyString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.postLabel.attributedText = bodyText;
    } else {
        cell.postLabel.text = self.postTitle;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.spinner startAnimating];
    NSDictionary *postDicationary = self.posts[indexPath.row];
    
    self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    self.detailViewController.photoUrl = [postDicationary valueForKey:@"photoUrl_500"];
    self.detailViewController.client = self.client;
    self.detailViewController.date = self.dateString;
    self.detailViewController.postBody = self.bodyString;
    self.detailViewController.postTitle = self.postTitle;
    [self.navigationController pushViewController:self.detailViewController animated:true];
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
}

#pragma mark - UISearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self search:self.searchText];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchText = searchText;
    [self search:searchText];
}

- (void) search: (NSString *)searchText {
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
                [self reloadData];
            }
        } else {
            [self reloadData];
        }
    }];
}

- (void) reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.hidden = true;
        [self.spinner stopAnimating];
        self.spinner.hidden = true;
        self.label.text = @"Nothing found";
    });
}

@end
