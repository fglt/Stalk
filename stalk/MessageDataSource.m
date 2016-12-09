//
//  CommentsDataSource.m
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "MessageDataSource.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"
#import "WBRequestQueue.h"
#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"

@interface MessageDataSource()
@property (nonatomic, copy) ConfigCellBlock configBlock;
@end

@implementation MessageDataSource{
    NSString *_identifer;
}

- (instancetype)initWithMessageType:(MESSAGETYPE)type cellIdentifer:(NSString *)identifer block:(ConfigCellBlock)configCellBlock{
    self = [super init];
    _identifer = identifer;
    _type = type;
    _configBlock = configCellBlock;
    return self;
}

- (void)loadMessagesForStatus:(NSString *)statusId withCompletion:(void(^)())completion{
    if(_type == MESSAGETYPEREPOST){
        [self loadRepostsForStatus:statusId withCompletion:completion];
    }else{
        [self loadCommentsForStatus:statusId withCompletion:completion];
    }
}

- (void)loadCommentsForStatus:(NSString *)statusId withCompletion:(void(^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForCommentsWithStatusID:statusId accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *list = result[@"comments"];
        NSArray *comments = [WBComment commentsWithArray:list];
        _messageLayoutList = [WBMessageLayout layoutsWithWBMessages:comments];
        if(completion) completion();
    }];
}

- (void)loadRepostsForStatus:(NSString *)statusId withCompletion:(void(^)())completion{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForRepostStatusWithStatusID:statusId accessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *list = result[@"statues"];
        NSArray *reposts = [WBStatus statuesWithArray:list];
        _messageLayoutList = [WBMessageLayout layoutsWithWBMessages:reposts];
        if(completion) completion();
    }];
}

- (CGFloat)cellHeightAtIndex:(NSUInteger)index{
    return _messageLayoutList[index].cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _messageLayoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    WBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
    if(!cell){
        cell = [[WBMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    }
    _configBlock(cell, _messageLayoutList[indexPath.row]);
    return cell;
}

@end
