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
    self.searchBar.backgroundColor = [UIColor colorWithRed:(246/255.0) green:(147/255.0) blue:(33/255.0) alpha:1.0];
    self.searchBar.backgroundImage = [UIImage new];
    self.client = [[TumblrClient alloc] init];
    self.collectionView.hidden = true;
    self.spinner.hidden = true;
    self.label.text = @"Search for Tumblr users";
    
    [self setFlowLayout];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionView

-(void) setFlowLayout{

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat margin = 3.0;
    CGFloat space = 1.0;
    CGFloat cellWidth = floor((screenWidth - (2 * margin + 2 * space)) / 3);
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    [self.flowLayout setMinimumInteritemSpacing:margin];
    [self.flowLayout setMinimumLineSpacing:margin];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    [self.collectionView registerClass:[TumblrCell class] forCellWithReuseIdentifier:@"TumblrCell"];
    TumblrCell *cell = (TumblrCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TumblrCell" forIndexPath:indexPath];
    
    NSDictionary *postDicationary = self.posts[indexPath.row];
    NSString *photoUrl = [postDicationary valueForKey:@"photoUrl_250"];
    cell.imageView.image = [UIImage imageNamed:@"tumblr-icon"];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    if (photoUrl != nil) {
        NSURL *imageURL = [[NSURL alloc] initWithString:photoUrl];
        [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                });
            }
        }];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *postDicationary = self.posts[indexPath.row];
    
    self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    self.detailViewController.photoUrl = [postDicationary valueForKey:@"photoUrl_500"];
    self.detailViewController.client = self.client;
    self.detailViewController.postBody = [postDicationary valueForKey:@"body"];
    self.detailViewController.postTitle = [postDicationary valueForKey:@"title"];
    [self.navigationController pushViewController:self.detailViewController animated:true];
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
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
                    [self.collectionView reloadData];
                    self.collectionView.hidden = false;
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
        [self.posts removeAllObjects];
        [self.collectionView reloadData];
        self.collectionView.hidden = true;
        [self.spinner stopAnimating];
        self.spinner.hidden = true;
        self.label.text = @"Nothing found";
    });
}

@end
