//
//  TableHeaderView.m
//  stalk
//
//  Created by Coding on 04/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "TableHeaderView.h"

@implementation TableHeaderView

- (void)setFrame:(CGRect)frame{
    CGFloat startX = ( [UIScreen mainScreen].bounds.size.width-frame.size.width)/2;
    frame.origin.x = startX;
    frame.size.width -= 2 * startX;
    [super setFrame:frame];
}
@end
