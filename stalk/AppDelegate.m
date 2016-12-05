//
//  AppDelegate.m
//  stalk
//
//  Created by Coding on 10/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "AppDelegate.h"
#import "constant.h"
#import "WeiBoTabBarController.h"
#import "LoginViewcontroller.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:21], NSFontAttributeName, nil]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SINA_APP_KEY];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([AppDelegate isAuthorized]){
        self.wbAuthorizeResponse = [[WBAuthorizeResponse alloc] init];
        self.wbAuthorizeResponse.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_ACCESS_TOKEN_KEY];
        self.wbAuthorizeResponse.userID = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_ID_KEY];
        self.wbAuthorizeResponse.refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_REFRESH_TOKEN_KEY];
        self.wbAuthorizeResponse.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_EXPIRATION_DATE_KEY];
        WeiBoTabBarController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = tabBarController;
        //_emotionHelper = [EmotionHelper sharedEmotionHelper];
    }else{
        LoginViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = controller;
    }
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


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{ //向微博发送请求
    
    NSLog(@"request: %@",request.class);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //用户登录的回调
    {
        if ([_weiBoDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_weiBoDelegate weiboLoginByResponse:response];
            //_emotionHelper = [EmotionHelper sharedEmotionHelper];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

+ (BOOL)isAuthorized
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_ACCESS_TOKEN_KEY];
    NSDate *expiresDate = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_EXPIRATION_DATE_KEY];
    
    if (expiresDate)
    {
        return  ( NSOrderedDescending == [expiresDate compare:[NSDate date]] && accessToken);
    }
    return NO;
}
@end
