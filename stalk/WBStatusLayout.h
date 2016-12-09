//
//  WBStatusLayout.h
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatus.h"
#import "constant.h"
@class WBStatus;
@class WBComment;

@interface WeiboUserLayout : NSObject
@property (nonatomic) CGFloat iconWidth;
@property (nonatomic) UIFont *nameFont;
@property (nonatomic) UIFont *fromFont;
@property (nonatomic) CGFloat fromWidth;
@property (nonatomic) CGFloat nameWidth;
@property (nonatomic, strong) NSString *fromText;
@property (nonatomic, strong) WBBaseMessage *message;
@property (nonatomic) BOOL displaySource;

- (instancetype)initWithMessage:(WBBaseMessage *)message;
- (instancetype)initWithMessage:(WBBaseMessage *)message displaySource:(BOOL)displaySource;
- (void)layout;
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

@property (nonatomic, strong) WeiboUserLayout *userLayout;

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
@property (nonatomic, strong) WeiboUserLayout *userLayout;
@property (nonatomic, strong) NSMutableAttributedString *commentText;
@property (nonatomic) CGSize commentSize;
@property (nonatomic) CGFloat cellHeight;
- (instancetype)initWithComment:(WBComment *)comment;
+ (NSMutableArray *)layoutsWithComments:(NSArray *)comments;
@end

@interface WBMessageLayout : NSObject
@property (nonatomic, strong) WBBaseMessage *message;
@property (nonatomic, strong) WeiboUserLayout *userLayout;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSMutableAttributedString *messageText;
@property (nonatomic) CGSize textSize;
@property (nonatomic) CGFloat cellHeight;
- (instancetype)initWithWBMessage:(WBBaseMessage *)message;
+ (NSMutableArray *)layoutsWithWBMessages:(NSArray *)messages;
@end
