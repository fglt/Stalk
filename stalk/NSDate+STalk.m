//
//  NSDate+STalk.m
//  stalk
//
//  Created by Coding on 30/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "NSDate+STalk.h"

@implementation NSDate (STalk)
+(NSDate *)USDateFromString:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"US"];
    return [formatter dateFromString:dateString];
}
@end
