//
//  AppDelegate.h
//  TumblViewer
//
//  Created by Michał Tubis on 01.02.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainviewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)MainViewController *mainViewController;
@property (strong,nonatomic)UINavigationController *navigationController;

@end

