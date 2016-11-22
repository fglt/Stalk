//
//  StatusTableViewCell.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusCell.h"
#import "UIScreen+Additions.h"
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

@interface WBStatusView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *from;
@property (nonatomic, strong) MLLinkLabel *statusText;
@property (nonatomic, strong) UIView *pictureHolder;
@property (nonatomic, strong) UIView *retweetPictureHolder;
@property (nonatomic, strong) MLLinkLabel *retweetText;
@property (nonatomic, strong) UIView *retweetContentView;

@end

@implementation WBStatusView{
    BOOL _touchRetweetView;
}

- (instancetype)init{
    self = [super init];
    CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    _contentView = [UIView new];
    self.width = cellWidth;
    _contentView.width = cellWidth;
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
    _statusText.numberOfLines = 0;
    _statusText.beforeAddLinkBlock = nil;
    _statusText.frame = layout.statusTextFrame;
    _statusText.dataDetectorTypes = MLDataDetectorTypeAll;
    __weak WBStatusView * weakSelf = self;
    [self.statusText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        
        [weakSelf.statusCell.delegate cellLinkIsClicked:weakSelf.statusCell :link];
    }];
    self.statusText.attributedText = layout.statusAttributedText;
    if(layout.status.retweetedStatus){
        NSMutableAttributedString *attributedStr = layout.retweetAttributedText;
        _retweetContentView.frame = layout.retweetContentFrame;
        self.retweetText.numberOfLines = 0;
        self.retweetText.attributedText = attributedStr;
        
        self.retweetText.frame = layout.retweetTextFrame;
        self.retweetText.dataDetectorTypes = MLDataDetectorTypeAll;
        [self.retweetText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            [weakSelf.statusCell.delegate cellLinkIsClicked:weakSelf.statusCell :link];
        }];
    }else{
        _retweetContentView.frame = CGRectZero;
        _retweetText.frame = CGRectZero;
        _retweetText.text = nil;
    }
    
    NSArray *urls;
    WBStatus *status;
    UIView *picview;
    
    
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
        urls = layout.status.retweetedStatus.thumbnailPic;
        picview = _retweetPictureHolder;
        _retweetPictureHolder.frame = layout.retweetPicFrame;
    }else if(layout.statusPictureFrame.size.height >0){
        status = layout.status;
        urls = layout.status.thumbnailPic;
        picview = _pictureHolder;
        _pictureHolder.frame = layout.statusPictureFrame;
    }
    
    CGFloat imgWidth = ceil((self.statusText.width - SIZE_GAP_IMG*2)/3.0);
    if(urls.count>0){
        NSURL *baseURL = [NSURL URLWithString:[self imageFilePath:status.bmiddlePic]];
        if(urls.count ==1){
            UIImageView *thumbView = [[UIImageView alloc] init];
            [picview addSubview:thumbView];
            thumbView.contentMode = UIViewContentModeScaleAspectFill;
            thumbView.backgroundColor = [UIColor lightGrayColor];
            thumbView.tag = 0;
            thumbView.clipsToBounds = YES;
            
            thumbView.frame = CGRectMake(0,0, self.statusText.width*2/3, SIZE_IMAGE<<1);
            NSURL *url= [NSURL URLWithString:[self imageName:urls[0]] relativeToURL:baseURL];
            thumbView.imageURL = url;
        }else{
        for (NSInteger i=0; i<urls.count&& i<9; i++) {
            UIImageView *thumbView = [[UIImageView alloc] init];
            [picview addSubview:thumbView];
            thumbView.contentMode = UIViewContentModeScaleAspectFill;
            thumbView.backgroundColor = [UIColor lightGrayColor];
            thumbView.tag = UIViewContentModeScaleAspectFill;
            thumbView.clipsToBounds = YES;
        
            thumbView.frame = CGRectMake(i%3*(SIZE_GAP_IMG+imgWidth), i/3*(SIZE_GAP_IMG+SIZE_IMAGE), imgWidth, SIZE_IMAGE);
            NSURL *url= [NSURL URLWithString:[self imageName:urls[i]] relativeToURL:baseURL];
            thumbView.imageURL = url;
        }
        }
    }
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
        if ([_statusCell.delegate respondsToSelector:@selector(cellRetweetIsClicked:)]) {
            [_statusCell.delegate cellRetweetIsClicked:_statusCell];
        }
    } else {
        if(CGRectContainsPoint(_icon.frame, location) || CGRectContainsPoint(_name.frame, location)){
            [_statusCell.delegate cellUserIsClicked:_statusCell];
        }else{
            [_statusCell.delegate cellStatusIsClicked:_statusCell];
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
    CGFloat width = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat startX = ( [UIScreen mainScreen].bounds.size.width-width)/2;
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
