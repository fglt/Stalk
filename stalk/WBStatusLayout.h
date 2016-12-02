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
@class WBComment;
#define PADDING 10
#define SIZE_GAP_IMG 8
#define ICONWIDTH 40
#define ToolbarHeight 30
#define ToolbarGap 4

#define SIZE_FONT_CONTENT 17
#define ToolbarFontSize 13 // 工具栏字体大小
#define SIZE_FONT_SUBCONTENT (SIZE_FONT_CONTENT-1)
#define CELL_WIDTH (MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) -30)
#define CellContentWidth (CELL_WIDTH-(PADDING<<1))
#define kWBCellToolbarHeight 35

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)      // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)      //retweetContentView 背景色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色

#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAccount @"account"
#define kRegexHighlightViewTypeTopic @"topic"
#define kRegexHighlightViewTypeEmoji @"emoji"

#define URLRegular @"(http|https)://(t.cn/|weibo.com/|m.weibo.cn/)+(([a-zA-Z0-9/])*)"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"

@interface WBUserLayout : NSObject
@property (nonatomic) CGFloat fromWidth;
@property (nonatomic) CGFloat nameWidth;
@property (nonatomic, strong) NSString *fromText;
@property (nonatomic, strong) WBBaseMessage *message;
@property (nonatomic) BOOL displaySource;

- (instancetype)initWithMessage:(WBBaseMessage *)message;
- (instancetype)initWithMessage:(WBBaseMessage *)message displaySource:(BOOL)displaySource;
@end

@interface WBToolbarLayout : NSObject
@property (nonatomic) CGFloat repostTextWidth;
@property (nonatomic) NSMutableAttributedString *repostText;
@property (nonatomic) CGFloat commentTextWidth;
@property (nonatomic) NSMutableAttributedString * commentText;
@property (nonatomic) CGFloat likeTextWidth;
@property (nonatomic) NSMutableAttributedString *likeText;
- (void)layoutWithStatus:(WBStatus *)status;
@end

@interface WBStatusLayout : NSObject

@property (nonatomic, strong) WBStatus *status;
@property (nonatomic, strong) NSMutableAttributedString *statusAttributedText;
@property (nonatomic, strong) NSMutableAttributedString *retweetAttributedText;

@property (nonatomic, strong) WBUserLayout *userLayout;

@property (nonatomic) CGRect statusTextFrame;
@property (nonatomic) CGRect statusPictureFrame;
@property (nonatomic) CGRect retweetContentFrame;
@property (nonatomic) CGRect retweetTextFrame;
@property (nonatomic) CGRect retweetPicFrame;

@property (nonatomic) int imgWidth;
@property (nonatomic) int imgHeight;

@property (nonatomic) int statusViewHeight;
@property (nonatomic) CGFloat height;

@property (nonatomic) WBToolbarLayout *toolbarLayout;
@property (nonatomic, strong) NSArray *pictures;

- (instancetype)initWithStatus:(WBStatus *)status;
+ (NSMutableArray *)statusLayoutsWithStatuses:(NSArray *)WBStatus;
- (void)layout;
@end

@class WBComment;

@interface WBCommentLayout : NSObject
@property (nonatomic, strong) WBComment *comment;
@property (nonatomic, strong) WBUserLayout *userLayout;
@property (nonatomic, strong) NSMutableAttributedString *commentText;
@property (nonatomic) CGSize commentSize;
@property (nonatomic) CGFloat cellHeight;
- (instancetype)initWithComment:(WBComment *)comment;
@end
