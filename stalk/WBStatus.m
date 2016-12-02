//
//  WBStatus.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatus.h"
#import "WBUser.h"
#import "NSDate+STalk.h"

@implementation WBStatus

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if(!self) return nil;
//}

+ (instancetype)statusWithDict:(NSDictionary *) dict {
    if(!dict) return nil;
    WBStatus *aStatus = [[WBStatus alloc] init];
    aStatus.createdAt = [NSDate USDateFromString:[dict objectForKey:@"created_at"]];
    aStatus.lid = [[dict objectForKey:@"id"] longLongValue];
    aStatus.mid = [[dict objectForKey:@"mid"] longLongValue];
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
        aStatus.user = [WBUser userWithDict:[dict objectForKey:@"user"]];
    }

    if ([dict objectForKey:@"retweeted_status"] != nil) {
        aStatus.retweetedStatus = [WBStatus statusWithDict:[dict objectForKey:@"retweeted_status"]];
    }
    aStatus.repostsCount = [[dict objectForKey:@"reposts_count"] intValue];
    aStatus.commentsCount = [[dict objectForKey:@"comments_count"] intValue];
    aStatus.attitudesCount = [[dict objectForKey:@"attitudes_count"] intValue];
    aStatus.mlevel = [dict objectForKey:@"mlevel"];
    NSDictionary *visibleDic = [dict objectForKey:@"visible"];
    aStatus.visibleType = [visibleDic objectForKey:@"type"];
    aStatus.visibleListId = [visibleDic objectForKey:@"list_id"];
    
    NSURL *middleBaseURL;
    NSURL *orginBaseURL;
    if(aStatus.bmiddlePic){
        middleBaseURL = [NSURL URLWithString:[aStatus imageFilePath:aStatus.bmiddlePic]];
    }
    if(aStatus.originalPic){
        orginBaseURL = [NSURL URLWithString:[aStatus imageFilePath:aStatus.originalPic]];
    }
    if(aStatus.thumbnailPic.count<=0) return aStatus;
    NSMutableArray<WBPicture *> *pictures = [NSMutableArray arrayWithCapacity:aStatus.thumbnailPic.count];
    for(NSString *str in aStatus.thumbnailPic){
        WBPicture *picture = [WBPicture new];
        WBPictureMetadata *thumbmeta = [WBPictureMetadata new];
        thumbmeta.url = [NSURL URLWithString:str];
        thumbmeta.type = [str pathExtension];
        picture.thumbnail = thumbmeta;
        NSString *fileName = [str lastPathComponent];
        if(aStatus.bmiddlePic){
            WBPictureMetadata *middlemeta = [WBPictureMetadata new];
            middlemeta.url = [NSURL URLWithString:fileName relativeToURL:middleBaseURL];
            middlemeta.type = [aStatus.bmiddlePic pathExtension];
            picture.bmiddle = middlemeta;
        }
        if(aStatus.originalPic){
            WBPictureMetadata *originmeta = [WBPictureMetadata new];
            originmeta.url = [NSURL URLWithString:fileName relativeToURL:orginBaseURL];
            originmeta.type = [aStatus.originalPic pathExtension];
            
            picture.original = originmeta;
        }
        [pictures addObject:picture];
    }
    aStatus.pictures = [pictures copy];
    return aStatus;
}

+ (NSMutableArray *)statuesWithArray:(NSArray *) sourceDictes{
    NSMutableArray *array =[ NSMutableArray array];
    for(NSDictionary *dict in sourceDictes){
        WBStatus *status = [WBStatus statusWithDict:dict];
        [array addObject:status];
    }
    
    return array;
}

- (NSString *)imageFilePath:(NSString *)urlstr{
    u_long i = urlstr.length-1;
    for(; i>0; i--){
        if([urlstr characterAtIndex:i] == '/'){
            break;
        }
    }
    return [urlstr substringToIndex:i+1];
}

//- (NSString *)imageName:(NSString *)urlstr{
//    u_long i = urlstr.length-1;
//    for(; i>0; i--){
//        if([urlstr characterAtIndex:i] == '/'){
//            break;
//        }
//    }
//    return [urlstr substringFromIndex:i+1];
//}
//- (instancetype)copyWithZone:(NSZone *)zone{
//    WBStatus *aStatus = [[WBStatus alloc] init];
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
//        aStatus.user = [WBUser userWithDict:[dict objectForKey:@"user"]];
//    }
//    aStatus.userId = [dict objectForKey:@"user_id"];
//    if ([dict objectForKey:@"retweeted_status"] != nil) {
//        aStatus.retweetedStatus = [WBStatus statusWithDict:[dict objectForKey:@"retweeted_status"]];
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
