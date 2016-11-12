//
//  WBAuthorizeResponse+copy.h
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WeiboSDK.h"

@interface WBAuthorizeResponse (copy)
+ (instancetype)wbAuthorizeResponse:(WBAuthorizeResponse *)response;
@end
