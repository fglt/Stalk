//
//  PopAnimator.m
//  NavigationTransitionController
//
//  Created by Coding on 28/11/2016.
//  Copyright © 2016 Chris Eidhof. All rights reserved.
//

#import "PopAnimator.h"
#import "PhotoBrowerViewController.h"

@implementation PopAnimator
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
     toViewController.view.frame = fromViewController.view.frame;
    
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    PhotoBrowerViewController *from = (PhotoBrowerViewController *)fromViewController;
    
    from.backgroundView.backgroundColor = [UIColor clearColor];
    UIView *disAppear= [from currentFromView];
//    CGRect dest = from.disAppearRect;
//    if(toViewController.prefersStatusBarHidden)
//    if(![UIApplication sharedApplication].statusBarHidden){
//        dest.origin.y +=20;
//    }
//    if(CGRectEqualToRect(dest, CGRectZero)){
//        dest = CGRectMake(from.view.width/4, from.view.height/4, from.view.width/2, from.view.height/2);
//    }
//    CGAffineTransform translation = CGAffineTransformMakeTranslation(CGRectGetMidX(dest)-CGRectGetMidX(from.view.frame), CGRectGetMidY(dest)-CGRectGetMidY(from.view.frame));
//    
//    CGAffineTransform scale = CGAffineTransformMakeScale(dest.size.width/from.view.size.width, dest.size.height/from.view.size.height);
//    CGAffineTransform tran = CGAffineTransformConcat(scale, translation);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //fromViewController.view.transform = tran;
         [from dismissAntimateWithMode:from.disappearMode];;
    } completion:^(BOOL finished) {
        fromViewController.view.alpha = 0;
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        disAppear.hidden = NO;
    }];
}

@end
