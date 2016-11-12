//
//  FGLTUser.h
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGLTUser : NSObject
 /** 友好显示名称 */
@property(nonatomic, copy) NSString *name;

 /** 用户头像地址（中图），50×50像素 */
@property(nonatomic, copy) NSString *profile_image_url;

+(instancetype) userWithDict:(NSDictionary *) dict;
@end
