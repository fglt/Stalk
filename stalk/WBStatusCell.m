//
//  StatusTableViewCell.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusCell.h"
#import "UIView+Additions.h"
#import "UIScreen+Additions.h"
#import "NSString+Additions.h"
#import "FGLTStatus.h"
#import "FGLTUser.h"
#import "WBStatusLayout.h"
#import "STalkTextAttachment.h"
#import "Emotion.h"
#import "AppDelegate.h"
#import "EmotionHelper.h"
#import "MLLinkLabel.h"
#import "AppDelegate.h"

#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAccount @"account"
#define kRegexHighlightViewTypeTopic @"topic"
#define kRegexHighlightViewTypeEmoji @"emoji"

#define URLRegular @"(http|https)://(t.cn/|weibo.com/|m.weibo.cn/)+(([a-zA-Z0-9/])*)"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"


@interface WBStatusCell ()

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *from;
@property (nonatomic, weak) MLLinkLabel *statusText;
@property (nonatomic, weak) UIScrollView *pictureHolder;
@property (nonatomic, weak) MLLinkLabel *retweetText;
//@property (nonatomic, weak) UIView *seprator;

@end

@implementation WBStatusCell{
    BOOL _touchRetweetView;
}

+ (instancetype)cellWIthTableView:(UITableView *)tableView identifier:(NSString *)identifier
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
        CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
        CGFloat viewWidth = cellWidth - (PADDING<<1);
        //头像
        UIImageView *icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        self.icon.frame = CGRectMake(PADDING, PADDING, ICONWIDTH, ICONWIDTH);
        self.icon.layer.cornerRadius = ICONWIDTH>>1;
        self.icon.clipsToBounds = YES;

        //名字
        UILabel *name = [[UILabel alloc] init];
        name.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
        [self.contentView addSubview:name];
        self.name = name;
        self.name.frame = CGRectMake(ICONWIDTH + PADDING *2, PADDING, viewWidth-ICONWIDTH-PADDING *2, 20);
        UILabel *from = [[UILabel alloc] init];
        from.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5];
        [self.contentView addSubview:from];
        self.from = from;
        self.from.frame = CGRectMake(self.name.frame.origin.x, CGRectGetMaxY(self.name.frame) +PADDING, viewWidth-ICONWIDTH-PADDING *2,ICONWIDTH -self.name.frame.size.height-PADDING);
        //内容
        MLLinkLabel *text = [[MLLinkLabel alloc] init];
        [self.contentView addSubview:text];
        self.statusText = text;
        
        MLLinkLabel *retweetText = [[MLLinkLabel alloc] init];
        self.retweetText = retweetText;
        self.retweetText.backgroundColor = kWBCellInnerViewColor;
        [self.contentView addSubview:retweetText];
        
        
        UIScrollView *pictureHolder = [[UIScrollView alloc]init];
        self.pictureHolder = pictureHolder;
        [self.contentView addSubview:pictureHolder];
        pictureHolder.scrollsToTop = NO;
        pictureHolder.showsHorizontalScrollIndicator = NO;
        pictureHolder.showsVerticalScrollIndicator = NO;
        pictureHolder.tag = NSIntegerMax;
        pictureHolder.hidden = YES;
        [self.contentView addSubview:pictureHolder];
    }
    
    return self;
}



