//
//  NSObject+runtime.m
//  stalk
//
//  Created by Coding on 20/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "NSObject+runtime.h"

@implementation NSObject (runtime)

+ (NSArray *)varList{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *keyChar = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        [array addObject:keyStr];
    }
    return [array copy];
}

- (BOOL)existVar:(NSString *)varName{
    NSArray *array = [self.class varList];
    for(NSString *str in array){
        if([str isEqualToString:varName]||[str isEqualToString:[@"_" stringByAppendingString:varName] ]){
            return YES;
        }
    }
    return NO;
}
@end
