//
//  WBHttpRequest+STalk.h
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (STalk)

#pragma mark - userRequest
+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                          screen_name:(NSString*)screen_name
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler;

+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                                  uid:(NSString*)uid
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler;

#pragma mark - emotionRequest
+ (void)requestForEmotionWithAccessToken:(NSString *)accessToken
                                    type:(NSString *)type
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;

#pragma mark - statusRequest
+ (void)requestForStatusesOfPath:(NSString*)jsonName
                     accessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler;

+ (void)requestForPersonalStatusesWithAccessToken:(NSString *)accessToken
                               andOtherProperties:(NSDictionary*)otherProperties
                                            queue:(NSOperationQueue*)queue
                            withCompletionHandler:(WBRequestHandler)handler;

#pragma mark - topicStatusRequest
+ (void)requestForStatusesAboutTopic:(NSString*)topic
                         accessToken:(NSString*)accessToken
                  andOtherProperties:(NSDictionary*)otherProperties
                               queue:(NSOperationQueue*)queue
               withCompletionHandler:(WBRequestHandler)handler;

//获取提到@我的微博
+ (void)requestForMentionStatusWithAccessToken:(NSString *)accessToken
                            andOtherProperties:(NSDictionary*)otherProperties
                                         queue:(NSOperationQueue*)queue
                         withCompletionHandler:(WBRequestHandler)handler;

//获取转发微博列表
+ (void)requestForRepostStatusWithStatusID:(NSString *)statusID
                                accessToken:(NSString *)accessToken
                        andOtherProperties:(NSDictionary *)otherProperties
                                     queue:(NSOperationQueue*)queue
                     withCompletionHandler:(WBRequestHandler)handler;


//获取微博评论列表
+ (void)requestForCommentsWithStatusID:(NSString *)statusID
                           accessToken:(NSString *)accessToken
                      andOtherProperties:(NSDictionary *)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;

//评论微博
+ (void)requestForCreateCommentForStatusID:(NSString *)statusID
                               accessToken:(NSString *)accessToken
                               commentText:(NSString *)comment
                        andOtherProperties:(NSDictionary *)otherProperties
                                     queue:(NSOperationQueue *)queue
                     withCompletionHandler:(WBRequestHandler)handler;
@end
