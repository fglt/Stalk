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
#import "WBStatusHelper.h"

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
    _imgWidth = (viewWidth - 2*SIZE_GAP_IMG)/3;
    _imgHeight = _imgWidth *0.75;
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

    self.statusTextFrame = CGRectMake(PADDING, ICONWIDTH + PADDING, viewWidth, textSize.height);
    _statusViewHeight = CGRectGetMaxY(_statusTextFrame)+PADDING*2;
    
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
        _pictures = _status.retweetedStatus.pictures;
        picHeight = [self heightForPic:_pictures.count];
        self.retweetPicFrame = CGRectMake(PADDING, CGRectGetMaxY(self.retweetTextFrame)+PADDING, viewWidth, picHeight);
        if(picHeight>0){
            self.retweetContentFrame = CGRectMake(0, CGRectGetMaxY(self.statusTextFrame) + PADDING, CELL_WIDTH, retweetSize.height + PADDING + picHeight);
        }else{
            self.retweetContentFrame = CGRectMake(0, CGRectGetMaxY(self.statusTextFrame) + PADDING, CELL_WIDTH, retweetSize.height);
        }
        _statusViewHeight += self.retweetContentFrame.size.height +PADDING;
    } else{
        _pictures = _status.pictures;
        picHeight = [self heightForPic:_pictures.count];
        if(picHeight>0){
            self.statusPictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.statusTextFrame) + PADDING, viewWidth,  picHeight);
            _statusViewHeight += self.statusPictureFrame.size.height + PADDING;
        }
    }
    _statusViewHeight = ceil(_statusViewHeight);
    _height = _statusViewHeight + ToolbarHeight;

    [self _layoutToolbar];
    _fromText = [NSString stringWithFormat:@"%@ 来自%@", [WBStatusHelper stringWithTimelineDate:_status.createdAt], [ self sourceWithString:_status.source]];
    _fromWidth = [_fromText boundingRectWithSize:CGSizeMake(500, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5]} context:nil].size.width;
    
    _nameWidth = [_status.user.screenName boundingRectWithSize:CGSizeMake(500, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT]} context:nil].size.width;
}

- (NSString *) sourceWithString:(NSString *)source{
    u_long i = source.length-1;
    char j=0;
    for(; i>0; i--){
        if([source characterAtIndex:i] == '>'){
            if(j==1)break;
            j++;
        }
    }
    return [source substringWithRange:NSMakeRange(i+1, source.length-4 -i-1 )];
}
                 
- (CGFloat)widthForToolbarButton:(NSMutableAttributedString *)str{
    UIFont *font = [UIFont systemFontOfSize:ToolbarFontSize];
    str.font = font;
    str.color = kWBCellToolbarTitleColor;
    return [self sizeWithText:str maxSize:CGSizeMake(CellContentWidth/3.0, MAXFLOAT)].width;
}

- (void)_layoutToolbar {
    
    _repostText = [[NSMutableAttributedString alloc] initWithString:_status.repostsCount <= 0 ? @"转发" : [WBStatusHelper shortedNumberDesc:_status.repostsCount]];
    _repostTextWidth =[self widthForToolbarButton:_repostText];
    
    _commentText = [[NSMutableAttributedString alloc] initWithString:_status.commentsCount <= 0 ? @"评论" : [WBStatusHelper shortedNumberDesc:_status.commentsCount]];
    _commentTextWidth = [self widthForToolbarButton:_commentText];
    
    _likeText = [[NSMutableAttributedString alloc] initWithString:_status.attitudesCount <= 0 ? @"赞" : [WBStatusHelper shortedNumberDesc:_status.attitudesCount]];
    _likeTextWidth = [self widthForToolbarButton:_likeText];
}

- (CGFloat) heightForPic:(NSUInteger) count{
    if(count ==0) return 0;
    if(count ==1) {
        _imgWidth *= 2;
        _imgHeight *= 1.5;
    }
    count--;
    return (count/3 * _imgHeight +_imgHeight + count/3 *SIZE_GAP_IMG);
}

- (NSMutableAttributedString *)replaceEmotion:(NSMutableAttributedString *)coloredString{
    
    NSUInteger lengthDetail = 0;
    NSRange newRange;
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,coloredString.string.length)];
    for(NSTextCheckingResult* match in matches) {
        newRange = NSMakeRange(match.range.location - lengthDetail, match.range.length);
        NSString *emotionstr = [coloredString.string substringWithRange:newRange];
        STalkTextAttachment *attachment = [[STalkTextAttachment alloc] init];
        NSDictionary *emotions = [WBStatusHelper emoticonDic];
        attachment.image = [UIImage imageNamed:emotions[emotionstr]];
        NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSUInteger prelength = coloredString.length;
        [coloredString replaceCharactersInRange:newRange withAttributedString:attachStr];
        lengthDetail += prelength - coloredString.length;
    }
    
    return coloredString;
}

@end
