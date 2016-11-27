//
//  StatusTableViewCell.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusCell.h"
//#import "UIScreen+Additions.h"
//#import "NSString+Additions.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "WBStatusLayout.h"
#import "STalkTextAttachment.h"
#import "Emotion.h"
#import "AppDelegate.h"
#import "EmotionHelper.h"
#import "MLLinkLabel.h"
#import "AppDelegate.h"
#import "WBStatusHelper.h"


@interface WBStatusView()


@end

@implementation WBStatusView{
    BOOL _touchRetweetView;
}

- (instancetype)init{
    self = [super init];
    _contentView = [UIView new];
    self.width = CELL_WIDTH;
    _contentView.width = CELL_WIDTH;
    //头像
    _icon = [[UIImageView alloc] init];
    [self.contentView addSubview:_icon];
    
    _icon.frame = CGRectMake(PADDING, PADDING, ICONWIDTH, ICONWIDTH);
    _icon.layer.cornerRadius = ICONWIDTH>>1;
    _icon.clipsToBounds = YES;
    
    //名字
    _name = [[UILabel alloc] init];
    _name.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
    [self.contentView addSubview:_name];
    
    _name.frame = CGRectMake(ICONWIDTH + PADDING *2, PADDING, 250, 20);
    _from = [[UILabel alloc] init];
    _from.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5];
    [self.contentView addSubview:_from];
    _from.frame = CGRectMake(self.name.frame.origin.x, CGRectGetMaxY(self.name.frame) +PADDING, 250,ICONWIDTH -self.name.frame.size.height-PADDING);
    //内容
    _statusText = [[MLLinkLabel alloc] init];
    [self.contentView addSubview:_statusText];
    
    _pictureHolder = [UIView new];
    [self.contentView addSubview:_pictureHolder];
    _retweetContentView = [UIView new];
    _retweetText = [[MLLinkLabel alloc] init];
    _retweetContentView.backgroundColor = kWBCellInnerViewColor;
    [_retweetContentView addSubview:_retweetText];
    [self.contentView addSubview:_retweetContentView];
    
    _retweetPictureHolder = [[UIView alloc]init];
    [_retweetContentView addSubview:_retweetPictureHolder];
    
    [self addSubview:_contentView];
    return self;
}

- (void)setWithLayout:(WBStatusLayout *)layout{
    self.height = layout.height;
    _contentView.height = layout.height;
    _icon.imageURL =[NSURL URLWithString:layout.status.user.avatarLarge];
    _name.text =layout.status.user.screenName;
    _from.text = [NSString stringWithFormat:@"%@ 来自%@", [layout.status.createdAt substringToIndex:11], [ self sourceWithString:layout.status.source]];
    [self layoutStatusTextWithLayout:layout];
    [self layoutRetweetWithLayout:layout];
    [self addPicViewWithLayout:layout];
}

- (void)layoutStatusTextWithLayout:(WBStatusLayout *)layout{
    _statusText.numberOfLines = 0;
    _statusText.beforeAddLinkBlock = nil;
    _statusText.frame = layout.statusTextFrame;
    _statusText.dataDetectorTypes = MLDataDetectorTypeAll;
    __weak WBStatusView * weakSelf = self;
    [self.statusText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        
        [weakSelf.statusCell.delegate cell:weakSelf.statusCell didClickLink:link];
    }];
    self.statusText.attributedText = layout.statusAttributedText;

}

- (void)layoutRetweetWithLayout:(WBStatusLayout *)layout{
    if(layout.status.retweetedStatus){
        __weak WBStatusView * weakSelf = self;
        NSMutableAttributedString *attributedStr = layout.retweetAttributedText;
        _retweetContentView.frame = layout.retweetContentFrame;
        self.retweetText.numberOfLines = 0;
        self.retweetText.attributedText = attributedStr;
        self.retweetText.frame = layout.retweetTextFrame;
        self.retweetText.dataDetectorTypes = MLDataDetectorTypeAll;
        [self.retweetText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            [weakSelf.statusCell.delegate cell:weakSelf.statusCell didClickLink:link];
        }];
    }else{
        _retweetContentView.frame = CGRectZero;
        _retweetText.frame = CGRectZero;
        _retweetText.text = nil;
    }

}

