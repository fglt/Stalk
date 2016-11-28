//
//  PhotoBrowerView.h
//  stalk
//
//  Created by Coding on 27/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScrollViewCellPadding 20

@interface YYPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
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

@interface PhotoBrowerView : UIView
@property (nonatomic, strong) UIImage *backImg;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, copy) NSArray<YYPhotoGroupItem *> *groupItems;
- (instancetype)initWithItems:(NSArray<YYPhotoGroupItem *> *)items;
- (void)showWithAnimate:(BOOL)animated;
@end
