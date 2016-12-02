//
//  WBStatusCellDelegateIMP.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBStatusCell.h"

@interface WBStatusCellDelegateIMP : NSObject<WBStatusCellDelegate>
@property (nonatomic, weak) UIViewController *controller;

- (instancetype)initWithController:(UIViewController *)controller;
@end
