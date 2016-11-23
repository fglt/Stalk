 //
//  WBStatusLayout.m
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusLayout.h"
//#import "UIScreen+Additions.h"
#import "NSString+Additions.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "STalkTextAttachment.h"

@implementation WBStatusLayout

- (void)setStatus:(WBStatus *)status{
    _status = status;
    [self layout];
}

- (instancetype)initWithStatus:(WBStatus *)status{
    self = [super init];
    _status = status;
    [self layout];
    return self;
}

+ (NSMutableArray *)statusLayoutsWithStatuses:(NSArray *)statuses{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statuses.count];
    for(WBStatus *status in statuses){
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
    CGFloat viewWidth = CELL_WIDTH - (PADDING<<1);
    CGFloat picHeight=0;
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
    CGSize textSize = [self sizeWithText:attributedStr maxSize:CGSizeMake(viewWidth, MAXFLOAT)];

    self.statusTextFrame = CGRectMake(PADDING, ICONWIDTH + PADDING * 2, viewWidth, textSize.height);
    _height = CGRectGetMaxY(_statusTextFrame);
    
    if(_status.retweetedStatus){
        UIFont *font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT-1];
        style.minimumLineHeight = font.lineHeight;
        style.maximumLineHeight = font.lineHeight;
        NSDictionary* attributes =@{NSFontAttributeName:font, NSParagraphStyleAttributeName: style};
        NSString * str = [NSString stringWithFormat:@"@%@ %@",_status.retweetedStatus.user.screenName,_status.retweetedStatus.text];
        //Create attributed string, with applied syntax highlighting
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
        attributedStr = [self replaceEmotion:attributedStr];
        [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
        self.retweetAttributedText = attributedStr;
        //文字内容
        CGSize retweetSize = [self sizeWithText:attributedStr maxSize:CGSizeMake(viewWidth, MAXFLOAT)];
        self.retweetTextFrame =CGRectMake(PADDING, 0, viewWidth, retweetSize.height);
       
        picHeight = [self heightForPic:_status.retweetedStatus.thumbnailPic.count];
        self.retweetPicFrame = CGRectMake(PADDING, CGRectGetMaxY(self.retweetTextFrame)+PADDING, viewWidth, picHeight);
        if(picHeight>0){
            self.retweetContentFrame = CGRectMake(0, CGRectGetMaxY(self.statusTextFrame) + PADDING, CELL_WIDTH, retweetSize.height + PADDING + picHeight);
        }else{
            self.retweetContentFrame = CGRectMake(0, CGRectGetMaxY(self.statusTextFrame) + PADDING, CELL_WIDTH, retweetSize.height);
        }
        _height += self.retweetContentFrame.size.height +PADDING;
    }
    if(picHeight ==0){
        picHeight = [self heightForPic:_status.thumbnailPic.count];
        if(picHeight>0){
            if(_status.retweetedStatus){
                self.statusPictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.retweetContentFrame) + PADDING, viewWidth,  picHeight);
            }else{
                self.statusPictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.statusTextFrame) + PADDING, viewWidth,  picHeight);
            }
            _height += self.statusPictureFrame.size.height + PADDING;
        }
    }
    
    _height += PADDING;
    _height = ceil(_height);
}

- (CGFloat) heightForPic:(NSUInteger) count{
    if(count ==0) return 0;
    if(count == 1) return SIZE_IMAGE*2;
    count--;
    return count/3 * SIZE_IMAGE +SIZE_IMAGE + count/3 *SIZE_GAP_IMG;
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
