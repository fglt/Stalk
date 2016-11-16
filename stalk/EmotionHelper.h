//
//  EmotionHelper.h
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;

@interface EmotionHelper : NSObject
@property (nonatomic,strong) NSMutableArray *faceEmotionsArray;
@property (nonatomic,strong) NSMutableArray *aniEmotionsArray;
@property (nonatomic,strong) NSMutableArray *cartoonEmotionsArray;
+ (instancetype)sharedEmotionHelper;
- (Emotion *)emotionWithValue:(NSString *)value;
@end
