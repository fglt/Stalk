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
    aStatus.createdAt = [NSDate USDateFromString:dict[@"created_at"]];
    aStatus.lid = [dict[@"id"] stringValue];
    aStatus.mid = dict[@"mid"];
    aStatus.text = dict[@"text"];
    aStatus.source = dict[@"source"];
    aStatus.favorited = dict[@"favorited"];
    aStatus.truncated = dict[@"truncated"];
    aStatus.inReply2StatusId = dict[@"in_reply_to_status_id"];
    aStatus.inReply2UserId = dict[@"in_reply_to_user_id"];
    aStatus.inReply2ScreenName = dict[@"in_reply_to_screen_name"];

    aStatus.thumbnailPic = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *imageArray = dict[@"pic_urls"];
    if ([imageArray count] != 0) {
        for (NSDictionary *imageDic in imageArray) {
            [aStatus.thumbnailPic addObject:imageDic[@"thumbnail_pic"]];
        }
    }
    
    if (dict[@"bmiddle_pic"] != nil ) {
        aStatus.bmiddlePic = dict[@"bmiddle_pic"];
    }
    if (dict[@"original_pic"] != nil ) {
        aStatus.originalPic = dict[@"original_pic"];
    }
    if (dict[@"user"] != nil) {
        aStatus.user = [WBUser userWithDict:dict[@"user"]];
    }

    if (dict[@"retweeted_status"] != nil) {
        aStatus.retweetedStatus = [WBStatus statusWithDict:dict[@"retweeted_status"]];
    }
    aStatus.repostsCount = [dict[@"reposts_count"] intValue];
    aStatus.commentsCount = [dict[@"comments_count"] intValue];
    aStatus.attitudesCount = [dict[@"attitudes_count"] intValue];
    aStatus.mlevel = dict[@"mlevel"];
    NSDictionary *visibleDic = dict[@"visible"];
    aStatus.visibleType = visibleDic[@"type"];
    aStatus.visibleListId = visibleDic[@"list_id"];
    
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

@end
