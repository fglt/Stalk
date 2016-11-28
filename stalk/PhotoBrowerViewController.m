//
//  PhotoBrowerViewController.m
//  stalk
//
//  Created by Coding on 26/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//
/**2016-11-27 20:41:05让keyWindow加载此ViewController;
 **解决了退出时背景问题；
 **但是UIActivityController不能正常显示；
 **/

#import "PhotoBrowerViewController.h"
#import "PhotoBrowerControllerAnimatedDelegate.h"
#import "PhotoBrowerView.h"

@interface PhotoBrowerViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@property (nonatomic) BOOL rotation;
@property (nonatomic, strong) PhotoBrowerControllerAnimatedDelegate *animatedDelegate;

@end

@implementation PhotoBrowerViewController

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    _rotation = YES;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        CGPoint c = CGPointMake(self.view.width/2, self.view.height/2);
//        _contentView.frame = self.view.bounds;
//        _contentView.center = c;
//        _indexLabel.center =  CGPointMake(self.view.width / 2, self.view.height - 30);
        
        _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, 1);
        _scrollView.contentOffset = CGPointMake(_currentIndex *_scrollView.width, _scrollView.contentOffset.y);
        for (int i=0; i<_cells.count; i++){
            YYPhotoGroupCell *cell = (YYPhotoGroupCell *)_cells[i];
            /**
              cell.frame = cell.superview.bounds;
              cell的父View可能为空；此时cell的frame为cgpointzero。导致不显示内容；
              修复bug
             **/
            CGFloat left = _scrollView.width * cell.page + ScrollViewCellPadding / 2;
            cell.frame = CGRectMake(left, 0, self.view.width, self.view.height);
            cell.zoomScale = 1;
            [cell resizeSubviewSize];
        }
        
//        for (int i=0; i<_scrollView.subviews.count; i++){
//            YYPhotoGroupCell *cell = (YYPhotoGroupCell *) _scrollView.subviews[i];
//            cell.origin = CGPointMake(_scrollView.width * cell.page + kPadding / 2, 0);
//            //修复bug：应为cell复用，cell在——scrollView加入的顺序不能作为计算器坐标的参数。而要用cell的page属性；
//            //cell.origin = CGPointMake(_scrollView.width * i + kPadding / 2, 0);
//        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _rotation = NO;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _animatedDelegate = [PhotoBrowerControllerAnimatedDelegate new];
    self.transitioningDelegate = _animatedDelegate;
    [self start];
    [self startBrowing:YES completion:nil];
}

- (void)show{
    /***
     使用addChildViewController的方式好处是消失时会显示将要显示的viewcontroller，
     但不能正常显示uiactivitycontroller，也不能隐藏状态栏。
     使用presentViewController的方式则在消失前背景是黑的；
     但是能正常显示uiactivitycontroller，也能隐藏状态栏
     ***/
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self.view];
//    [window.rootViewController addChildViewController:self];
//    [self didMoveToParentViewController:window.rootViewController];
    
    [window.rootViewController presentViewController:self animated:NO completion:nil];
    
//    [self startBrowing:YES completion:nil];
}

- (void) dismissSelf{
    //[self.view removeFromSuperview];
    //[self willMoveToParentViewController:nil];
    //[self removeFromParentViewController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) start{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithTap)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self.view addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [self.view addGestureRecognizer:press];
    
    if (kSystemVersion >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
        pan.delegate = self;
    }
    
    _cells = @[].mutableCopy;
    
    _backgroundView = UIView.new;
    _backgroundView.frame = self.view.bounds;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.view.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-ScrollViewCellPadding / 2, 0, self.view.width + ScrollViewCellPadding, self.view.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = _groupItems.count > 1;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _indexLabel = [UILabel new];
    _indexLabel.width = 80;
    _indexLabel.height = 40;
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:16];
    _indexLabel.center = CGPointMake(self.view.width / 2, self.view.height - 30);
    _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_backgroundView];
    [self.view addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_indexLabel];
