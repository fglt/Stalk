//
//  WBHttpRequest+WBUser.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest+WBUser.h"

@implementation WBHttpRequest (WBUser)
+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                          screen_name:(NSString*)screen_name
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json"];
    NSDictionary *params = @{@"access_token":accessToken, @"screen_name":screen_name};
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:nil withCompletionHandler:handler];
    
}

+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                                  uid:(NSString*)uid
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json"];
    NSDictionary *params = @{@"access_token":accessToken, @"uid":uid};
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:nil withCompletionHandler:handler];
}
@end
