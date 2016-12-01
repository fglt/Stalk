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

@implementation WBUserView

- (instancetype)init{
    self= [super init];
    self.frame = CGRectMake(0, 0, CellContentWidth, ICONWIDTH);
    _icon = [[UIImageView alloc] init];
    
    _icon.frame = CGRectMake(PADDING, 0, ICONWIDTH, ICONWIDTH);
    _icon.layer.cornerRadius = ICONWIDTH>>1;
    _icon.clipsToBounds = YES;
    
    _name = [[UILabel alloc] init];
    _name.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
    
    _name.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+PADDING, 0, 100, _name.font.lineHeight);
    _from = [[UILabel alloc] init];
    
    _from.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5];
    
    _from.frame = CGRectMake(self.name.frame.origin.x, CGRectGetMaxY(self.name.frame)+5, 100,_from.font.lineHeight);

    [self addSubview:_icon];
    [self addSubview:_name];
    [self addSubview:_from];
    return self;
}

- (void)setWithLayout:(WBStatusLayout *)layout{
    self.width = MAX(layout.nameWidth, layout.fromWidth) + ICONWIDTH + PADDING*2;
    [_icon setImageWithURL:[NSURL URLWithString:layout.status.user.avatarLarge] //profileImageURL
               placeholder:nil
                   options:kNilOptions
                   manager:[WBStatusHelper avatarImageManager]
                  progress:nil
                 transform:nil
                completion:nil];
    _name.text = layout.status.user.screenName;
    _name.width =layout.nameWidth;
    _from.text = layout.fromText;
    _from.width =layout.fromWidth;
    
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
@end

@implementation WBToolbarView

- (instancetype)init{
    self= [super init];
    self.frame = CGRectMake(0, 0, CellContentWidth, ToolbarHeight);
    CGFloat width = CellContentWidth/3.0;
    _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repostButton.frame = CGRectMake(0, 0, width, ToolbarHeight);
    
    
    _commentButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame = CGRectMake(width, 0, width, ToolbarHeight);
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame = CGRectMake(width*2, 0, width, ToolbarHeight);
    
    _repostImageView = [[UIImageView alloc] initWithImage:[WBStatusHelper imageNamed:@"timeline_icon_retweet"]];
    _repostImageView.centerY = self.height / 2;
    [_repostButton addSubview:_repostImageView];
    _commentImageView = [[UIImageView alloc] initWithImage:[WBStatusHelper imageNamed:@"timeline_icon_comment"]];
    _commentImageView.centerY = self.height / 2;
    [_commentButton addSubview:_commentImageView];
    _likeImageView = [[UIImageView alloc] initWithImage:[WBStatusHelper imageNamed:@"timeline_icon_unlike"]];
    _likeImageView.centerY = self.height / 2;
    [_likeButton addSubview:_likeImageView];
    
    
    _repostLabel = [UILabel new];
    _repostLabel.userInteractionEnabled = NO;
    _repostLabel.height = self.height;
    [_repostButton addSubview:_repostLabel];
    
    _commentLabel = [UILabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = self.height;
    [_commentButton addSubview:_commentLabel];
    
    _likeLabel = [UILabel new];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.height = self.height;
    [_likeButton addSubview:_likeLabel];
    
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];
    _line1 = [CAGradientLayer layer];
    _line1.colors = colors;
    _line1.locations = locations;
    _line1.startPoint = CGPointMake(0, 0);
    _line1.endPoint = CGPointMake(0, 1);
    _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line1.left = _repostButton.right;
    
    _line2 = [CAGradientLayer layer];
    _line2.colors = colors;
    _line2.locations = locations;
    _line2.startPoint = CGPointMake(0, 0);
    _line2.endPoint = CGPointMake(0, 1);
    _line2.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line2.left = _commentButton.right;
    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _topLine.backgroundColor = kWBCellLineColor.CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = _topLine.size;
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
    
    [self addSubview:_repostButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];
    
    __weak typeof(self) weakself = self;
    [_repostButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        WBStatusCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickRepost:)]) {
            [cell.delegate cellDidClickRepost:cell];
        }
    }];
    
    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        WBStatusCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [cell.delegate cellDidClickComment:cell];
        }
    }];
    
    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        WBStatusCell *cell = weakself.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [cell.delegate cellDidClickLike:cell];
        }
    }];

    return self;
}

