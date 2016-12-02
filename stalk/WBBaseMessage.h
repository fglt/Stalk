//
//  WBBaseMessage.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBUser;

@interface WBBaseMessage : NSObject
@property (nonatomic, copy)NSDate *createdAt;
@property (nonatomic) int64_t lid;
@property (nonatomic, strong) WBUser *user;
@property (nonatomic) NSString *text;
@property (nonatomic) int64_t mid;
@property (nonatomic) NSString *source;

- (NSString *)sourceForDisplay;
@end
