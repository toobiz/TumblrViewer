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

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) DetailViewController *detailViewController;
@property (strong,nonatomic) TumblrClient *client;

@end
