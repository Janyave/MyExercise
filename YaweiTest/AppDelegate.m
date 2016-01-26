//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Tab2ViewController.h"
#import "Tab3ViewController.h"
#import "Tab4CollectionViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    ViewController *controller = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"条目一" image:[UIImage imageNamed:@"tab1"] tag:1];
    Tab2ViewController *tabView2 = [[Tab2ViewController alloc] init];
    tabView2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"条目二" image:[UIImage imageNamed:@"tab2"] tag:2];
    
    Tab3ViewController *tabView3 = [[Tab3ViewController alloc] init];
    tabView3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"条目三" image:[UIImage imageNamed:@"tab3"] tag:3];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tabView3];

    Tab4CollectionViewController *tabView4 = [[Tab4CollectionViewController alloc] initWithNibName:@"Tab4CollectionViewController" bundle:nil];

    tabView4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"条目四" image:[UIImage imageNamed:@"tab4"] tag:4];

    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = [NSArray arrayWithObjects:nav, tabView2, nav3, tabView4, nil];
    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];
    NSLog(@"application did finish launching");
//    if ([launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey]) {
//        return NO;
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 3DTouch Shortcut
- (void)dynamicCreateShortcutWithIcon{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tab1"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tab2"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tab3"];
    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"tab4"];
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"one" localizedTitle:@"条目一" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"two" localizedTitle:@"条目二" localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"three" localizedTitle:@"条目三" localizedSubtitle:nil icon:icon3 userInfo:nil];
    UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc] initWithType:@"four" localizedTitle:@"条目四" localizedSubtitle:nil icon:icon4 userInfo:nil];
    
    NSArray *updateShortcutItems = @[item1, item2, item3, item4];
    
    [[UIApplication sharedApplication] setShortcutItems:updateShortcutItems];
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* controller =  (UITabBarController *)self.window.rootViewController;
        
        NSLog(@"--------shortItem Type is %@", shortcutItem.type);
        NSInteger index = 0;
        if ([shortcutItem.type isEqual:@"one"]) {
            index = 0;
        }
        else if([shortcutItem.type isEqual:@"two"]){
            index = 1;
        }
        else if([shortcutItem.type isEqual:@"three"]){
            index = 2;
        }
        else if([shortcutItem.type isEqual:@"four"]){
            index = 3;
        }
        [controller setSelectedIndex:index];
    }
}

@end
