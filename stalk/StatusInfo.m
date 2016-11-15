//
//  StatusInfo.m
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusInfo.h"
#import "UIView+Additions.h"
#import "UIScreen+Additions.h"
#import "NSString+Additions.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "FGLTStatus.h"
#import "FGLTUser.h"

@implementation StatusInfo

- (void)setStatus:(FGLTStatus *)status{
    _status = status;
    [self resetFrame];
}

+ (NSArray *)statusInfosWithStatuses:(NSArray *)statuses{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statuses.count];
    for(FGLTStatus *status in statuses){
        StatusInfo *info = [[StatusInfo alloc] init];
        info.status = status;
        [array addObject:info];
    }
    
    return array;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (void)resetFrame
{
    CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat viewWidth = cellWidth - (PADDING<<1);
    //self.iconFrame = CGRectMake(startX, PADDING, ICONWIDTH, ICONWIDTH);
    
    //    //名字
    //    CGSize nameSize = [_status.user.screenName sizeWithConstrainedToWidth:width fromFont:[UIFont systemFontOfSize:SIZE_FONT_CONTENT] lineSpace:5];
    //CGFloat nameX = ICONWIDTH + PADDING *2;
    //CGFloat nameY = PADDING;
    //self.nameFrame = CGRectMake(nameX, nameY, width, 20);
    //    self.fromFrame = CGRectMake(nameX, CGRectGetMaxY(self.nameFrame) +PADDING, width,ICONWIDTH -  CGRectGetMaxY(self.nameFrame) - PADDING);
    
    //文字内容
    CGSize textSize = [self sizeWithText:_status.text font:[UIFont systemFontOfSize:SIZE_FONT_CONTENT] maxSize:CGSizeMake(viewWidth , MAXFLOAT)];
    self.textFrame = CGRectMake(PADDING, ICONWIDTH + PADDING * 2, viewWidth, textSize.height);
    
    CGSize retweetSize =[self sizeWithText:_status.retweetedStatus.text font:[UIFont systemFontOfSize:SIZE_FONT_CONTENT-1] maxSize:CGSizeMake(viewWidth, MAXFLOAT)];
    self.retweetStatusTextFrame = CGRectMake(PADDING, CGRectGetMaxY(self.textFrame) + PADDING, viewWidth, retweetSize.height);
    u_long count= _status.retweetedStatus.thumbnailPic.count>0 ? :_status.thumbnailPic.count;
    
    if(count>0 ){
        
        if(_status.retweetedStatus){
            self.pictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.retweetStatusTextFrame) + PADDING, viewWidth,  SIZE_IMAGE);
        }else{
            self.pictureFrame = CGRectMake(PADDING, CGRectGetMaxY( self.textFrame) + PADDING, viewWidth, SIZE_IMAGE);
        }
        _cellHeight = CGRectGetMaxY(self.pictureFrame) + PADDING;
    }else{
        _cellHeight = CGRectGetMaxY(self.retweetStatusTextFrame) + PADDING;
    }
    //    self.sepratorLineFrame = CGRectMake(startX, _cellHeight, width, 1);
    //    _cellHeight++;
}
@end
