//
//  WBBaseMessage.m
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBBaseMessage.h"

@implementation WBBaseMessage
- (NSString *)sourceForDisplay{
    u_long i = _source.length-1;
    char j=0;
    for(; i>0; i--){
        if([_source characterAtIndex:i] == '>'){
            if(j==1)break;
            j++;
        }
    }
    return [_source substringWithRange:NSMakeRange(i+1, _source.length-4 -i-1 )];

}
@end
