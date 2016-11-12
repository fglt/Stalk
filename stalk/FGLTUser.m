//
//  FGLTUser.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FGLTUser.h"

@implementation FGLTUser
+(instancetype) userWithDict:(NSDictionary *) dict {
    FGLTUser *user = [[FGLTUser alloc] init];
    
    user.name = dict[@"name"];
    user.profile_image_url = dict[@"profile_image_url"];
    
    return user;
}
@end
