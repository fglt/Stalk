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
#import "NSMutableAttributedString+emotion.h"

@implementation WBUserLayout

- (instancetype)initWithMessage:(WBBaseMessage *)message displaySource:(BOOL)displaySource{
    self = [super init];
    _displaySource = displaySource;
    _message = message;
    [self layout];
    return self;
}

- (instancetype)initWithMessage:(WBBaseMessage *)message{
    self = [super init];
    _displaySource = NO;
    _message = message;
    [self layout];
    return self;
}

- (void)layout{
    if(_displaySource){
         _fromText = [NSString stringWithFormat:@"%@ 来自%@", [WBStatusHelper stringWithTimelineDate:_message.createdAt], [_message sourceForDisplay]];
    }else{
        _fromText = [self.dateFormatter stringFromDate:_message.createdAt];
    }
    
    _fromWidth = [_fromText boundingRectWithSize:CGSizeMake(500, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5]} context:nil].size.width;
    
    _nameWidth = [_message.user.screenName boundingRectWithSize:CGSizeMake(500, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT]} context:nil].size.width;
}

- (NSDateFormatter *)dateFormatter{
    static NSDateFormatter *formatter;;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc]init];
    });
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    
    return formatter;
}
@end

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
    [attributedStr replaceEmotion];
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
        [attributedStr replaceEmotion];
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
    _height = _statusViewHeight + ToolbarHeight + PADDING;

    [self _layoutToolbar];
    
    _userLayout = [[WBUserLayout alloc] initWithMessage:_status displaySource:YES];
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

@end

@implementation WBCommentLayout

- (instancetype)initWithComment:(WBComment *)comment{
    self = [super init];
    _comment = comment;
    [self layout];
    return self;
}

- (void)layout{
    _userLayout = [[WBUserLayout alloc] initWithMessage:_comment];
    _commentText = [[NSMutableAttributedString alloc]initWithString:_comment.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT-3]}];
    [_commentText replaceEmotion];
    _commentSize = [_commentText boundingRectWithSize:CGSizeMake(600, 2000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _cellHeight  = PADDING*3 + ICONWIDTH  + _commentSize.height;
}

@end
