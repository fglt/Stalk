//
//  STalkTextAttachment.h
//  stalk
//
//  Created by Coding on 15/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef  NS_ENUM(NSInteger, WBAttachmentType){
//    WBAttachmentTypeEmotion, 
//    WBAttachmentType
//};

@interface STalkTextAttachment : NSTextAttachment
- (instancetype)initWithImage:(UIImage *)image;

@end
