//
//  WBStatusLayout.m
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusLayout.h"
#import "UIView+Additions.h"
#import "UIScreen+Additions.h"
#import "NSString+Additions.h"
#import "FGLTStatus.h"
#import "FGLTUser.h"
#import "STalkTextAttachment.h"


#define URLRegular @"(http|https)://(t.cn/|weibo.com/|m.weibo.cn/)+(([a-zA-Z0-9/])*)"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"

@implementation WBStatusLayout

- (void)setStatus:(FGLTStatus *)status{
    _status = status;
    [self layout];
}

+ (NSArray *)statusLayoutsWithStatuses:(NSArray *)statuses{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statuses.count];
    for(FGLTStatus *status in statuses){
        WBStatusLayout *info = [[WBStatusLayout alloc] init];
        info.status = status;
        [array addObject:info];
    }
    
    return array;
}

- (CGSize)sizeWithText:(NSAttributedString *)text maxSize:(CGSize)maxSize
{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

- (void)layout
{
    CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat viewWidth = cellWidth - (PADDING<<1);
    UIFont *font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.minimumLineHeight = font.lineHeight;
    style.maximumLineHeight = font.lineHeight;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = 5;
    style.lineHeightMultiple = 0.0;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:font, NSParagraphStyleAttributeName: style};
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.status.text attributes:nil];
    attributedStr = [self replaceEmotion:attributedStr];
    [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
    self.statusAttributedText = attributedStr;
    //文字内容
    CGSize textSize = [self sizeWithText:attributedStr maxSize:CGSizeMake(viewWidth-16, MAXFLOAT)];

    self.textFrame = CGRectMake(PADDING, ICONWIDTH + PADDING * 2, viewWidth, textSize.height+16);

    if(_status.retweetedStatus){
        UIFont *font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT-1];
        style.minimumLineHeight = font.lineHeight;
        style.maximumLineHeight = font.lineHeight;
        NSDictionary* attributes =@{NSFontAttributeName:font, NSParagraphStyleAttributeName: style};
        
        //Create attributed string, with applied syntax highlighting
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.status.retweetedStatus.text attributes:nil];
        attributedStr = [self replaceEmotion:attributedStr];
        [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
        self.retweetAttributedText = attributedStr;
        //文字内容
        CGSize retweetSize = [self sizeWithText:attributedStr maxSize:CGSizeMake(viewWidth-16, MAXFLOAT)];
        self.retweetStatusTextFrame = CGRectMake(PADDING, CGRectGetMaxY(self.textFrame) + PADDING, viewWidth, retweetSize.height+16);
    }
    
    u_long count= _status.retweetedStatus.thumbnailPic.count>0 ? :_status.thumbnailPic.count;
    
    if(count>0 ){
        
        if(_status.retweetedStatus){
            self.pictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.retweetStatusTextFrame) + PADDING, viewWidth,  SIZE_IMAGE);
        }else{
            self.pictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.textFrame) + PADDING, viewWidth, SIZE_IMAGE);
        }
        _cellHeight = CGRectGetMaxY(self.pictureFrame) + PADDING;
    }else if(_status.retweetedStatus){
        _cellHeight = CGRectGetMaxY(self.retweetStatusTextFrame) + PADDING;
    }else{
        _cellHeight = CGRectGetMaxY(self.textFrame) + PADDING;
    }
    //    self.sepratorLineFrame = CGRectMake(startX, _cellHeight, width, 1);
    //    _cellHeight++;
}

- (NSMutableAttributedString *)replaceEmotion:(NSMutableAttributedString *)coloredString{
    
    NSUInteger lengthDetail = 0;
    NSRange newRange;
    NSString *bundleName = @"emotionResource.bundle";
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,coloredString.string.length)];
    for(NSTextCheckingResult* match in matches) {
        newRange = NSMakeRange(match.range.location - lengthDetail, match.range.length);
        NSString *emotionstr = [coloredString.string substringWithRange:newRange];
        STalkTextAttachment *attachment = [[STalkTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:[bundleName stringByAppendingPathComponent:emotionstr]];
        NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSUInteger prelength = coloredString.length;
        [coloredString replaceCharactersInRange:newRange withAttributedString:attachStr];
        lengthDetail += prelength - coloredString.length;
    }
    
    return coloredString;
}

@end
