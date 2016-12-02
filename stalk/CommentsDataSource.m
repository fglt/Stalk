//
//  CommentsDataSource.m
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CommentsDataSource.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"
#import "WBRequestQueue.h"
#import "WBModel.h"
#import "WBStatusLayout.h"
#import "WBStatusCell.h"

@implementation CommentsDataSource{
    NSString *_identifer;
}

- (instancetype)initWithCellIdentifer:(NSString *)identifer{
    self = [super init];
    _identifer = identifer;
    return self;
}

- (void)loadCommentsForStatus:(int64_t)statusId withCompletion:(void(^)())completion;{

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSDictionary *parms = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForCommentsWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken statusID:statusId andOtherProperties:parms queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSArray *list = result[@"comments"];
        NSArray *comments = [WBComment commentsWithArray:list];
        _commentLayoutsList = [WBCommentLayout layoutsWithComments:comments];
        if(completion) completion();
    }];
}

- (CGFloat)cellHeightAtIndex:(NSUInteger)index{
    return _commentLayoutsList[index].cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _commentLayoutsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    WBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
    if(!cell){
        cell = [[WBCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
    }
    [cell setLayout:_commentLayoutsList[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _commentLayoutsList[indexPath.row].cellHeight;
}
@end
