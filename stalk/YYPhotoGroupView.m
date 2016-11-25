 //
//  YYPhotoGroupView.m
//
//  Created by ibireme on 14/3/9.
//  Copyright (C) 2014 ibireme. All rights reserved.
//

#import "YYPhotoGroupView.h"
#import "YYKit.h"

#define kPadding 20
#define kHiColor [UIColor colorWithRGBHex:0x2dd6b8]


@interface YYPhotoGroupItem()<NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
@implementation YYPhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

- (id)copyWithZone:(NSZone *)zone {
    YYPhotoGroupItem *item = [self.class new];
    return item;
}
@end


@interface YYPhotoGroupCell :UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) YYPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;

- (void)resizeSubviewSize;
@end

@implementation YYPhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    _imageView = [YYAnimatedImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /***
     ***[self resizeSubviewSize];
     ***这个函数不能放到layoutSubviews中;因为缩放会使得layoutSubviews被调用，这样导致子View的大小不能变化，
     ***也就是不能缩放，当旋转时，应该在其他被触发的函数中调用resizeSubviewSize，比如父View的
     ***layoutSubviews中调用，同时还要设置缩放为默认值即1.0；
     ***/
    //[self resizeSubviewSize];
    _progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)setItem:(YYPhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView cancelCurrentImageRequest];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    @weakify(self);
    [_imageView setImageWithURL:item.largeImageURL placeholder:item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        @strongify(self);
        if (!self) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        @strongify(self);
        if (!self) return;
        self.progressLayer.hidden = YES;
        if (stage == YYWebImageStageFinished) {
            self.maximumZoomScale = 3;
            if (image) {
                self->_itemDidLoad = YES;
                
                [self resizeSubviewSize];
                [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
            }
        }
        
    }];
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
//        _imageContainerView.height = self.height;
//        _imageContainerView.width = self.height *image.size.width/image.size.height;
//        _imageContainerView.centerX = self.width / 2;
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(_imageContainerView.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end












@interface YYPhotoGroupView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
//@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@property (nonatomic) BOOL rotation;
@end

@implementation YYPhotoGroupView

- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    
    self.backgroundColor = [UIColor blackColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    if (kSystemVersion >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGesture = pan;
    }
    
    _cells = @[].mutableCopy;

    _contentView = UIView.new;
    _contentView.frame = self.bounds;
  
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _indexLabel = [UILabel new];
    _indexLabel.width = 80;
    _indexLabel.height = 40;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:16];
    _indexLabel.center = CGPointMake(self.width / 2, self.height - 30);
    
//    _pager = [[UIPageControl alloc] init];
//    _pager.hidesForSinglePage = YES;
//    _pager.userInteractionEnabled = NO;
//    _pager.width = 120;
//    _pager.height = 10;
//    _pager.center = CGPointMake(self.width / 2, self.height - 18);

    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
//    [_contentView addSubview:_pager];
    [_contentView addSubview:_indexLabel];
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGPoint c = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    

    _rotation = YES;
    
    _contentView.frame = self.bounds;
    _contentView.center = c;
    //_pager.center = CGPointMake(self.width / 2, self.height - 18);
    _indexLabel.center =  CGPointMake(self.width / 2, self.height - 30);
    _scrollView.contentOffset = CGPointMake(_currentIndex *_scrollView.width, _scrollView.contentOffset.y);
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    for (int i=0; i<_cells.count; i++){
        YYPhotoGroupCell *cell = (YYPhotoGroupCell *)_cells[i];
        cell.frame = self.bounds;
        cell.zoomScale = 1;
        [cell resizeSubviewSize];
    }

    for (int i=0; i<_scrollView.subviews.count; i++){
        YYPhotoGroupCell *cell = (YYPhotoGroupCell *) _scrollView.subviews[i];
        cell.origin = CGPointMake(_scrollView.width * cell.page + kPadding / 2, 0);
        //修复bug：应为cell复用，cell在——scrollView加入的顺序不能作为计算器坐标的参数。而要用cell的page属性；
        //cell.origin = CGPointMake(_scrollView.width * i + kPadding / 2, 0);
    }
    _rotation = NO;
    [self scrollViewDidScroll:_scrollView];
    
}

