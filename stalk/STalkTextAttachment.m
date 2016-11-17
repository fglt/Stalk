//
//  STalkTextAttachment.m
//  stalk
//
//  Created by Coding on 15/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "STalkTextAttachment.h"

@implementation STalkTextAttachment
- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.image = image;
    }
    return self;
    
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    UIFont *font = [textContainer.layoutManager.textStorage attribute:NSFontAttributeName
                                                              atIndex:charIndex
                                                       effectiveRange:nil];
    CGFloat baseLineHeight = (font?font.lineHeight:lineFrag.size.height);

    CGFloat y = font.descender;
    y -= (lineFrag.size.height-baseLineHeight)/2;
    
    return CGRectMake(0, y, lineFrag.size.height, lineFrag.size.height);

}
@end
