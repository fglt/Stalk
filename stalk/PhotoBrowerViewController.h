//
//  PhotoBrowerViewController.h
//  stalk
//
//  Created by Coding on 26/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ControllerDisappearMode) {
    ControllerDisappearModeTap=0,
    ControllerDisappearModeTop,
    ControllerDisappearModeBottom
};

@class YYPhotoGroupItem;

@interface PhotoBrowerViewController : UIViewController
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, copy) NSArray<YYPhotoGroupItem *> *groupItems;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) ControllerDisappearMode disappearMode;
- (void)show;
- (void)dismissAntimateWithMode:(ControllerDisappearMode)disappearMode;
- (UIView *)currentFromView;
@end
