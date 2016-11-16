//
//  WBHttpRequest+WeiboEmotion.h
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (WeiboEmotion)
+ (void)requestForEmotionwithAccessToken:(NSString *)accessToken
                                    type:(NSString *)type
                      andOtherProperties:(NSDictionary*)otherProperties
                                   queue:(NSOperationQueue*)queue
                   withCompletionHandler:(WBRequestHandler)handler;
@end
