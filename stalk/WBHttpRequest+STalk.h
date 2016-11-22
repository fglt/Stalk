//
//  WBHttpRequest+STalk.h
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (STalk)
+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                          screen_name:(NSString*)screen_name
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler;

+ (void)requestForUserWithAccessToken:(NSString*)accessToken
                                  uid:(NSString*)uid
                                queue:(NSOperationQueue*)queue
                withCompletionHandler:(WBRequestHandler)handler;


+ (void)requestForEmotionWithAccessToken:(NSString *)accessToken
                                    type:(NSString *)type
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;

+ (void)requestForStatusesOfPath:(NSString*)jsonName
                 withAccessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler;
@end
