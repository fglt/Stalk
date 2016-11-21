//
//  WBStatusLayout.h
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGLTStatus.h"
@class FGLTStatus;
#define PADDING 10
#define SIZE_GAP_IMG 5
#define ICONWIDTH 50
#define SIZE_IMAGE 120
#define SIZE_FONT_CONTENT 19
#define SIZE_FONT_SUBCONTENT (SIZE_FONT_CONTENT-1)
#define MAX_SIZE_WIDTH 600

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)      // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7) 

@interface WBStatusLayout : NSObject

@property (nonatomic, copy) FGLTStatus *status;
@property (nonatomic, strong) NSMutableAttributedString *statusAttributedText;
@property (nonatomic, strong) NSMutableAttributedString *retweetAttributedText;
@property (nonatomic) CGRect textFrame;
@property (nonatomic) CGRect pictureFrame;
@property (nonatomic) CGRect retweetStatusTextFrame;
@property (nonatomic) CGFloat cellHeight;
//@property (nonatomic) CGRect sepratorLineFrame;

+ (NSArray *)statusLayoutsWithStatuses:(NSArray *)FGLTStatus;
- (void)layout;
@end
