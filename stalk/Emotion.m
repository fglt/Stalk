//
//  Emotion.m
//  stalk
//
//  Created by Coding on 15/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Emotion.h"

@implementation Emotion
+ (Emotion *)getEmotionFromJsonDic:(NSDictionary *)dic
{
    Emotion *aEmotion = [[Emotion alloc] init];
    aEmotion.category = [dic objectForKey:@"category"];
    aEmotion.common = [[dic objectForKey:@"common"] boolValue];
    aEmotion.hot = [[dic objectForKey:@"hot"] boolValue];
    aEmotion.icon = [dic objectForKey:@"icon"];
    aEmotion.phrase = [dic objectForKey:@"phrase"];
    aEmotion.picId = [dic objectForKey:@"picid"];
    aEmotion.type = [dic objectForKey:@"type"];
    aEmotion.url = [dic objectForKey:@"url"];
    aEmotion.value = [dic objectForKey:@"value"];
    
    return aEmotion;
}

@end
