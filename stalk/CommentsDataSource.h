//
//  CommentsDataSource.h
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBCommentLayout;

@interface CommentsDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<WBCommentLayout *> *commentLayoutsList;


- (instancetype)initWithCellIdentifer:(NSString *)identifer;
- (void)loadCommentsForStatus:(int64_t)statusId withCompletion:(void(^)())completion;
- (CGFloat)cellHeightAtIndex:(NSUInteger)index;
@end
