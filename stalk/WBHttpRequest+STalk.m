//
//  WBHttpRequest+STalk.m
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest+STalk.h"

NSString * const topicURL = @"https://api.weibo.com/2/search/topics.json";
NSString * const AccessTokenKey = @"access_token";
NSString * const UserUrl = @"https://api.weibo.com/2/users/show.json";

@implementation WBHttpRequest (STalk)
+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                          screen_name:(NSString*)screen_name
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler{
    NSDictionary *params = @{AccessTokenKey:accessToken, @"screen_name":screen_name};
    [WBHttpRequest requestWithAccessToken:accessToken url:UserUrl httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
    
}

+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                                  uid:(NSString*)uid
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler{
    NSDictionary *params = @{AccessTokenKey:accessToken, @"uid":uid};
    [WBHttpRequest requestWithAccessToken:accessToken url:UserUrl httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForEmotionWithAccessToken:(NSString*)accessToken
                                    type:(NSString *)type
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler{
    NSString *url =@"https://api.weibo.com/2/emotions.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    [params setObject:type forKey:@"type"];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForStatusesOfPath:(NSString*)jsonName
                     accessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/%@.json",jsonName];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForPersonalStatusesWithAccessToken:(NSString *)accessToken
                               andOtherProperties:(NSDictionary*)otherProperties
                                            queue:(NSOperationQueue*)queue
                            withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = @"https://api.weibo.com/2/statuses/user_timeline.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForStatusesAboutTopic:(NSString*)topic
                         accessToken:(NSString*)accessToken
                  andOtherProperties:(NSDictionary*)otherProperties
                               queue:(NSOperationQueue*)queue
               withCompletionHandler:(WBRequestHandler)handler{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    [params setObject:[topic stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] forKey:@"q"];
    [WBHttpRequest requestWithAccessToken:accessToken url:topicURL httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForMentionStatusWithAccessToken:(NSString *)accessToken
                            andOtherProperties:(NSDictionary*)otherProperties
                                         queue:(NSOperationQueue*)queue
                         withCompletionHandler:(WBRequestHandler)handler{
     NSString *url = @"https://api.weibo.com/2/statuses/mentions.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}


+ (void)requestForRepostStatusWithStatusID:(NSString *)statusID
                                accessToken:(NSString *)accessToken
                        andOtherProperties:(NSDictionary *)otherProperties
                                     queue:(NSOperationQueue*)queue
                     withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = @"https://api.weibo.com/2/statuses/repost_timeline.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    
    [params setObject:statusID forKey:@"id"];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

+ (void)requestForCommentsWithStatusID:(NSString *)statusID
                                accessToken:(NSString *)accessToken
                      andOtherProperties:(NSDictionary *)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = @"https://api.weibo.com/2/comments/show.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    [params setObject:statusID forKey:@"id"];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];

}

/**
 
                必选	        类型及范围	说明
 access_token	true	    string	采用OAuth授权方式为必填参数，OAuth授权后获得。
 comment	    true	    string	评论内容，必须做URLencode，内容不超过140个汉字。
 id	            true	    int64	需要评论的微博ID。
 comment_ori	false	    int	当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
 rip	        false	    string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 **/
+ (void)requestForCreateCommentForStatusID:(NSString *)statusID
                               accessToken:(NSString *)accessToken
                               commentText:(NSString *)comment
                        andOtherProperties:(NSDictionary *)otherProperties
                                     queue:(NSOperationQueue *)queue
                     withCompletionHandler:(WBRequestHandler)handler{
    NSString *url = @"https://api.weibo.com/2/comments/create.json";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:otherProperties];
    [params setObject:accessToken forKey:AccessTokenKey];
    [params setObject:statusID forKey:@"id"];
    [params setObject:comment forKey:@"comment"];
    [WBHttpRequest requestWithAccessToken:accessToken url:url httpMethod:@"get" params:params queue:queue withCompletionHandler:handler];
}

@end