//    
//    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *contentWidth = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
//    NSLayoutConstraint *contentHeight = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
//    NSLayoutConstraint *contentCenterX = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//    NSLayoutConstraint *contentCenterY = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
//    [self.view addConstraints:@[contentWidth, contentHeight,contentCenterX,contentCenterY]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startBrowing:(BOOL)animated completion:(void (^)(void))completion{
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (_fromView == ((YYPhotoGroupItem *)self.groupItems[i]).fromView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    self.currentIndex = page;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, 1);
    CGRect visable = CGRectMake(_scrollView.width * _currentIndex, 0, _scrollView.width, 1);
    [_scrollView scrollRectToVisible:visable animated:NO];
    
    /**bug:下面这一句必须有，否则下面的cell为空，点击第一张图片就不会有下面对应的动画效果;
     因为上面的[_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _currentIndex, 0, _scrollView.width, _scrollView.height) animated:NO];这一句在点击第一张图片时，不会触发——scrollView的contentoffset改变就不会自动触发scrollViewDidScroll 这个函数
     2016-11-25 20:39:48
     **/
    [self scrollViewDidScroll:_scrollView];
    [UIView setAnimationsEnabled:YES];
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentIndex];
    YYPhotoGroupItem *item = _groupItems[self.currentIndex];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeMemory]) {
            cell.item = item;
        }
    }
    if (!cell.item) {
        cell.imageView.image = item.thumbImage;
        [cell resizeSubviewSize];
    }
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
    
    cell.imageContainerView.clipsToBounds = NO;
    cell.imageView.frame = fromFrame;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    float oneTime = animated ? 0.2 : 0;
    
    _scrollView.userInteractionEnabled = NO;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.imageView.frame = cell.imageContainerView.bounds;
        cell.imageView.layer.transformScale = 1.01;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.layer.transformScale = 1.0;
        }completion:^(BOOL finished) {
            cell.imageContainerView.clipsToBounds = YES;
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
        }];
    }];
    
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    self.view.backgroundColor = [UIColor clearColor];
    _backgroundView.backgroundColor = [UIColor clearColor];
    YYPhotoGroupCell *cell = [self cellForPage:_currentIndex];
    YYPhotoGroupItem *item = _groupItems[_currentIndex];
    
    UIView *fromView = nil;

    fromView = item.fromView;
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    fromView.hidden= YES;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (fromView == nil) {
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.scrollView.layer.transformScale = 0.95;
            self.scrollView.alpha = 0;
        }completion:^(BOOL finished) {
            self.scrollView.layer.transformScale = 1;
            [self dismissSelf];
        }];
        return;
    }
    
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        if (isFromImageClipped) {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            cell.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [self dismissSelf];
    }];
}

- (void)disappearModeTap{
    //    YYPhotoGroupCell *cell = [self cellForPage:_currentIndex];
    //    YYPhotoGroupItem *item = _groupItems[_currentIndex];
    //
    //    UIImageView *fromView = (UIImageView *)item.thumbView;
    //    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    //
    //        if (isFromImageClipped) {
    //            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:self.view];
    //            cell.imageView.height = cell.height/cell.zoomScale;
    //            cell.imageView.layer.contentsRect = CGRectMake(0, 0, 1, cell.imageView.height*fromFrame.size.width/fromFrame.size.height/cell.imageContainerView.height);
    //        }
    YYPhotoGroupCell *cell = [self cellForPage:_currentIndex];
    YYPhotoGroupItem *item = _groupItems[_currentIndex];
    
    UIView *fromView = item.fromView;
    
    BOOL isFromImageClipped = [item thumbClippedToTop];
    
    if (fromView == nil) {
        self.scrollView.alpha = 0;
        self.scrollView.layer.transformScale = 1;
        return;
    }
    if (isFromImageClipped) {
        
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
        CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
        if (isnan(height)) height = cell.imageContainerView.height;
        
        cell.imageContainerView.height = height;
        cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
        cell.imageContainerView.transform = CGAffineTransformMakeScale(scale, scale);
    } else {
        CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.contentMode = fromView.contentMode;
        cell.imageView.frame = fromFrame;
    }

}
- (void)dismissAppearModeTop{
    _backgroundView.alpha = 0;
    _scrollView.bottom = 0;
}

- (void)dismissAppearModeBottom{
    _backgroundView.alpha = 0;
    _scrollView.top = self.view.height;
}
- (void)dismissAntimateWithMode:(ControllerDisappearMode)disappearMode{

    switch (disappearMode) {
        case ControllerDisappearModeTap:
            [self disappearModeTap];
            break;
        case ControllerDisappearModeTop:
            [self dismissAppearModeTop];
            break;
        case ControllerDisappearModeBottom:
            [self dismissAppearModeBottom];
            break;
        default:
            break;
    }
}

