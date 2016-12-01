//
//  WBModel.h
//  stalk
//
//  Created by Coding on 27/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBUser;
@class WBEmoticonGroup;
@class WBStatus;

typedef NS_ENUM(NSUInteger, WBEmoticonType) {
    WBEmoticonTypeImage = 0, ///< 图片表情
    WBEmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface WBEmoticon : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) WBEmoticonType type;
@property (nonatomic, weak) WBEmoticonGroup *group;
@end

@interface WBEmoticonGroup : NSObject
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray<WBEmoticon *> *emoticons;
@end

@interface WBComment : NSObject
@property (nonatomic) int64_t commentID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) WBUser *user;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) WBStatus *status;
@property (nonatomic, strong) WBComment *replyComment;

+ (instancetype)commentWithDictionary:(NSDictionary *)dict;
@end
