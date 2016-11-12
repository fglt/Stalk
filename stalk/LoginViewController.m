//
//  ViewController.m
//  stalk
//
//  Created by Coding on 10/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HomeTableViewController.h"
#import "WBAuthorizeResponse+copy.h"
#import "WeiBoTabBarController.h"
#import "constant.h"

@interface LoginViewController ()<WeiBoDelegate, WBHttpRequestDelegate>
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWeiBo:(UIButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.weiBoDelegate = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_REDIRECT_URI;
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}
- (IBAction)logoutWeiBo:(UIButton *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WeiboSDK logOutWithToken:appDelegate.wbAuthorizeResponse.accessToken delegate:self withTag:@"user1"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_REFRESH_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_EXPIRATION_DATE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_USER_ID_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WBAuthorizeResponse *wbResponse = (WBAuthorizeResponse *)response;
    appDelegate.wbAuthorizeResponse = [WBAuthorizeResponse wbAuthorizeResponse:wbResponse];
    if(!appDelegate.wbAuthorizeResponse) return;
    [[NSUserDefaults standardUserDefaults] setObject:wbResponse.accessToken forKey:SINA_ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:wbResponse.refreshToken forKey:SINA_REFRESH_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:wbResponse.expirationDate forKey:SINA_EXPIRATION_DATE_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:wbResponse.userID  forKey:SINA_USER_ID_KEY];
    WeiBoTabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:tabBarController animated:YES completion:nil];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@", result];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@", error];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
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
