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

    self.searchBar.delegate = self;    
    self.client = [[TumblrClient alloc] init];
    self.collectionView.hidden = true;
    self.spinner.hidden = true;
    self.label.text = @"Tumblr Viewer";
    
    [self setFlowLayout];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionView delegate

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
    cell.imageView.image = [UIImage imageNamed:@"tumblr-icon"];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    if ([postDicationary valueForKey:@"photoUrl_250"] != nil)
    {
        NSURL *imageURL = [[NSURL alloc] initWithString:[postDicationary valueForKey:@"photoUrl_250"]];
        
        [self.client downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                cell.imageView.image = image;
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
    self.detailViewController.date = [postDicationary valueForKey:@"date"];
    [self.navigationController pushViewController:self.detailViewController animated:true];
    [self.searchBar resignFirstResponder];
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
                    [self.collectionView reloadData];
                    self.collectionView.hidden = false;
                    [self.spinner stopAnimating];
                    self.spinner.hidden = true;
                    self.label.text = @"";
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.posts removeAllObjects];
                    self.collectionView.hidden = true;
                    [self.spinner stopAnimating];
                    self.spinner.hidden = true;
                    self.label.text = @"Nothing found";
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.posts removeAllObjects];
                [self.collectionView reloadData];
                self.collectionView.hidden = true;
                [self.spinner stopAnimating];
                self.spinner.hidden = true;
                self.label.text = @"Nothing found";
            });
        }

    }];
}

@end
