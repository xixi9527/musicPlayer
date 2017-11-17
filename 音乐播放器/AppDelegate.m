//
//  AppDelegate.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/6.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "AppDelegate.h"
#import "OnLineVC.h"
#import "HomePageVC.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicPlayViewController.h"
#import "DBManager.h"


@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    OnLineVC *online = [[OnLineVC alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:online];
    nvc.navigationBar.backgroundColor = [UIColor greenColor];
    nvc.title = @"推荐歌单";
    HomePageVC *leftVC = [[HomePageVC alloc] init];
    RESideMenu *sideMenuVC = [[RESideMenu alloc] initWithContentViewController:nvc leftMenuViewController:leftVC rightMenuViewController:nil];
    leftVC.nav = nvc;
    //sideMenuVC.backgroundImage = [UIImage imageNamed:@"mm_childControllerContainerView_bg.jpg"];
    sideMenuVC.menuPreferredStatusBarStyle = 1;
    sideMenuVC.delegate = self;
    self.window.rootViewController = sideMenuVC;
    self.window.backgroundColor = [UIColor whiteColor];
    
    
   // sideMenuVC.delegate
    [self.window makeKeyAndVisible];
    
    //后台播放音乐支持
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    MusicPlayViewController *xixi = [MusicPlayViewController shareManager];
    xixi.view.backgroundColor = [UIColor whiteColor];
    [DBManager shareManager];
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

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
