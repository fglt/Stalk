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
+(instancetype) userWithDict:(NSDictionary *) dic {
    WBUser *user = [[WBUser alloc] init];
    user.userId = [dic objectForKey:@"id"];
    if(user.userId.intValue==0) return nil;
    if ([dic objectForKey:@"screen_name"] != nil && ![[dic objectForKey:@"screen_name"] isEqualToString:@""] ) {
        user.screenName = [dic objectForKey:@"screen_name"];
    }else{
        user.screenName = [dic objectForKey:@"nickname"];
    }
    
    user.name = [dic objectForKey:@"name"];
    user.province = [dic objectForKey:@"province"];
    user.city = [dic objectForKey:@"city"];
    user.location = [dic objectForKey:@"location"];
    user.desc = [dic objectForKey:@"description"];
    user.url = [dic objectForKey:@"url"];
    user.profileImageUrl = [dic objectForKey:@"profile_image_url"];
    user.profileUrl = [dic objectForKey:@"profile_url"];
    user.domain = [dic objectForKey:@"domain"];
    user.gender = [dic objectForKey:@"gender"];
    user.followersCount = [[dic objectForKey:@"followers_count"] intValue];
    user.friendsCount = [[dic objectForKey:@"friends_count"] intValue];
    user.statusesCount = [[dic objectForKey:@"statuses_count"] intValue];
    user.favouritesCount = [[dic objectForKey:@"favourites_count"] intValue];
    user.createdAt =  [NSDate USDateFromString:[dic objectForKey:@"created_at"]];
    user.allowAllActMsg = [[dic objectForKey:@"allow_all_act_msg"] boolValue];
    user.geoEnabled = [[dic objectForKey:@"geo_enabled"] boolValue];
    user.verified = [[dic objectForKey:@"verified"] boolValue];
    user.remark = [dic objectForKey:@"remark"];
    if ([dic objectForKey:@"status"] != nil) {
        user.status = [WBStatus statusWithDict:[dic objectForKey:@"status"]];
    }
    user.statusId = [dic objectForKey:@"status_id"];
    user.allowAllComment = [[dic objectForKey:@"allow_all_comment"] boolValue];
    user.avatarLarge = [dic objectForKey:@"avatar_large"];
    user.verifiedReason = [dic objectForKey:@"verified_reason"];
    user.followMe = [[dic objectForKey:@"follow_me"] boolValue];
    user.onlineStatus = [dic objectForKey:@"online_status"];
    user.biFollowersCount = [[dic objectForKey:@"bi_followers_count"] intValue];
    user.lang = [dic objectForKey:@"lang"];
    return user;
}
@end
