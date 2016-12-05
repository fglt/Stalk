//
//  WBUser.h
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBStatus;

@interface WBUser : NSObject
/**
 *	用户ID
 */
@property (nonatomic, copy)NSNumber *userId;


/**
 *	用户昵称
 */
@property (nonatomic, copy)NSString *screenName;


/**
 *	友好显示名称
 */
@property (nonatomic, copy)NSString *name;


/**
 *	用户所在省级ID
 */
@property (nonatomic, copy)NSString *province;


/**
 *	用户所在城市ID
 */
@property (nonatomic, copy)NSString *city;


/**
 *	用户所在地
 */
@property (nonatomic, copy)NSString *location;


@property (nonatomic, copy)NSString *coverImage;

@property (nonatomic, copy) NSString *coverImagePhone;

/**
 *	用户个人描述
 */
@property (nonatomic, copy)NSString *desc;


/**
 *	用户博客地址
 */
@property (nonatomic, copy)NSString *url;


/**
 *	用户头像地址，50×50像素
 */
@property (nonatomic, copy)NSString *profileImageUrl;


/**
 *	用户的微博统一URL地址
 */
@property (nonatomic, copy)NSString *profileUrl;


/**
 *	用户的个性化域名
 */
@property (nonatomic, copy)NSString *domain;


/**
 *	性别，m：男、f：女、n：未知
 */
@property (nonatomic, copy)NSString *gender;


/**
 *	粉丝数
 */
@property (nonatomic, assign)int followersCount;


/**
 *	关注数
 */
@property (nonatomic, assign)int friendsCount;


/**
 *	微博数
 */
@property (nonatomic, assign)int statusesCount;


/**
 *	收藏数
 */
@property (nonatomic, assign)int favouritesCount;


/**
 *	用户创建（注册）时间
 */
@property (nonatomic, copy)NSDate *createdAt;


/**
 *	是否允许所有人给我发私信，true：是，false：否
 */
@property (nonatomic, assign)BOOL allowAllActMsg;


/**
 *	是否允许标识用户的地理位置，true：是，false：否
 */
@property (nonatomic, assign)BOOL geoEnabled;


/**
 *	是否是微博认证用户，即加V用户，true：是，false：否
 */
@property (nonatomic, assign)BOOL verified;


/**
 *	用户备注信息，只有在查询用户关系时才返回此字段
 */
@property (nonatomic, copy)NSString *remark;


/**
 *	用户的最近一条微博信息字段 详细
 */
@property (nonatomic, retain)WBStatus *status;


/**
 *	用户的最近一条微博信息ID
 */
@property (nonatomic, copy)NSString *statusId;


/**
 *	是否允许所有人对我的微博进行评论，true：是，false：否
 */
@property (nonatomic, assign)BOOL allowAllComment;


/**
 *	用户大头像地址
 */
@property (nonatomic, copy)NSString *avatarLarge;


/**
 *	认证原因
 */
@property (nonatomic, copy)NSString *verifiedReason;


/**
 *	该用户是否关注当前登录用户，true：是，false：否
 */
@property (nonatomic, assign)BOOL followMe;


/**
 *	用户的在线状态，0：不在线、1：在线
 */
@property (nonatomic, copy)NSString *onlineStatus;


/**
 *	用户的互粉数
 */
@property (nonatomic, assign)int biFollowersCount;


/**
 *	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
 */
@property (nonatomic, copy)NSString *lang;

+(instancetype) userWithDict:(NSDictionary *) dict;
@end