- (void)presentFromImageView:(UIView *)fromView
                 coContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion{
    _fromView = fromView;
    if(!container){
        _toContainerView = [UIApplication sharedApplication].keyWindow;
    }else{
        _toContainerView = container;
    }
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((YYPhotoGroupItem *)self.groupItems[i]).thumbView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    self.currentIndex = page;
    // _indexLabel.text = [NSString stringWithFormat:@"%ld /%ld", _currentIndex,_groupItems.count];
    self.size = _toContainerView.size;
    //    self.pager.alpha = 0;
    //    self.pager.numberOfPages = self.groupItems.count;
    //    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [_toContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_toContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_toContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_toContainerView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _currentIndex, 0, _scrollView.width, _scrollView.height) animated:NO];
    
    /**bug:下面这一句必须有，否则下面的cell为空，点击第一张图片就不会有下面对应的动画效果;
     因为上面的[_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];这一句在点击第一张图片时，不会触发——scrollView的contentoffset改变就不会自动触发scrollViewDidScroll 这个函数
     2016-11-25 20:39:48
     **/
    [self scrollViewDidScroll:_scrollView];
    [UIView setAnimationsEnabled:YES];
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    YYPhotoGroupItem *item = _groupItems[self.currentPage];
    
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
            // _pager.alpha = 1;
        }completion:^(BOOL finished) {
            cell.imageContainerView.clipsToBounds = YES;
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
            //[self hidePager];
        }];
    }];

}
- (void)presentFromImageView:(UIView *)fromView
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion{
    _fromView = fromView;
    _toContainerView = [UIApplication sharedApplication].keyWindow;
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((YYPhotoGroupItem *)self.groupItems[i]).thumbView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    self.currentIndex = page;
   // _indexLabel.text = [NSString stringWithFormat:@"%ld /%ld", _currentIndex,_groupItems.count];
    self.size = _toContainerView.size;
//    self.pager.alpha = 0;
//    self.pager.numberOfPages = self.groupItems.count;
//    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [_toContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_toContainerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [_toContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_toContainerView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _currentIndex, 0, _scrollView.width, _scrollView.height) animated:NO];
    
    /**bug:下面这一句必须有，否则下面的cell为空，点击第一张图片就不会有下面对应的动画效果;
           因为上面的[_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];这一句在点击第一张图片时，不会触发——scrollView的contentoffset改变就不会自动触发scrollViewDidScroll 这个函数
     2016-11-25 20:39:48
     **/
    [self scrollViewDidScroll:_scrollView]; 
    [UIView setAnimationsEnabled:YES];
    
    YYPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    YYPhotoGroupItem *item = _groupItems[self.currentPage];
    
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
           // _pager.alpha = 1;
        }completion:^(BOOL finished) {
            cell.imageContainerView.clipsToBounds = YES;
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
            //[self hidePager];
        }];
    }];
}


- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    NSInteger currentPage = self.currentPage;
    YYPhotoGroupCell *cell = [self cellForPage:currentPage];
    YYPhotoGroupItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
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
            self.alpha = 0.0;
            self.scrollView.layer.transformScale = 0.95;
            self.scrollView.alpha = 0;
//            self.pager.alpha = 0;
        }completion:^(BOOL finished) {
            self.scrollView.layer.transformScale = 1;
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
//        _pager.alpha = 0.0;
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
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
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
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            YYPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                YYPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = _scrollView.width * i + kPadding / 2;
                
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
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
//    _pager.currentPage = intPage;
    self.currentIndex = intPage;
 //   _indexLabel.text = [NSString stringWithFormat:@"%ld /%ld", _currentIndex,_groupItems.count];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//        _pager.alpha = 1;
//    }completion:^(BOOL finish) {
//    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (!decelerate) {
//        //[self hidePager];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self hidePager];
}


//- (void)hidePager {
//    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
//        _pager.alpha = 0;
//    }completion:^(BOOL finish) {
//    }];
//}

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
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
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

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
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
    
    hud.center = CGPointMake(self.width / 2, self.height / 2);
    hud.alpha = 0;
    [self addSubview:hud];
    
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
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
    if (!_isPresented) return;
    if(recognizer.state != UIGestureRecognizerStateBegan) return;
    
    YYPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (!tile.imageView.image) return;
    
    // try to save original image data if the image contains multi-frame (such as GIF/APNG)
    id imageItem = [tile.imageView.image imageDataRepresentation];
    YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem));
    if (type != YYImageTypePNG &&
        type != YYImageTypeJPEG &&
        type != YYImageTypeGIF) {
        imageItem = tile.imageView.image;
    }
    UIViewController *toVC;
    toVC = self.viewController ? :[self topViewController];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *  returnedItems, NSError * activityError){
        NSLog(@"ok");
    };
    
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self;
        activityViewController.popoverPresentationController.sourceRect = CGRectInset(self.bounds, self.bounds.size.width/4, self.bounds.size.height/4);
        activityViewController.popoverPresentationController.permittedArrowDirections = UIMenuControllerArrowDefault;
    }
    
    [toVC presentViewController:activityViewController animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.top = deltaY;
            
//            CGFloat alphaDelta = 160;
//            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
//            alpha = YY_CLAMP(alpha, 0, 1);
//            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
//                _pager.alpha = alpha;
//            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.bottom : self.height - _scrollView.top) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
//                    _pager.alpha = 0;
                    if (moveToTop) {
                        _scrollView.bottom = 0;
                    } else {
                        _scrollView.top = self.height;
                    }
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.top = 0;
//                    _pager.alpha = 1;
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
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
