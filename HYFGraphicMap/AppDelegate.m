//
//  AppDelegate.m
//  HYFGraphicMap
//
//  Created by iOS on 2020/9/9.
//  Copyright © 2020 heyafei. All rights reserved.
//

#import "AppDelegate.h"
#import "HYFMapViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HYFMapViewController alloc] init] ];
     self.window.rootViewController = nav;
     [self.window makeKeyAndVisible];
    return YES;
}





@end
