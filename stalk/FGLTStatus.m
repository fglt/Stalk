//
//  FGLTStatus.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FGLTStatus.h"
#import "FGLTUser.h"

@implementation FGLTStatus
+ (instancetype)statusWithDict:(NSDictionary *) dict {
    FGLTStatus *status = [[FGLTStatus alloc] init];
    
    status.text = dict[@"text"];
    status.user = [FGLTUser userWithDict:dict[@"user"]];
    
    return status;
}

+ (NSMutableArray *)statuesWithDict:(NSDictionary *) statues{
    NSMutableArray *array =[ NSMutableArray array];
    for(NSDictionary *dict in statues){
        FGLTStatus *status = [FGLTStatus statusWithDict:dict];
        [array addObject:status];
    }
    
    return array;
}
@end
