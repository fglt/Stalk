//
//  WBUser.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBUser.h"
#import "WBStatus.h"
#import "NSDate+STalk.h"

@implementation WBUser
+(instancetype) userWithDict:(NSDictionary *) dict {
    WBUser *user = [[WBUser alloc] init];
    user.userId = [dict objectForKey:@"id"];
    if(user.userId.intValue==0) return nil;
    if ([dict objectForKey:@"screen_name"] != nil && ![[dict objectForKey:@"screen_name"] isEqualToString:@""] ) {
        user.screenName = [dict objectForKey:@"screen_name"];
    }else{
        user.screenName = [dict objectForKey:@"nickname"];
    }
    
    user.coverImage = [dict objectForKey:@"cover_image"];
    user.coverImagePhone = [dict objectForKey:@"cover_image_phone"];
    user.name = [dict objectForKey:@"name"];
    user.province = [dict objectForKey:@"province"];
    user.city = [dict objectForKey:@"city"];
    user.location = [dict objectForKey:@"location"];
    user.desc = [dict objectForKey:@"description"];
    user.url = [dict objectForKey:@"url"];
    user.profileImageUrl = [dict objectForKey:@"profile_image_url"];
    user.profileUrl = [dict objectForKey:@"profile_url"];
    user.domain = [dict objectForKey:@"domain"];
    user.gender = [dict objectForKey:@"gender"];
    user.followersCount = [[dict objectForKey:@"followers_count"] intValue];
    user.friendsCount = [[dict objectForKey:@"friends_count"] intValue];
    user.statusesCount = [[dict objectForKey:@"statuses_count"] intValue];
    user.favouritesCount = [[dict objectForKey:@"favourites_count"] intValue];
    user.createdAt =  [NSDate USDateFromString:[dict objectForKey:@"created_at"]];
    user.allowAllActMsg = [[dict objectForKey:@"allow_all_act_msg"] boolValue];
    user.geoEnabled = [[dict objectForKey:@"geo_enabled"] boolValue];
    user.verified = [[dict objectForKey:@"verified"] boolValue];
    user.remark = [dict objectForKey:@"remark"];
    if ([dict objectForKey:@"status"] != nil) {
        user.status = [WBStatus statusWithDict:[dict objectForKey:@"status"]];
    }
    user.statusId = [dict objectForKey:@"status_id"];
    user.allowAllComment = [[dict objectForKey:@"allow_all_comment"] boolValue];
    user.avatarLarge = [dict objectForKey:@"avatar_large"];
    user.verifiedReason = [dict objectForKey:@"verified_reason"];
    user.followMe = [[dict objectForKey:@"follow_me"] boolValue];
    user.onlineStatus = [dict objectForKey:@"online_status"];
    user.biFollowersCount = [[dict objectForKey:@"bi_followers_count"] intValue];
    user.lang = [dict objectForKey:@"lang"];
    return user;
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    
//    _userId = [aDecoder decodeObjectForKey:@"id"];
//    _name = [aDecoder decodeObjectForKey:@"name"];
//    return self;
//}
@end
