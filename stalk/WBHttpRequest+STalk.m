//
//  WBHttpRequest+STalk.m
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest+STalk.h"

@implementation WBHttpRequest (STalk)
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

+ (void)requestForEmotionWithAccessToken:(NSString*)accessToken
                                    type:(NSString *)type
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler{
    NSString *url =@"https://api.weibo.com/2/emotions.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:@"access_token"];
    [params setObject:type forKey:@"type"];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForStatusesOfPath:(NSString*)jsonName
                 withAccessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/%@.json",jsonName];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:@"access_token"];
    
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:nil withCompletionHandler:handler];
}
@end
