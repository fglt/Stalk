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

@interface YYPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end

@interface YYPhotoGroupCell : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) YYPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;


- (void)resetAlwaysBounceVertical;
- (void)resizeSubviewSize;
@end

@interface PhotoBrowerViewController : UIViewController
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, copy) NSArray<YYPhotoGroupItem *> *groupItems;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) ControllerDisappearMode disappearMode;
- (void)show;
- (void)dismissAntimateWithMode:(ControllerDisappearMode)disappearMode;
- (UIView *)currentFromView;
@end
