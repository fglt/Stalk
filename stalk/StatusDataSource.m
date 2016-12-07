//
//  StatusDataSource.m
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusDataSource.h"
#import "WBStatusCell.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"
#import "WBRequestQueue.h"

static NSString *const StatusesCacheName = @"statusesCache";
static NSString *const LastCachedStatues = @"LastCachedStatues";

@interface StatusDataSource()
@property (nonatomic, copy) NSString *identifer;
@property (nonatomic, strong) NSMutableArray<WBStatusLayout *> *statusLayoutList;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@end

@implementation StatusDataSource

- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigureCellBlock)block{
    self = [super init];
    _identifer =identifer;
    _configureCellBlock = block;
    return self;
}

- (void)loadFrendsStatusWithCompletion:(void (^)())completion{

    YYCache *statusCache = [[YYCache alloc] initWithName:StatusesCacheName];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *dicts = (NSArray *)[statusCache objectForKey:LastCachedStatues];
    if(dicts){
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }else{
        NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
        [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSArray *dicts = [result objectForKey:@"statuses"];
            [statusCache setObject:dicts forKey:LastCachedStatues];
            _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
             completion();
        }];
    }
}

- (void)updateStatusesWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    YYCache *statusCache = [[YYCache alloc] initWithName:StatusesCacheName];
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [statusCache removeAllObjects];
    [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dicts = [result objectForKey:@"statuses"];
        [statusCache setObject:dicts forKey:LastCachedStatues];
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }];
}

- (void)loadMyStatusWithCompletion:(void(^)())completion{
    YYCache *statusCache = [[YYCache alloc] initWithName:@"PersonalStatusesCache"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *dicts = (NSArray *)[statusCache objectForKey:LastCachedStatues];
    if(dicts){
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }else{
        NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
        [WBHttpRequest requestForPersonalStatusesWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSArray *dicts = [result objectForKey:@"statuses"];
            [statusCache setObject:dicts forKey:LastCachedStatues];
            _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
            completion();
        }];
    }
}

- (void)updateMyStatusesWithCompletion:(void (^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    YYCache *statusCache = [[YYCache alloc] initWithName:@"PersonalStatusesCache"];
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [statusCache removeAllObjects];

    [WBHttpRequest requestForPersonalStatusesWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dicts = [result objectForKey:@"statuses"];
        [statusCache setObject:dicts forKey:LastCachedStatues];
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dicts]];
        completion();
    }];
}

- (void)loadDataAboutTopic:(NSString *)topic completion:(void (^)())completion{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForStatusesAboutTopic:topic accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dictes = [result objectForKey:@"statuses"];
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dictes]];
        completion();
    }];
}

- (void)loadAtMeStatusWithCompletion:(void(^)()) completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForMentionStatusWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *dictes = [result objectForKey:@"statuses"];
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithArray:dictes]];
        completion();
    }];
}

- (WBStatusLayout *)objectAtIndex:(NSInteger)index{
    return _statusLayoutList[index];
}

- (void)addStatus:(NSArray *)statusList{
    [_statusLayoutList addObjectsFromArray:[WBStatusLayout statusLayoutsWithStatuses:statusList]];
}

#pragma  mark - UITableViewDataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _statusLayoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
    if(!cell){
        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    }
    _configureCellBlock(cell, _statusLayoutList[indexPath.row]);
    return cell;
}

- (CGFloat)cellHeightAtIndex:(NSInteger)index{
   return [_statusLayoutList objectAtIndex:index].height + CellPadding;
}

@end
