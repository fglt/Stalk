//
//  PhotoBrowerControllerAnimatedDelegate.h
//  stalk
//
//  Created by Coding on 28/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAnimator.h"

@interface PhotoBrowerControllerAnimatedDelegate:NSObject<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) PopAnimator *popAnimator;
@end
