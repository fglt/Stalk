//
//  CellDataSource.h
//  stalk
//
//  Created by Coding on 09/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CellLayout;

typedef void (^ConfigCellBlock)(id cell, id layout);


@protocol CellDataSourceDelegate <NSObject>

@optional
- (void)loadDatasWithCompletion:(void(^)())completion;
- (void)updateDatasWithCompletion:(void (^)())completion;
- (void)addDatas:(NSArray *)datas;
- (CGFloat)cellHeightAtIndex:(NSInteger)index;
- (CellLayout *)objectAtIndex:(NSInteger)index;
@end

@interface CellDataSource : NSObject<CellDataSourceDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *identifer;
@property (nonatomic, strong) NSMutableArray<CellLayout *> *datas;
@property (nonatomic, copy) ConfigCellBlock configCellBlock;

+ (Class)cellClass;

- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigCellBlock)block;
@end

@interface HomeStatusDataSource : CellDataSource

@end

@interface MyStatusDataSource : CellDataSource

@end

@interface TopicStatusDataSource : CellDataSource
@property (nonatomic, copy) NSString *topic;

- (void)loadDatasAboutTopic:(NSString *)topic completion:(void (^)())completion;
@end

@interface CommentDataSource : CellDataSource
@property (nonatomic, copy) NSString *statusId;

- (void) loadCommentsForStatus:(NSString *)statusId completion:(void (^)())completion ;
@end

@interface RepostStatusDataSource : CellDataSource
@property (nonatomic, copy) NSString *statusId;
- (void) loadRepostsForStatus:(NSString *)statusId completion:(void (^)())completion;
@end

@interface AtMeStatusDataSource : CellDataSource

@end
