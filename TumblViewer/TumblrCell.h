//
//  TumblrCell.h
//  TumblrViewer
//
//  Created by Michał Tubis on 05.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TumblrCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
