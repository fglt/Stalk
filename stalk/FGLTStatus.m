//
//  FGLTStatus.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FGLTStatus.h"
#import "FGLTUser.h"

@implementation FGLTStatus
+ (instancetype)statusWithDict:(NSDictionary *) dict {
    FGLTStatus *aStatus = [[FGLTStatus alloc] init];
    aStatus.createdAt = [dict objectForKey:@"created_at"];
    aStatus.statusId = [dict objectForKey:@"id"];
    aStatus.statusMId = [dict objectForKey:@"mid"];
    aStatus.text = [dict objectForKey:@"text"];
    aStatus.source = [dict objectForKey:@"source"];
    aStatus.favorited = [[dict objectForKey:@"favorited"] boolValue];
    aStatus.truncated = [[dict objectForKey:@"truncated"] boolValue];
    aStatus.inReply2StatusId = [dict objectForKey:@"in_reply_to_status_id"];
    aStatus.inReply2UserId = [dict objectForKey:@"in_reply_to_user_id"];
    aStatus.inReply2ScreenName = [dict objectForKey:@"in_reply_to_screen_name"];

    aStatus.thumbnailPic = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *imageArray = [dict objectForKey:@"pic_urls"];
    if ([imageArray count] != 0) {
        for (NSDictionary *imageDic in imageArray) {
            [aStatus.thumbnailPic addObject:[imageDic objectForKey:@"thumbnail_pic"]];
        }
    }
    
    if ([dict objectForKey:@"bmiddle_pic"] != nil ) {
        aStatus.bmiddlePic = [dict objectForKey:@"bmiddle_pic"];
    }
    if ([dict objectForKey:@"original_pic"] != nil ) {
        aStatus.originalPic = [dict objectForKey:@"original_pic"];
    }
    if ([dict objectForKey:@"user"] != nil) {
        aStatus.user = [FGLTUser userWithDict:[dict objectForKey:@"user"]];
    }
    aStatus.userId = [dict objectForKey:@"user_id"];
    if ([dict objectForKey:@"retweeted_status"] != nil) {
        aStatus.retweetedStatus = [FGLTStatus statusWithDict:[dict objectForKey:@"retweeted_status"]];
    }
    aStatus.repostsCount = [[dict objectForKey:@"reposts_count"] intValue];
    aStatus.commentsCount = [[dict objectForKey:@"comments_count"] intValue];
    aStatus.attitudesCount = [[dict objectForKey:@"attitudes_count"] intValue];
    aStatus.mlevel = [dict objectForKey:@"mlevel"];
    NSDictionary *visibleDic = [dict objectForKey:@"visible"];
    aStatus.visibleType = [visibleDic objectForKey:@"type"];
    aStatus.visibleListId = [visibleDic objectForKey:@"list_id"];
    return aStatus;

}

+ (NSMutableArray *)statuesWithDict:(NSDictionary *) statues{
    NSMutableArray *array =[ NSMutableArray array];
    for(NSDictionary *dict in statues){
        FGLTStatus *status = [FGLTStatus statusWithDict:dict];
        [array addObject:status];
    }
    
    return array;
}

//- (instancetype)copyWithZone:(NSZone *)zone{
//    FGLTStatus *aStatus = [[FGLTStatus alloc] init];
//    aStatus.createdAt = self.createdAt;
//    aStatus.statusId = self.statusId;
//    aStatus.statusMId =self.statusMId;
//    aStatus.text = self.text;
//    aStatus.source = self.source;
//    aStatus.favorited = self.favorited;
//    aStatus.truncated = [[dict objectForKey:@"truncated"] boolValue];
//    aStatus.inReply2StatusId = [dict objectForKey:@"in_reply_to_status_id"];
//    aStatus.inReply2UserId = [dict objectForKey:@"in_reply_to_user_id"];
//    aStatus.inReply2ScreenName = [dict objectForKey:@"in_reply_to_screen_name"];
//    
//    aStatus.thumbnailPic = [[NSMutableArray alloc] initWithCapacity:0];
//    NSMutableArray *imageArray = [dict objectForKey:@"pic_urls"];
//    if ([imageArray count] != 0) {
//        for (NSDictionary *imageDic in imageArray) {
//            [aStatus.thumbnailPic addObject:[imageDic objectForKey:@"thumbnail_pic"]];
//        }
//    }
//    
//    if ([dict objectForKey:@"bmiddle_pic"] != nil ) {
//        aStatus.bmiddlePic = [dict objectForKey:@"bmiddle_pic"];
//    }
//    if ([dict objectForKey:@"original_pic"] != nil ) {
//        aStatus.originalPic = [dict objectForKey:@"original_pic"];
//    }
//    if ([dict objectForKey:@"user"] != nil) {
//        aStatus.user = [FGLTUser userWithDict:[dict objectForKey:@"user"]];
//    }
//    aStatus.userId = [dict objectForKey:@"user_id"];
//    if ([dict objectForKey:@"retweeted_status"] != nil) {
//        aStatus.retweetedStatus = [FGLTStatus statusWithDict:[dict objectForKey:@"retweeted_status"]];
//    }
//    aStatus.repostsCount = [[dict objectForKey:@"reposts_count"] intValue];
//    aStatus.commentsCount = [[dict objectForKey:@"comments_count"] intValue];
//    aStatus.attitudesCount = [[dict objectForKey:@"attitudes_count"] intValue];
//    aStatus.mlevel = [dict objectForKey:@"mlevel"];
//    NSDictionary *visibleDic = [dict objectForKey:@"visible"];
//    aStatus.visibleType = [visibleDic objectForKey:@"type"];
//    aStatus.visibleListId = [visibleDic objectForKey:@"list_id"];
//}
@end
