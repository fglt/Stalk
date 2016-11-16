//
//  WBHttpRequest+FGLTWeiboStatus.m
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest+FGLTWeiboStatus.h"

@implementation WBHttpRequest (FGLTWeiboStatus)
//+ (void)requestForStatusesListOfUser:(NSString*)currentUserID
//                                withAccessToken:(NSString*)accessToken
//                             andOtherProperties:(NSDictionary*)otherProperties
//                                          queue:(NSOperationQueue*)queue
//                          withCompletionHandler:(WBRequestHandler)handler
//{
//    NSString *url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
//    [params setObject:accessToken forKey:@"access_token"];
//    
//    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:nil withCompletionHandler:handler];
//}

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