- (void)dismissWithTap {
    _disappearMode = ControllerDisappearModeTap;
    _indexLabel.hidden= YES;
    YYPhotoGroupCell *cell = [self cellForPage:_currentIndex];
    YYPhotoGroupItem *item = _groupItems[_currentIndex];
    
    UIView *fromView = item.fromView;
    fromView.hidden = YES;
    [self cancelAllImageLoad];
    _isPresented = NO;
    
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame =frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }

    [self dismissSelf];
}

- (void)dismissTopOrBottom{
    _indexLabel.hidden= YES;
    [self cancelAllImageLoad];
    _isPresented = NO;
    [self dismissSelf];
}

- (UIView *)currentFromView{
    return  _groupItems[_currentIndex].fromView;
}

- (void)setGroupItems:(NSArray *)groupItems{
    _groupItems = groupItems.copy;
    [_cells removeAllObjects];
}

- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(YYPhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex{
    _currentIndex = currentIndex;
    _indexLabel.text = [NSString stringWithFormat:@"%ld /%ld", _currentIndex+1,_groupItems.count];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(_rotation) return;
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    self.currentIndex = intPage;
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            YYPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                YYPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = (self.view.width + ScrollViewCellPadding) * i + ScrollViewCellPadding / 2;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/// dequeue a reusable cell
- (YYPhotoGroupCell *)dequeueReusableCell {
    YYPhotoGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [YYPhotoGroupCell new];
    cell.frame = self.view.bounds;
    cell.imageContainerView.frame = self.view.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (YYPhotoGroupCell *)cellForPage:(NSInteger)page {
    for (YYPhotoGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}


- (void)showHUD:(NSString *)msg {
    if (!msg.length) return;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [msg sizeForFont:font size:CGSizeMake(200, 200) mode:NSLineBreakByCharWrapping];
    UILabel *label = [UILabel new];
    label.size = CGSizePixelCeil(size);
    label.font = font;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    UIView *hud = [UIView new];
    hud.size = CGSizeMake(label.width + 20, label.height + 20);
    hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.650];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 8;
    
    label.center = CGPointMake(hud.width / 2, hud.height / 2);
    [hud addSubview:label];
    
    hud.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    hud.alpha = 0;
    [self.view addSubview:hud];
    
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha = 1;
    }];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    });
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    YYPhotoGroupCell *tile = [self cellForPage:_currentIndex];
    if (tile) {
        if (tile.zoomScale > 1 || tile.zoomScale <1) {
            [tile setZoomScale:1 animated:YES];
        } else if(tile.maximumZoomScale>1){
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.view.width / newZoomScale;
            CGFloat ysize = self.view.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
            
        }else{
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.minimumZoomScale;
            CGFloat xsize = self.view.width / newZoomScale;
            CGFloat ysize = self.view.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
        [tile resetAlwaysBounceVertical];
    }
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
    if (!_isPresented) return;
    if(recognizer.state != UIGestureRecognizerStateBegan) return;
    
    YYPhotoGroupCell *tile = [self cellForPage:self.currentIndex];
    if (!tile.imageView.image) return;
    
    // try to save original image data if the image contains multi-frame (such as GIF/APNG)
    id imageItem = [tile.imageView.image imageDataRepresentation];
    YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem));
    if (type != YYImageTypePNG &&
        type != YYImageTypeJPEG &&
        type != YYImageTypeGIF) {
        imageItem = tile.imageView.image;
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *  returnedItems, NSError * activityError){
        NSLog(@"ok");
    };
    
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectInset(self.view.bounds, self.view.bounds.size.width/4, self.view.bounds.size.height/4);
        activityViewController.popoverPresentationController.permittedArrowDirections = UIMenuControllerArrowDefault;
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToTwitter];
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self.view];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.top = deltaY;
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _backgroundView.alpha = alpha;
            } completion:nil];

        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self.view];
            CGPoint p = [g locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.bottom : self.view.height - _scrollView.top) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                if (moveToTop) {
                    _disappearMode = ControllerDisappearModeTop;
                } else {
                    _disappearMode = ControllerDisappearModeBottom;
                }

                [self dismissTopOrBottom];
//                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
//                    _backgroundView.alpha = 0;
//                    if (moveToTop) {
//                        _scrollView.bottom = 0;
//                    } else {
//                        _scrollView.top = self.view.height;
//                    }
//                } completion:^(BOOL finished) {
//                    [self cancelAllImageLoad];
//                    [self animatationDidEnd];
//                }];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.top = 0;
                    _backgroundView.alpha =1;

                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _scrollView.top = 0;
        }
        default:break;
    }
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
