//
//  CommentsDataSource.h
//  stalk
//
//  Created by Coding on 01/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsDataSource : NSObject<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *commentLayoutsList;
@end
