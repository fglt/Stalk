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
    user.userId = dict[@"id"];
    if(user.userId.intValue==0) return nil;
    if (dict[@"screen_name"] != nil && ![dict[@"screen_name"] isEqualToString:@""] ) {
        user.screenName = dict[@"screen_name"];
    }else{
        user.screenName = dict[@"nickname"];
    }
    
    user.coverImage = dict[@"cover_image"];
    user.coverImagePhone = dict[@"cover_image_phone"];
    user.name = dict[@"name"];
    user.province = dict[@"province"];
    user.city = dict[@"city"];
    user.location = dict[@"location"];
    user.desc = dict[@"description"];
    user.url = dict[@"url"];
    user.profileImageUrl = dict[@"profile_image_url"];
    user.profileUrl = dict[@"profile_url"];
    user.domain = dict[@"domain"];
    user.gender = dict[@"gender"];
    user.followersCount = [dict[@"followers_count"] intValue];
    user.friendsCount = [dict[@"friends_count"] intValue];
    user.statusesCount = [dict[@"statuses_count"] intValue];
    user.favouritesCount = [dict[@"favourites_count"] intValue];
    user.createdAt =  [NSDate USDateFromString:dict[@"created_at"]];
    user.allowAllActMsg = [dict[@"allow_all_act_msg"] boolValue];
    user.geoEnabled = [dict[@"geo_enabled"] boolValue];
    user.verified = [dict[@"verified"] boolValue];
    user.remark = dict[@"remark"];
    if (dict[@"status"] != nil) {
        user.status = [WBStatus statusWithDict:dict[@"status"]];
    }
    user.statusId = [dict[@"status_id"] stringValue];
    user.allowAllComment = [dict[@"allow_all_comment"] boolValue];
    user.avatarLarge = dict[@"avatar_large"];
    user.verifiedReason = dict[@"verified_reason"];
    user.followMe = [dict[@"follow_me"] boolValue];
    user.onlineStatus = dict[@"online_status"];
    user.biFollowersCount = [dict[@"bi_followers_count"] intValue];
    user.lang = dict[@"lang"];
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
