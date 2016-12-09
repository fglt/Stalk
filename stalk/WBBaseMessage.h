//
//  WBBaseMessage.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"WeiboUser.h"

@interface WBBaseMessage : NSObject
@property (nonatomic, copy)NSDate *createdAt;
@property (nonatomic) NSString *lid;
@property (nonatomic, strong) WeiboUser *user;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *mid;
@property (nonatomic) NSString *source;

- (NSString *)sourceForDisplay;
@end
