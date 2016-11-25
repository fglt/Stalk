//
//  WBStatusLayout.h
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatus.h"
@class WBStatus;
#define PADDING 10
#define SIZE_GAP_IMG 8
#define ICONWIDTH 50
#define SIZE_IMAGE 120
#define SIZE_FONT_CONTENT 19
#define SIZE_FONT_SUBCONTENT (SIZE_FONT_CONTENT-1)
#define  CELL_WIDTH (MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) -30)
#define kWBCellToolbarHeight 35

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)      // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)      //retweetContentView 背景色

#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAccount @"account"
#define kRegexHighlightViewTypeTopic @"topic"
#define kRegexHighlightViewTypeEmoji @"emoji"

#define URLRegular @"(http|https)://(t.cn/|weibo.com/|m.weibo.cn/)+(([a-zA-Z0-9/])*)"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"

@interface WBStatusLayout : NSObject

@property (nonatomic, copy) WBStatus *status;
@property (nonatomic, strong) NSMutableAttributedString *statusAttributedText;
@property (nonatomic, strong) NSMutableAttributedString *retweetAttributedText;
@property (nonatomic) CGRect statusTextFrame;
@property (nonatomic) CGRect statusPictureFrame;
@property (nonatomic) CGRect retweetContentFrame;
@property (nonatomic) CGRect retweetTextFrame;
@property (nonatomic) CGRect retweetPicFrame;
@property (nonatomic) CGFloat height;

- (instancetype)initWithStatus:(WBStatus *)status;
+ (NSMutableArray *)statusLayoutsWithStatuses:(NSArray *)WBStatus;
- (void)layout;
@end
