//
//  AppDelegate.h
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UINavigationController *mainNav;

@property (nonatomic, strong) ViewController *viewController;

@end

