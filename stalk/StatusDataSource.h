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

@interface StatusDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigureCellBlock)block;
- (void)loadDataWithCompletion:(void(^)())completion;
- (void)loadDataAboutTopic:(NSString *)topic completion:(void (^)())completion;
- (WBStatusLayout *)objectAtIndex:(NSInteger)index;
- (void)addStatus:(NSArray *)statusList;
- (void)updateStatusesWithCompletion:(void (^)())completion;
@end
