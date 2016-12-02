//
//  WBStatus.h
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBPicture.h"
#import "WBBaseMessage.h"

@class WBUser;

@interface WBStatus : WBBaseMessage
/**
 *	是否已收藏，true：是，false：否
 */
@property (nonatomic, assign)BOOL favorited;


/**
 *	是否被截断，true：是，false：否
 */
@property (nonatomic, assign)BOOL truncated;


/**
 *	（暂未支持）回复ID
 */
@property (nonatomic, copy)NSString *inReply2StatusId;

/**
 *	（暂未支持）回复人UID
 */
@property (nonatomic, copy)NSString *inReply2UserId;


/**
 *	（暂未支持）回复人昵称
 */
@property (nonatomic, copy)NSString *inReply2ScreenName;


/**
 *	（暂未支持）
 */
@property (nonatomic, copy)NSString *mlevel;


/**
 *	转发数
 */
@property (nonatomic, assign)int repostsCount;


/**
 *	评论数
 */
@property (nonatomic, assign)int commentsCount;


/**
 *	表态数
 */
@property (nonatomic, assign)int attitudesCount;


/**
 *	缩略图片地址，没有时不返回此字段
 */
@property (nonatomic, retain)NSMutableArray *thumbnailPic;


/**
 *	中等尺寸图片地址，没有时不返回此字段
 */
@property (nonatomic, copy)NSString *bmiddlePic;


/**
 *	原始图片地址，没有时不返回此字段
 */
@property (nonatomic, copy)NSString *originalPic;


/**
 *	微博作者的用户信息字段
 */
@property (nonatomic, retain)WBUser *user;


/**
 *	微博作者的用户信息字段
 */
@property (nonatomic, copy)NSString *userId;


/**
 *	地理信息字段
 */
//@property (nonatomic, retain)Geo *geo;


/**
 *	被转发的原微博信息字段，当该微博为转发微博时返回
 */
@property (nonatomic, retain)WBStatus *retweetedStatus;


/**
 *	微博的可见性, 0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；
 */
@property (nonatomic, copy)NSString *visibleType;


/**
 *	微博的可见性及指定可见分组信息,list_id为分组的组号
 */
@property (nonatomic, copy)NSString *visibleListId;

@property (nonatomic, strong) NSArray<WBPicture *> *pictures;

+ (instancetype) statusWithDict:(NSDictionary *) dict;
+ (NSMutableArray *)statuesWithArray:(NSArray *) statues;
@end
