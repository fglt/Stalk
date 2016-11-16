//
//  WBHttpRequest+WeiboEmotion.m
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest+WeiboEmotion.h"

@implementation WBHttpRequest (WeiboEmotion)
+ (void)requestForEmotionwithAccessToken:(NSString*)accessToken
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
@end
