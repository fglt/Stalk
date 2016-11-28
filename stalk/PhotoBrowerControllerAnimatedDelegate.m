//
//  PhotoBrowerControllerAnimatedDelegate.m
//  stalk
//
//  Created by Coding on 28/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PhotoBrowerControllerAnimatedDelegate.h"

@implementation PhotoBrowerControllerAnimatedDelegate

- (instancetype)init{
    _popAnimator = [PopAnimator new];
    return self;
}

//-(id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController )presented presentingController:(UIViewController )presenting sourceController:(UIViewController *)source{
//    if()
//}

-(id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _popAnimator;
}
//-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id < UIViewControllerAnimatedTransitioning >)animator;
//-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id < UIViewControllerAnimatedTransitioning >)animator;
@end
