//
//  WBRequestQueue.m
//  stalk
//
//  Created by Coding on 20/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBRequestQueue.h"

static WBRequestQueue *sharedQueue;
@implementation WBRequestQueue

+(instancetype) queueForWBRequest{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[WBRequestQueue alloc] init];
        sharedQueue.maxConcurrentOperationCount =4;
        sharedQueue.qualityOfService = NSQualityOfServiceBackground;
        sharedQueue.name = @"com.fglt.stalk.WBRequesetQueue";
    });
    
    return sharedQueue;
}
@end
