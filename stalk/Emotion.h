//
//  Emotion.h
//  stalk
//
//  Created by Coding on 15/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject
@property (nonatomic, copy)NSString *category;

@property (nonatomic, assign)BOOL common;

@property (nonatomic, assign)BOOL hot;

@property (nonatomic, copy)NSString *icon;

@property (nonatomic, copy)NSString *phrase;

@property (nonatomic, copy)NSString *picId;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *value;

+ (Emotion *)emotionFromDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;
@end
