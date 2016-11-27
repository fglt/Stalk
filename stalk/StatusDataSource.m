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
@property (nonatomic, strong) NSMutableArray *statusLayoutList;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@end

@implementation StatusDataSource

- (instancetype)initWithCellIdentifer:(NSString *)identifer block:(ConfigureCellBlock)block{
    self = [super init];
    _identifer =identifer;
    _configureCellBlock = block;
    return self;
}

- (void)loadDataWithCompletionHandler:(LoadDataCompletionHandler)handler;{

    YYCache *statusCache = [[YYCache alloc] initWithName:StatusesCacheName];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *dict = (NSDictionary *)[statusCache objectForKey:LastCachedStatues];
    if(dict){
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithDict:dict]];
        handler(nil);
    }else{
        NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
        [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            NSDictionary *statusDict = [result objectForKey:@"statuses"];
            [statusCache setObject:statusDict forKey:LastCachedStatues];
            _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithDict:statusDict]];
            handler(error);
        }];
    }
}

- (void)loadDataAboutTopic:(NSString *)topic completionHandler:(LoadDataCompletionHandler)handler{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForStatusesAboutTopic:topic withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSDictionary *dict = [result objectForKey:@"statuses"];
        _statusLayoutList = [WBStatusLayout statusLayoutsWithStatuses:[WBStatus statuesWithDict:dict]];
        handler(error);
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


@end
