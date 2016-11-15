//
//  StatusInfo.h
//  stalk
//
//  Created by Coding on 13/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGLTStatus.h"
@class FGLTStatus;
#define PADDING 10
#define SIZE_GAP_IMG 5
#define ICONWIDTH 50
#define SIZE_IMAGE 120
#define SIZE_FONT_CONTENT 19
#define SIZE_FONT_SUBCONTENT (SIZE_FONT_CONTENT-1)
#define MAX_SIZE_WIDTH 640

@interface StatusInfo : NSObject

@property (nonatomic, strong) FGLTStatus *status;
//@property (nonatomic) CGRect iconFrame;
//@property (nonatomic) CGRect nameFrame;
//@property (nonatomic) CGRect fromFrame;
@property (nonatomic) CGRect textFrame;
@property (nonatomic) CGRect pictureFrame;
@property (nonatomic) CGRect retweetStatusTextFrame;
@property (nonatomic) CGFloat cellHeight;
//@property (nonatomic) CGRect sepratorLineFrame;

+ (NSArray *)statusInfosWithStatuses:(NSArray *)FGLTStatus;
- (void)resetFrame;
@end
