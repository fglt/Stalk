//
//  StatusDataSource.h
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBStatusLayout;

typedef void (^ConfigureCellBlock)(id cell, id statusLayout);
typedef void (^LoadDataCompletionHandler)(NSError *error);

@interface StatusDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigureCellBlock)block;
- (void)loadDataWithCompletionHandler:(LoadDataCompletionHandler)handler;
- (void)loadDataAboutTopic:(NSString *)topic completionHandler:(LoadDataCompletionHandler)handler;
- (WBStatusLayout *)objectAtIndex:(NSInteger)index;
- (void)addStatus:(NSArray *)statusList;
@end
