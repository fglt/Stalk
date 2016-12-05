//
//  PersonalStatusDataSource.h
//  stalk
//
//  Created by Coding on 03/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatusLayout.h"

@interface PersonalStatusDataSource : NSObject
@property (nonatomic, strong) NSMutableArray<WBStatusLayout *> *statusLayoutList;

- (instancetype)initWithCellIdentifer:(NSString *)identifer;
- (void)loadStatus:(int64_t)statusId withCompletion:(void(^)())completion;
- (CGFloat)cellHeightAtIndex:(NSUInteger)index;
@end