- (void)addPicViewWithLayout:(WBStatusLayout *)layout{
    NSArray<WBPicture *> *pictures;
    WBStatus *status;
    UIView *picview;
    BOOL isRetweet = NO;
    
    for(UIView *view in _pictureHolder.subviews){
        [view removeFromSuperview];
    }
    _retweetPictureHolder.frame = CGRectZero;
    _pictureHolder.frame = CGRectZero;
    for(UIView *view in _retweetPictureHolder.subviews){
        [view removeFromSuperview];
    }
    
    if(layout.retweetPicFrame.size.height>0){
        status = layout.status.retweetedStatus;
        pictures = layout.status.retweetedStatus.pictures;
        picview = _retweetPictureHolder;
        isRetweet = YES;
        _retweetPictureHolder.frame = layout.retweetPicFrame;
    }else if(layout.statusPictureFrame.size.height >0){
        status = layout.status;
        pictures = layout.status.pictures;
        picview = _pictureHolder;
        _pictureHolder.frame = layout.statusPictureFrame;
    }
    
    if(pictures.count>0){
        for (NSInteger i=0; i<pictures.count&& i<9; i++) {
            YYAnimatedImageView *thumbView = [self _newImageViewWithTag:i];;
            [picview addSubview:thumbView];
            thumbView.frame = CGRectMake(i%3*(SIZE_GAP_IMG+layout.imgWidth), i/3*(SIZE_GAP_IMG+layout.imgHeight), layout.imgWidth, layout.imgHeight);
            thumbView.backgroundColor = isRetweet? kWBCellInnerViewColor : kWBCellBackgroundColor;
            thumbView.autoPlayAnimatedImage =NO;
            NSURL *url = pictures[i].bmiddle.url ? : pictures[i].thumbnail.url ? : pictures[i].original.url;

            __weak __typeof__(thumbView) weakThumb = thumbView;
            [thumbView.layer setImageWithURL:[WBStatusHelper defaultURLForImageURL:url] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                NSLog(@"fromtype: %ld", from);
                if(!image) return;
                if(stage != YYWebImageStageFinished) return;
                int width = image.size.width;
                int height = image.size.height;
                if(pictures.count==1 && (width<height)){
                    
                    weakThumb.width = 9.0/16*weakThumb.height;
                }
                CGFloat scale = (height / width) / (weakThumb.height / weakThumb.width);
                if (scale < 0.99 || isnan(scale)) {
                    weakThumb.contentMode = UIViewContentModeScaleAspectFill;
                    weakThumb.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                } else {
                    
                    weakThumb.contentMode = UIViewContentModeScaleToFill;
                    weakThumb.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                }
                weakThumb.image = image;
                if (from != YYWebImageFromMemoryCacheFast) {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.15;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                    transition.type = kCATransitionFade;
                    [weakThumb.layer addAnimation:transition forKey:@"contents"];
                }
            }];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
                NSLog(@"图片 %ld 被点击",thumbView.tag );
                [self.statusCell.delegate cell:self.statusCell didClickImageAt:thumbView.tag];
            }];
            [thumbView addGestureRecognizer:recognizer];
            UIView *badge = [UIImageView new];
            badge.userInteractionEnabled = NO;
            badge.contentMode = UIViewContentModeScaleAspectFit;
            badge.size = CGSizeMake(56 / 2, 36 / 2);
            badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            badge.right = thumbView.width;
            badge.bottom = thumbView.height;
            badge.hidden = YES;

            [thumbView addSubview:badge];
            switch (pictures[i].original.badgeType) {
                case WBPictureBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                } break;
                case WBPictureBadgeTypeLong: {
                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_longimage"].CGImage);
                    badge.hidden = NO;
                } break;
                case WBPictureBadgeTypeGIF: {
                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_gif"].CGImage);
                    badge.hidden = NO;
//                    __weak __typeof__(thumbView) weakThumb = thumbView;
//                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//                        weakThumb.autoPlayAnimatedImage = !weakThumb.autoPlayAnimatedImage;
//                    }];
//                    [badge addGestureRecognizer:tap];
                } break;
            }

        }
    }

}

- (YYAnimatedImageView *)_newImageViewWithTag:(NSUInteger)tag{
    YYAnimatedImageView *thumbView = [[YYAnimatedImageView alloc] init];
    thumbView.contentMode = UIViewContentModeScaleAspectFill;
    thumbView.backgroundColor = [UIColor lightGrayColor];
    thumbView.tag = tag;
    thumbView.userInteractionEnabled = YES;
    thumbView.clipsToBounds = YES;
    return thumbView;
}

