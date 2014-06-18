//
//  CLAppDelegate.m
//  LearningForFree
//
//  Created by apple on 14-5-22.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
//sina weibo
#define kAppKey     @"1584775482"
#define kAppSecret  @"48d9ccdf64f9dd76d7d7e124676b4843"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#import "CLAppDelegate.h"
#import "CLIntroView.h"
#import "CLRecommendViewController.h"
#import "CLCourseViewController.h"
#import "CLFavoriteViewController.h"
#import "CLDownloadViewController.h"
#import "CLSetViewController.h"
#import "UIColor+Colours.h"
#import "CLDetailViewController.h"

@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //create UITabBarViewController
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UITabBarController *tabBarCtl=[[UITabBarController alloc]init];
    
    CLRecommendViewController *rec=[[CLRecommendViewController alloc]initWithNibName:@"CLRecommendViewController" bundle:nil];
    CLCourseViewController *cou=[[CLCourseViewController alloc]initWithNibName:@"CLCourseViewController" bundle:nil];
    CLFavoriteViewController *fav=[[CLFavoriteViewController alloc]initWithNibName:@"CLFavoriteViewController" bundle:nil];
    CLDownloadViewController *dow=[[CLDownloadViewController alloc]initWithNibName:@"CLDownloadViewController" bundle:nil];
    CLSetViewController *set=[[CLSetViewController alloc]initWithNibName:@"CLSetViewController" bundle:nil];
    
    UINavigationController *recNav=[[UINavigationController alloc]initWithRootViewController:rec];
    recNav.navigationBar.translucent=NO;
    [recNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *couNav=[[UINavigationController alloc]initWithRootViewController:cou];
    couNav.navigationBar.translucent=NO;
    [couNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *favNav=[[UINavigationController alloc]initWithRootViewController:fav];
    favNav.navigationBar.translucent=NO;
    [favNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *dowNav=[[UINavigationController alloc]initWithRootViewController:dow];
    dowNav.navigationBar.translucent=NO;
    [dowNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    UINavigationController *setNav=[[UINavigationController alloc]initWithRootViewController:set];
    setNav.navigationBar.translucent=NO;
    [setNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    setNav.navigationBar.translucent=NO;
    
    tabBarCtl.viewControllers=@[recNav,couNav,favNav,dowNav,setNav];
    self.window.rootViewController=tabBarCtl;
    tabBarCtl.selectedViewController=recNav;
    
    //判断是否是第一次使用此程序
    CLIntroView *introView=[[CLIntroView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    if ([introView isFirstOpen]) {
        [tabBarCtl.view addSubview:introView];
        [introView firstOpened];

    }

    //set background image
//    CGRect frame = CGRectMake(0.0, 0.0, 320.0, 49.0);
//    UIView *v = [[UIView alloc] initWithFrame:frame];
//    v.alpha=0.5;
//    UIColor *c  = [UIColor blackColor];
//    v.backgroundColor = c;
//    [tabBarCtl.tabBar insertSubview:v atIndex:0];
    tabBarCtl.tabBar.barTintColor=[UIColor blackColor];
    tabBarCtl.tabBar.translucent=NO;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //sina weibo share
    [WeiboSDK registerApp:kAppKey];
    [WeiboSDK enableDebugMode:YES];

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        wbtoken=[[NSString alloc]init];
        wbtoken = [(WBAuthorizeResponse *)response accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:wbtoken forKey:@"accessToken"];
        NSLog(@"%@",wbtoken);
        [alert show];
    
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

@end
