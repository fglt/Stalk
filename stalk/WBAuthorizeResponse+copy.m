//
//  WBAuthorizeResponse+copy.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBAuthorizeResponse+copy.h"

@implementation WBAuthorizeResponse (copy)
+ (instancetype)wbAuthorizeResponse:(WBAuthorizeResponse *)response{
    if(!response) return nil;
    WBAuthorizeResponse *wbresponse = [[WBAuthorizeResponse alloc] init];
    wbresponse.userID = response.userID;
    wbresponse.accessToken = response.accessToken;
    wbresponse.expirationDate = response.expirationDate;
    wbresponse.refreshToken = response.refreshToken;
    return wbresponse;
}
@end
