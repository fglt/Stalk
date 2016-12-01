//
//  WBModel.m
//  stalk
//
//  Created by Coding on 27/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBModel.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "NSDate+STalk.h"

@implementation WBEmoticon
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}
@end

@implementation WBEmoticonGroup
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [WBEmoticon class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emoticons enumerateObjectsUsingBlock:^(WBEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}
@end

@implementation WBComment

+ (instancetype)commentWithDictionary:(NSDictionary *)dict{
    WBComment *comment = [WBComment new];
    comment.commentID = [dict[@"id"] longLongValue];
    comment.createdAt = [NSDate USDateFromString:dict[@"created_at"]];
    comment.mid = dict[@"mid"];
    comment.text =dict[@"text"];
    comment.source =dict[@"source"];
    comment.user = [WBUser userWithDict:dict[@"user"]];
    comment.status = [WBStatus statusWithDict:dict[@"status"]];
    comment.replyComment = [WBComment commentWithDictionary:dict[@"replay_comment"]];
    return comment;
}

@end
