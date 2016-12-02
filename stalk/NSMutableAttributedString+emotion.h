//
//  NSMutableAttributedString+emotion.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EmojiRegular @"(\\[\\w+\\])"

@interface NSMutableAttributedString (emotion)
- (NSMutableAttributedString *)replaceEmotion;
@end
