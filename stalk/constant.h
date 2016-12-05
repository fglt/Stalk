//
//  constant.h
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//
#ifndef constants_h
#define constants_h
extern NSString *const SINA_USER_ID_KEY;
extern NSString *const SINA_ACCESS_TOKEN_KEY;
extern NSString *const SINA_REFRESH_TOKEN_KEY;
extern NSString *const SINA_EXPIRATION_DATE_KEY;

#define PADDING 10
#define ImageGap 8
#define IconWidth 40
#define ToolbarHeight 30
#define ToolbarGap 4

#define SIZE_FONT_CONTENT 17
#define ToolbarFontSize 13 // 工具栏字体大小
#define SIZE_FONT_SUBCONTENT (SIZE_FONT_CONTENT-1)
#define CellWidth (MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) -30)
#define CellContentWidth (CellWidth-(PADDING<<1))
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
#endif /* constants_h */
