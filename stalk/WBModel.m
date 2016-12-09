//
//  WBModel.m
//  stalk
//
//  Created by Coding on 27/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBModel.h"
#import "WBStatus.h"
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
    if(!dict) return nil;
    WBComment *comment = [WBComment new];
    comment.lid = dict[@"id"];
    comment.createdAt = [NSDate USDateFromString:dict[@"created_at"]];
    comment.mid = dict[@"mid"];
    comment.text =dict[@"text"];
    comment.source =dict[@"source"];
    comment.user = [WeiboUser userWithDictionary:dict[@"user"]];
    comment.status = [WBStatus statusWithDict:dict[@"status"]];
    /**
     要先判断dict[@"replay_comment"]是否存在；否则导致大量系统资源被占用名，导致错误
     **/
    if(dict[@"replay_comment"]){
        comment.replyComment = [WBComment commentWithDictionary:dict[@"replay_comment"]];
    }
    return comment;
}

+ (NSArray *)commentsWithArray:(NSArray *)array{
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for(NSDictionary *dict in array){
        WBComment *comment = [WBComment commentWithDictionary:dict];
        [comments addObject:comment];
    }
    
    return comments;
}

@end
