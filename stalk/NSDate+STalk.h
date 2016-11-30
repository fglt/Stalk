//
//  NSDate+STalk.h
//  stalk
//
//  Created by Coding on 30/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (STalk)
+(NSDate *)USDateFromString:(NSString *)dateString format:(NSString *)format;
@end
