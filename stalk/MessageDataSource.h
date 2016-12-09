//
//  CommentsDataSource.h
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBCommentLayout;
@class WBStatusLayout;
@class WBMessageLayout;

typedef NS_ENUM(NSInteger, MESSAGETYPE){
    MESSAGETYPEREPOST = 0,
    MESSAGETYPECOMMENT
};

typedef void (^ConfigCellBlock)(id cell, id messageLayout);
//@interface CommentsDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, strong) NSMutableArray<WBCommentLayout *> *commentLayoutsList;
//
//- (instancetype)initWithCellIdentifer:(NSString *)identifer;
//- (void)loadCommentsForStatus:(int64_t)statusId withCompletion:(void(^)())completion;
//- (CGFloat)cellHeightAtIndex:(NSUInteger)index;
//@end


@interface MessageDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) MESSAGETYPE type;
@property (nonatomic, strong) NSMutableArray<WBMessageLayout *> *messageLayoutList;
- (instancetype)initWithMessageType:(MESSAGETYPE)type cellIdentifer:(NSString *)identifer block:(ConfigCellBlock)configCellBlock;
- (void)loadMessagesForStatus:(NSString *)statusId withCompletion:(void(^)())completion;
- (CGFloat)cellHeightAtIndex:(NSUInteger)index;
@end
