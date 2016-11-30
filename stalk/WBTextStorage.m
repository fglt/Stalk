//
//  WBTextStorage.m
//  stalk
//
//  Created by Coding on 29/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBTextStorage.h"

@implementation WBTextStorage{
    NSTextStorage *_imp;
}

- (instancetype)init{
    self = [super init];
    if(!self) return nil;
    
    _imp = NSTextStorage.new;
    return self;
}

- (NSString *)string
{
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    // Normal replace
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
    
    // Regular expression matching all iWords -- first character i, followed by an uppercase alphabetic character, followed by at least one other character. Matches words like iPod, iPhone, etc.
}

- (void)processEditing
{
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    static NSDataDetector *linkDetector;
    linkDetector = linkDetector ?: [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:NULL];
    
    [self removeAttribute:NSLinkAttributeName range:paragaphRange];
    [self removeAttribute:NSBackgroundColorAttributeName range:paragaphRange];
    [self removeAttribute:NSUnderlineStyleAttributeName range:paragaphRange];
    
    [linkDetector enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self addAttribute:NSLinkAttributeName value:result.URL range:result.range];
        [self addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:result.range];
        [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
    }];
    
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\[\\w+\\]" options:0 error:NULL];
    
    
    __block NSUInteger lengthDetail = 0;
    
    [iExpression enumerateMatchesInString:self.string options:kNilOptions range:paragaphRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
        NSString *newStr = @"BI";
        
        NSUInteger prelength = _imp.length;
        [self replaceCharactersInRange:newRange withString:newStr];
        lengthDetail += prelength - _imp.length;
    }];
    
    [super processEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

@end