//重写set方法，模型传递
- (void)setLayout:(WBStatusLayout *)layout{
    _layout = layout;
    self.icon.imageURL =[NSURL URLWithString:_layout.status.user.avatarLarge];
//    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellIsTaped:)];
//    [self addGestureRecognizer:cellTap];
    self.name.text =_layout.status.user.screenName;
    self.from.text = [NSString stringWithFormat:@"%@ 来自%@", [_layout.status.createdAt substringToIndex:11], [ self sourceWithString:_layout.status.source]];
    self.statusText.numberOfLines = 0;
    self.statusText.beforeAddLinkBlock = nil;
    NSMutableAttributedString *attributedStr = _layout.statusAttributedText;
    self.statusText.frame = _layout.textFrame;
    self.statusText.dataDetectorTypes = MLDataDetectorTypeAll;
    __weak WBStatusCell *weakself = self;
    
    [self.statusText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        
        [_delegate cellLinkIsClicked:self :link];
    }];
    self.statusText.attributedText = attributedStr;
    if(_layout.status.retweetedStatus){
        NSMutableAttributedString *attributedStr = _layout.retweetAttributedText;
        self.retweetText.numberOfLines = 0;
        self.retweetText.attributedText = attributedStr;
        self.retweetText.frame = _layout.retweetStatusTextFrame;
        self.retweetText.dataDetectorTypes = MLDataDetectorTypeAll;
        [self.retweetText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            [_delegate cellLinkIsClicked:weakself :link];
        }];
    }
    
    NSArray *urls;
    FGLTStatus *status;
    if (_layout.status.retweetedStatus) {
        status = _layout.status.retweetedStatus;
        urls = _layout.status.retweetedStatus.thumbnailPic;
    } else {
        status = _layout.status;
        urls = _layout.status.thumbnailPic;
    }
    if (urls.count>0) {
        self.pictureHolder.hidden = NO;
        self.pictureHolder.frame = _layout.pictureFrame;
        NSURL *baseURL = [NSURL URLWithString:[self imageFilePath:status.bmiddlePic]];
        for (NSInteger i=0; i<9; i++) {
            UIImageView *thumbView = [[UIImageView alloc] init];
            [self.pictureHolder addSubview:thumbView];
            thumbView.contentMode = UIViewContentModeScaleAspectFill;
            thumbView.backgroundColor = [UIColor lightGrayColor];
            thumbView.tag = i;
            thumbView.clipsToBounds = YES;
            if (i<urls.count) {
                thumbView.frame = CGRectMake((SIZE_GAP_IMG+SIZE_IMAGE)*i, 0, SIZE_IMAGE, SIZE_IMAGE);
                thumbView.hidden = NO;
                NSURL *url= [NSURL URLWithString:[self imageName:urls[i]] relativeToURL:baseURL];

                thumbView.imageURL = url;
            } else {
                thumbView.hidden = YES;
            }
        }
        float cw = (SIZE_GAP_IMG+SIZE_IMAGE)*urls.count;
        if (self.pictureHolder.contentSize.width!=cw) {
            self.pictureHolder.contentSize = CGSizeMake(cw, 0);
        }
    }
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

- (void)setFrame:(CGRect)frame {
    CGFloat width = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat startX = ( [UIScreen mainScreen].bounds.size.width-width)/2;
    frame.origin.x += startX;
    frame.size.width -= 2 * startX;

    [super setFrame:frame];
    
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

//- (void)cellIsTaped:(UIGestureRecognizer *)recognizer{
//    [_delegate cellUserIsClicked:self];
//    CGPoint location = [recognizer locationInView:self];
//    if(CGRectContainsPoint(_icon.frame, location)){
//        [_delegate cellUserIsClicked:self];
//    }else if(CGRectContainsPoint(_name.frame, location)){
//        [_delegate cellUserIsClicked:self];
//    }else if(CGRectContainsPoint(_statusText.frame, location)){
//        UIColor *color = _statusText.backgroundColor;
//        _statusText.backgroundColor = [UIColor grayColor];
//        [_delegate cellStatusIsClicked:self];
//        _statusText.backgroundColor = color;
//        
//    }else if(CGRectContainsPoint(_retweetText.frame, location)){
//        UIColor *color = _retweetText.backgroundColor;
//        _retweetText.backgroundColor = [UIColor grayColor];
//        [_delegate cellRetweetIsClicked:self];
//        _retweetText.backgroundColor = color;
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
        CGPoint location = [touch locationInView:_retweetText];
    if (CGRectContainsPoint(_retweetText.bounds, location)){
        _touchRetweetView = YES;
        [_retweetText performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
    }else{
        [self performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
         _touchRetweetView = NO;
    }
//        if(CGRectContainsPoint(_icon.frame, location)){
//            [_delegate cellUserIsClicked:self];
//        }else if(CGRectContainsPoint(_name.frame, location)){
//            [_delegate cellUserIsClicked:self];
//        }else if(CGRectContainsPoint(_statusText.frame, location)){
//            _statusText.backgroundColor = kWBCellHighlightColor;
//            [_delegate cellStatusIsClicked:self];
//        }else if(CGRectContainsPoint(_retweetText.frame, location)){
//            _retweetText.backgroundColor = [UIColor grayColor];
//            [_delegate cellRetweetIsClicked:self];
//        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    [self touchesRestoreBackgroundColor];
    if (_touchRetweetView) {
        if ([_delegate respondsToSelector:@selector(cellRetweetIsClicked:)]) {
            [_delegate cellRetweetIsClicked:self];
        }
    } else {
        if(CGRectContainsPoint(_icon.frame, location)){
            [_delegate cellUserIsClicked:self];
        }else if(CGRectContainsPoint(_name.frame, location)){
            [_delegate cellUserIsClicked:self];
        }else if(CGRectContainsPoint(_statusText.frame, location)){
            [_delegate cellStatusIsClicked:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetText selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    
    self.backgroundColor = [UIColor whiteColor];
    _retweetText.backgroundColor = kWBCellInnerViewColor;
}


@end
