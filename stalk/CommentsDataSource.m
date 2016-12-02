//
//  CommentsDataSource.m
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CommentsDataSource.h"

@implementation CommentsDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _commentLayoutsList.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //WBStatusCell * cell = [WBStatusCell cellWithTableView:tableView identifier:_identifer];
//    //WBStatusCell * cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
//    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
//    if(!cell){
//        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
//    }
//    _configureCellBlock(cell, _statusLayoutList[indexPath.row]);
//    return cell;
//}


@end
