//
//  NSObject+runtime.h
//  stalk
//
//  Created by Coding on 20/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (runtime)
- (NSArray *)varList;
+ (NSArray *)varList:(Class) class;
- (BOOL)existVar:(NSString *)varName;
@end
