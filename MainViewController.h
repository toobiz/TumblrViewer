//
//  MainViewController.h
//  TumblrViewer
//
//  Created by Michał Tubis on 01.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "TumblrClient.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong,nonatomic) DetailViewController *detailViewController;
@property (strong,nonatomic) TumblrClient *client;
@property (strong, nonatomic) NSMutableArray *posts;

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSString *photoUrl_small;
@property (strong, nonatomic) NSString *bodyString;
@property (strong, nonatomic) NSString *postTitle;
@property (strong, nonatomic) NSString *dateString;


@end