- (void)tapImageGesture:(UIGestureRecognizer *)recognizer{
    NSLog(@"图片 %ld 被点击",recognizer.view.tag );
    [self.statusCell.delegate cell:self.statusCell didClickImageAt:recognizer.view.tag];
}

- (NSString *) sourceWithString:(NSString *)source{
    u_long i = source.length-1;
    char j=0;
    for(; i>0; i--){
        if([source characterAtIndex:i] == '>'){
            if(j==1)break;
            j++;
        }
    }
    return [source substringWithRange:NSMakeRange(i+1, source.length-4 -i-1 )];
}

- (NSString *)imageFilePath:(NSString *)urlstr{
    u_long i = urlstr.length-1;
    for(; i>0; i--){
        if([urlstr characterAtIndex:i] == '/'){
            break;
        }
    }
    return [urlstr substringToIndex:i+1];
}

- (NSString *)imageName:(NSString *)urlstr{
    u_long i = urlstr.length-1;
    for(; i>0; i--){
        if([urlstr characterAtIndex:i] == '/'){
            break;
        }
    }
    return [urlstr substringFromIndex:i+1];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(_retweetContentView.frame, location)){
        _touchRetweetView = YES;
        [_retweetContentView performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
    }else{
        [self performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
         _touchRetweetView = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    [self touchesRestoreBackgroundColor];
    if (_touchRetweetView) {
        if ([_statusCell.delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_statusCell.delegate cellDidClickRetweet:_statusCell];
        }
    } else {
        if(CGRectContainsPoint(_icon.frame, location) || CGRectContainsPoint(_name.frame, location)){
            [_statusCell.delegate cellDidClickUser:_statusCell];
        }else{
            [_statusCell.delegate cellDidClick:_statusCell];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetContentView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];

    self.backgroundColor = [UIColor whiteColor];
    _retweetContentView.backgroundColor = kWBCellInnerViewColor;
}
@end

//@implementation WBStatusToolbarView
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (frame.size.width == 0 && frame.size.height == 0) {
//        frame.size.width =  CELL_WIDTH;
//        frame.size.height = kWBCellToolbarHeight;
//    }
//    self = [super initWithFrame:frame];
//    self.exclusiveTouch = YES;
//    
//    _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _repostButton.exclusiveTouch = YES;
//    _repostButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
//    [_repostButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    
//    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _commentButton.exclusiveTouch = YES;
//    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
//    _commentButton.left = CGFloatPixelRound(self.width / 3.0);
//    [_commentButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    
//    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _likeButton.exclusiveTouch = YES;
//    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
//    _likeButton.left = CGFloatPixelRound(self.width / 3.0 * 2.0);
//    [_likeButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    NSString *bundleName = @"ResourceWeibo.bundle";
//    _repostImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[bundleName stringByAppendingPathComponent:@"timeline_icon_retweet"]]];
//    _repostImageView.centerY = self.height / 2;
//    [_repostButton addSubview:_repostImageView];
//    _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[bundleName stringByAppendingPathComponent:@"timeline_icon_comment"]]];
//    _commentImageView.centerY = self.height / 2;
//    [_commentButton addSubview:_commentImageView];
//    _likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[bundleName stringByAppendingPathComponent:@"timeline_icon_unlike"]]];
//    _likeImageView.centerY = self.height / 2;
//    [_likeButton addSubview:_likeImageView];
//    
//    _repostLabel = [YYLabel new];
//    _repostLabel.userInteractionEnabled = NO;
//    _repostLabel.height = self.height;
//    _repostLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    _repostLabel.displaysAsynchronously = YES;
//    _repostLabel.ignoreCommonProperties = YES;
//    _repostLabel.fadeOnHighlight = NO;
//    _repostLabel.fadeOnAsynchronouslyDisplay = NO;
//    [_repostButton addSubview:_repostLabel];
//    
//    _commentLabel = [YYLabel new];
//    _commentLabel.userInteractionEnabled = NO;
//    _commentLabel.height = self.height;
//    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    _commentLabel.displaysAsynchronously = YES;
//    _commentLabel.ignoreCommonProperties = YES;
//    _commentLabel.fadeOnHighlight = NO;
//    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
//    [_commentButton addSubview:_commentLabel];
//    
//    _likeLabel = [YYLabel new];
//    _likeLabel.userInteractionEnabled = NO;
//    _likeLabel.height = self.height;
//    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//    _likeLabel.displaysAsynchronously = YES;
//    _likeLabel.ignoreCommonProperties = YES;
//    _likeLabel.fadeOnHighlight = NO;
//    _likeLabel.fadeOnAsynchronouslyDisplay = NO;
//    [_likeButton addSubview:_likeLabel];
//    
//    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
//    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
//    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
//    NSArray *locations = @[@0.2, @0.5, @0.8];
//    
//    _line1 = [CAGradientLayer layer];
//    _line1.colors = colors;
//    _line1.locations = locations;
//    _line1.startPoint = CGPointMake(0, 0);
//    _line1.endPoint = CGPointMake(0, 1);
//    _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
//    _line1.left = _repostButton.right;
//    
//    _line2 = [CAGradientLayer layer];
//    _line2.colors = colors;
//    _line2.locations = locations;
//    _line2.startPoint = CGPointMake(0, 0);
//    _line2.endPoint = CGPointMake(0, 1);
//    _line2.size = CGSizeMake(CGFloatFromPixel(1), self.height);
//    _line2.left = _commentButton.right;
//    
//    _topLine = [CALayer layer];
//    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
//    _topLine.backgroundColor = kWBCellLineColor.CGColor;
//    
//    _bottomLine = [CALayer layer];
//    _bottomLine.size = _topLine.size;
//    _bottomLine.bottom = self.height;
//    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
//    
//    [self addSubview:_repostButton];
//    [self addSubview:_commentButton];
//    [self addSubview:_likeButton];
//    [self.layer addSublayer:_line1];
//    [self.layer addSublayer:_line2];
//    [self.layer addSublayer:_topLine];
//    [self.layer addSublayer:_bottomLine];
//    
//    @weakify(self);
//    [_repostButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//        WBStatusCell *cell = weak_self.cell;
//        if ([cell.delegate respondsToSelector:@selector(cellDidClickRepost:)]) {
//            [cell.delegate cellDidClickRepost:cell];
//        }
//    }];
//    
//    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//        WBStatusCell *cell = weak_self.cell;
//        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
//            [cell.delegate cellDidClickComment:cell];
//        }
//    }];
//    
//    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//        WBStatusCell *cell = weak_self.cell;
//        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
//            [cell.delegate cellDidClickLike:cell];
//        }
//    }];
//    return self;
//}
//
//- (void)setWithLayout:(WBStatusLayout *)layout {
//    _repostLabel.width = 30;
//    _commentLabel.width = 30;
//    _likeLabel.width = 30;
//    
//    [self adjustImage:_repostImageView label:_repostLabel inButton:_repostButton];
//    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
//    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
//    
//    _likeImageView.image = layout.status.attitudesCount>0 ? [self likeImage] : [self unlikeImage];
//}
//
//- (UIImage *)likeImage {
//    static UIImage *img;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        img = [WBStatusHelper imageNamed:@"timeline_icon_like"];
//    });
//    return img;
//}
//
//- (UIImage *)unlikeImage {
//    static UIImage *img;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        img = [WBStatusHelper imageNamed:@"timeline_icon_unlike"];
//    });
//    return img;
//}
//
//- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
//    CGFloat imageWidth = image.bounds.size.width;
//    CGFloat labelWidth = label.width;
//    CGFloat paddingMid = 5;
//    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
//    image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2);
//    label.right = CGFloatPixelRound(button.width - paddingSide);
//}
//
//@end


@interface WBStatusCell ()

@end

@implementation WBStatusCell

- (void)setFrame:(CGRect)frame {
    CGFloat startX = ( [UIScreen mainScreen].bounds.size.width-CELL_WIDTH)/2;
    frame.origin.x += startX;
    frame.size.width -= 2 * startX;
    frame.size.height -= CellPadding;
    [super setFrame:frame];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    //先在缓存池中取
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    //缓存池中没有再创建，并添加标识，cell移出屏幕时放入缓存池以复用
    if (cell == nil) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //取消点击高亮状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _statusView  = [[WBStatusView alloc] init];
        _statusView.statusCell = self;
        [self.contentView addSubview:_statusView];
    }
    return self;
}

//重写set方法，模型传递
- (void)setLayout:(WBStatusLayout *)layout{
    _layout = layout;
    [self.statusView setWithLayout:_layout];
}



@end
