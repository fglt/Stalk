//
//  WBMessageCellDelegateIMP.h
//  stalk
//
//  Created by Coding on 09/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatusCell.h"

@interface WBMessageCellDelegateIMP : NSObject<WBMessageCellDelegate>
@property (nonatomic, weak) UIViewController *controller;
@end
