//
//  WBPicture.m
//  stalk
//
//  Created by Coding on 23/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBPicture.h"

@implementation WBPictureMetadata

- (void)setType:(NSString *)type{
    _type = [type copy];
    if ([_type isEqualToString:@"gif"]) {
        _badgeType = WBPictureBadgeTypeGIF;
    } else {
        if (_width > 0 && (float)_height / _width > 3) {
            _badgeType = WBPictureBadgeTypeLong;
        }
    }
}
@end

@implementation WBPicture

@end

