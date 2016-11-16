//
//  WBHttpRequest+FGLTWeiboStatus.h
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBHttpRequest.h"

@interface WBHttpRequest (FGLTWeiboStatus)
//+ (void)requestForStatusesListOfUser:(NSString*)currentUserID
//                     withAccessToken:(NSString*)accessToken
//                  andOtherProperties:(NSDictionary*)otherProperties
//                               queue:(NSOperationQueue*)queue
//               withCompletionHandler:(WBRequestHandler)handler;

+ (void)requestForStatusesOfPath:(NSString*)jsonName
                 withAccessToken:(NSString*)accessToken
              andOtherProperties:(NSDictionary*)otherProperties
                           queue:(NSOperationQueue*)queue
           withCompletionHandler:(WBRequestHandler)handler;

@end
