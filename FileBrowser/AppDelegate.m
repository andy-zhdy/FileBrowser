//
//  AppDelegate.m
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 andy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.viewController = [[ViewController alloc] init];
    self.mainNav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.mainNav.navigationBar.barTintColor = [UIColor redColor];
    self.mainNav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.mainNav.navigationBar.tintColor = [UIColor whiteColor];

    self.window.rootViewController = self.mainNav;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
