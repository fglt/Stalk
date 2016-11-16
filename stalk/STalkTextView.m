//
//  STalkTextView.m
//  stalk
//
//  Created by Coding on 15/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "STalkTextView.h"

@implementation STalkTextView
- (BOOL)canBecameFirstResponder {
    return NO;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if ([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
@end
