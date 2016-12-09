//
//  CellDataSource.m
//  stalk
//
//  Created by Coding on 09/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CellDataSource.h"
#import "WBStatusCell.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"
#import "WBRequestQueue.h"
#import "WBModel.h"
#import "WBStatusLayout.h"

static NSString *const StatusesCacheName = @"HomeStatusesCache";
static NSString *const HomeCachedStatuesKey = @"HomeCachedStatues";

@implementation CellDataSource
- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigCellBlock)block{
    self = [super init];
    _identifer =identifer;
    _configCellBlock = block;
    return self;
}

- (CGFloat)cellHeightAtIndex:(NSInteger)index{
    return _datas[index].height;
}

- (CellLayout *)objectAtIndex:(NSInteger)index{
    return _datas[index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class aclass = [self.class cellClass];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
    if(!cell){
        cell = [[aclass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    }
    _configCellBlock(cell, _datas[indexPath.row]);
    return cell;
}

+ (Class)cellClass{
    return [UITableViewCell class];
}

@end

@implementation HomeStatusDataSource

- (void)loadDatasWithCompletion:(void (^)())completion{
    
    YYCache *statusCache = [[YYCache alloc] initWithName:StatusesCacheName];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *dicts = (NSArray *)[statusCache objectForKey:HomeCachedStatuesKey];
    if(dicts){
        self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }else{
        NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
        [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSArray *dicts = [result objectForKey:@"statuses"];
            [statusCache setObject:dicts forKey:HomeCachedStatuesKey];
            self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
            completion();
        }];
    }
}

- (void)updateDatasWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    YYCache *statusCache = [[YYCache alloc] initWithName:StatusesCacheName];
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [statusCache removeAllObjects];
    [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dicts = [result objectForKey:@"statuses"];
        [statusCache setObject:dicts forKey:HomeCachedStatuesKey];
        self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }];
}

- (CGFloat)cellHeightAtIndex:(NSInteger)index{
    return self.datas[index].height + CellPadding;
}

+ (Class)cellClass{
    return [WBStatusCell class];
}

@end


@implementation MyStatusDataSource

- (void)loadDatasWithCompletion:(void (^)())completion{
    YYCache *statusCache = [[YYCache alloc] initWithName:@"PersonalStatusesCache"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *dicts = (NSArray *)[statusCache objectForKey:@"PersonalStatusesCacheKey"];
    if(dicts){
        self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }else{
        NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
        [WBHttpRequest requestForPersonalStatusesWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSArray *dicts = [result objectForKey:@"statuses"];
            [statusCache setObject:dicts forKey:@"PersonalStatusesCacheKey"];
             self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
            completion();
        }];
    }
}

- (void)updateDatasWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    YYCache *statusCache = [[YYCache alloc] initWithName:@"PersonalStatusesCache"];
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [statusCache removeAllObjects];
    
    [WBHttpRequest requestForPersonalStatusesWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dicts = [result objectForKey:@"statuses"];
        [statusCache setObject:dicts forKey:@"PersonalStatusesCacheKey"];
         self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }];
}

- (CGFloat)cellHeightAtIndex:(NSInteger)index{
    return self.datas[index].height + CellPadding;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
//    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
//    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifer];
//    if(!cell){
//        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifer];
//    }
//    self.configureCellBlock(cell, self.datas[indexPath.row]);
//    return cell;
//}

+ (Class)cellClass{
    return [WBStatusCell class];
}
@end


@implementation TopicStatusDataSource

- (void)loadDatasWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForStatusesAboutTopic:_topic accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dictes = [result objectForKey:@"statuses"];
        self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dictes]];
        completion();
    }];
}

- (void)loadDatasAboutTopic:(NSString *)topic completion:(void (^)())completion{
    _topic = topic;
    [self loadDatasWithCompletion:completion];
}


- (CGFloat)cellHeightAtIndex:(NSInteger)index{
    return self.datas[index].height + CellPadding;
}

+ (Class)cellClass{
    return [WBStatusCell class];
}

@end


@implementation CommentDataSource

- (void)loadDatasWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForCommentsWithStatusID:_statusId accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *list = result[@"comments"];
        NSArray *comments = [WBComment commentsWithArray:list];
        self.datas = [WBMessageLayout layoutsWithWBMessages:comments];
        if(completion) completion();
    }];
}

- (void) loadCommentsForStatus:(NSString *)statusId completion:(void (^)())completion{
    self.statusId = statusId;
    [self loadDatasWithCompletion:completion];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
//    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
//    WBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifer];
//    if(!cell){
//        cell = [[WBMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifer];
//    }
//    self.configureCellBlock(cell, self.datas[indexPath.row]);
//    return cell;
//}

+ (Class)cellClass{
    return [WBMessageCell class];
}
@end


@implementation RepostStatusDataSource

- (void)loadDatasWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForRepostStatusWithStatusID:_statusId accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *list = result[@"statues"];
        NSArray *reposts = [WBStatus statuesWithArray:list];
        self.datas = [WBMessageLayout layoutsWithWBMessages:reposts];
        if(completion) completion();
    }];
}

- (void)loadRepostsForStatus:(NSString *)statusId completion:(void (^)())completion{
    self.statusId = statusId;
    [self loadDatasWithCompletion:completion];
}

+ (Class)cellClass{
    return [WBMessageCell class];
}

@end


@implementation AtMeStatusDataSource

- (void)loadDatasWithCompletion:(void(^)()) completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForMentionStatusWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dictes = [result objectForKey:@"statuses"];
        self.datas = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dictes]];
        completion();
    }];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifer];
//    if(!cell){
//        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifer];
//    }
//    self.configureCellBlock(cell, self.datas[indexPath.row]);
//    return cell;
//}

+ (Class)cellClass{
    return [WBStatusCell class];
}

@end
