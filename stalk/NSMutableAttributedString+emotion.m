//
//  NSMutableAttributedString+emotion.m
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "NSMutableAttributedString+emotion.h"
#import "STalkTextAttachment.h"
#import "WBStatusHelper.h"

@implementation NSMutableAttributedString (emotion)
- (NSMutableAttributedString *)replaceEmotion{
    
    NSUInteger lengthDetail = 0;
    NSRange newRange;
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:self.string options:0 range:NSMakeRange(0,self.string.length)];
    for(NSTextCheckingResult* match in matches) {
        newRange = NSMakeRange(match.range.location - lengthDetail, match.range.length);
        NSString *emotionstr = [self.string substringWithRange:newRange];
        STalkTextAttachment *attachment = [[STalkTextAttachment alloc] init];
        NSDictionary *emotions = [WBStatusHelper emoticonDic];
        attachment.image = [UIImage imageNamed:emotions[emotionstr]];
        NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSUInteger prelength = self.length;
        [self replaceCharactersInRange:newRange withAttributedString:attachStr];
        lengthDetail += prelength - self.length;
    }
    
    return self;
}
@end