- (void)setWithLayout:(WBStatusLayout *)layout{
    _repostLabel.attributedText = layout.repostText;
    _repostLabel.width = layout.repostTextWidth;
    _repostImageView.left = (_repostButton.width - _repostImageView.width - _repostLabel.width-ToolbarGap)/2;
    _repostLabel.right = _repostButton.width -_repostImageView.left;
    
    _commentLabel.attributedText = layout.commentText;
    _commentLabel.width = layout.commentTextWidth;
    _commentImageView.left = (_commentButton.width - _commentImageView.width - _commentLabel.width-ToolbarGap)/2;
    _commentLabel.right = _commentButton.left - _commentImageView.left;
    
    _likeLabel.attributedText = layout.likeText;
    _likeLabel.width = layout.likeTextWidth;
    _likeImageView.left = (_likeButton.width - _likeImageView.width - _likeLabel.width-ToolbarGap)/2;
    _likeLabel.right = _likeButton.width  - _likeImageView.left;
    
}

@end

@implementation WBStatusView{
    BOOL _touchRetweetView;
}

- (instancetype)init{
    self = [super init];
    _contentView = [UIView new];
    self.width = CELL_WIDTH;
    _contentView.width = CELL_WIDTH;
 
    _userView = [WBUserView new];
    [self.contentView addSubview:_userView];
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
    self.height = layout.statusViewHeight;
    _contentView.top = PADDING;
    _contentView.height = self.height - PADDING*2;
    [_userView setWithLayout:layout];
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
        CGPoint origin = CGPointZero;
        CGSize picSize = CGSizeMake(layout.imgWidth, layout.imgHeight);
        for (NSInteger i=0; i<pictures.count&& i<9; i++) {
            if(pictures.count == 4){
                origin = CGPointMake(i%2*(SIZE_GAP_IMG+layout.imgWidth), i/2*(SIZE_GAP_IMG+layout.imgHeight));
            }else{
                origin = CGPointMake(i%3*(SIZE_GAP_IMG+layout.imgWidth), i/3*(SIZE_GAP_IMG+layout.imgHeight));
            }
            YYAnimatedImageView *thumbView = [self _newImageViewWithTag:i];;
            [picview addSubview:thumbView];
    
            thumbView.frame = (CGRect){origin, picSize};
            thumbView.backgroundColor = isRetweet? kWBCellInnerViewColor : kWBCellBackgroundColor;
            thumbView.autoPlayAnimatedImage =NO;
            NSURL *url = pictures[i].bmiddle.url ? : pictures[i].thumbnail.url ? : pictures[i].original.url;

            __weak __typeof__(thumbView) weakThumb = thumbView;
            [thumbView.layer setImageWithURL:[WBStatusHelper defaultURLForImageURL:url] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if(!image) return;
                if(stage != YYWebImageStageFinished) return;
                CGFloat width = image.size.width;
                CGFloat height = image.size.height;
                
                CGFloat factor= (CGFloat)height/width;
                if(pictures.count==1){
                    factor =  factor > 16/9.0 ? 16/9.0:factor;
                    factor = factor > 9/16.0 ? factor:9/16.0;
                    weakThumb.width = weakThumb.height/factor;
                }
                CGFloat scale = (height/width) / (weakThumb.height / weakThumb.width);
                if (scale <= 1 || isnan(scale)) {
                    weakThumb.contentMode = UIViewContentModeScaleAspectFill;
                    weakThumb.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                } else {
                    
                    weakThumb.contentMode = UIViewContentModeScaleToFill;
                    weakThumb.layer.contentsRect = CGRectMake(0, 0, 1, 1/scale);
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

//- (NSString *)imageFilePath:(NSString *)urlstr{
//    u_long i = urlstr.length-1;
//    for(; i>0; i--){
//        if([urlstr characterAtIndex:i] == '/'){
//            break;
//        }
//    }
//    return [urlstr substringToIndex:i+1];
//}
//
//- (NSString *)imageName:(NSString *)urlstr{
//    u_long i = urlstr.length-1;
//    for(; i>0; i--){
//        if([urlstr characterAtIndex:i] == '/'){
//            break;
//        }
//    }
//    return [urlstr substringFromIndex:i+1];
//}


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
        if(CGRectContainsPoint(_userView.frame, location)){
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
        _toolbar = WBToolbarView.new;
        _toolbar.cell = self;
        
        [self.contentView addSubview:_statusView];
        [self.contentView addSubview:_toolbar];
    }
    return self;
}

//重写set方法，模型传递
- (void)setLayout:(WBStatusLayout *)layout{
    _layout = layout;
    
    [self.statusView setWithLayout:_layout];
    
    _toolbar.frame = CGRectMake(PADDING, layout.height-ToolbarHeight, CellContentWidth, ToolbarHeight);
    
    [_toolbar setWithLayout:layout];
}



@end
