//
//  AppDelegate.m
//  CodeWeather
//
//  Created by 杨奇 on 2019/5/26.
//  Copyright © 2019 杨奇. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "QRCodeViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *viewController1 = [[ViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor brownColor];
    viewController1.tabBarItem.title = @"天气预知";
    
//    viewController1.navigationItem.title = @"首页标题";
    
//    QRCodeViewController *viewController2 = [[QRCodeViewController alloc] init];
//    viewController2.view.backgroundColor = [UIColor whiteColor];
//    viewController2.navigationItem.title = @"扫一扫";
//    viewController2.tabBarItem.title = @"QRCode";
//    viewController2.navigationItem.title = @"第二页标题";
    
//    UIViewController *viewController3 = [[UIViewController alloc] init];
//    viewController3.view.backgroundColor = [UIColor darkGrayColor];
//    viewController3.tabBarItem.title = @"第三页";
    
//    UIViewController *viewController4 = [[UIViewController alloc] init];
//    viewController4.view.backgroundColor = [UIColor lightGrayColor];
//    viewController4.tabBarItem.title = @"第四页";
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:@[viewController1]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    
    tabbarController.delegate = self;
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
