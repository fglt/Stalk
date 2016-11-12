//
//  FGLTStatus.h
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FGLTUser;

@interface FGLTStatus : NSObject
/** 微博信息内容 */
@property(nonatomic, copy) NSString *text;

/** 微博作者的用户信息字段 详细 */
@property(nonatomic, strong) FGLTUser *user;

/** 微博配图地址数组，里面装载的时HVWPic模型 */
@property(nonatomic, strong) NSArray *pic_urls;

+ (instancetype) statusWithDict:(NSDictionary *) dict;
+ (NSMutableArray *)statuesWithDict:(NSDictionary *) statues;
@end
