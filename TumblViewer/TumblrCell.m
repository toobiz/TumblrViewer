//
//  TumblrCell.m
//  TumblrViewer
//
//  Created by Michał Tubis on 05.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import "TumblrCell.h"

@implementation TumblrCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TumblrCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) { return nil; }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) { return nil; }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
