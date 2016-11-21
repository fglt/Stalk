//
//  WBRequestQueue.h
//  stalk
//
//  Created by Coding on 20/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRequestQueue : NSOperationQueue
+(instancetype) queueForWBRequest;
@end
