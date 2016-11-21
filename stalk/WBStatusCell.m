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
#import "StatusInfo.h"
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


@interface WBStatusCell ()<UITextViewDelegate>

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *from;
@property (nonatomic, weak) MLLinkLabel *statusText;
@property (nonatomic, weak) UIScrollView *pictureHolder;
@property (nonatomic, weak) MLLinkLabel *retweetText;
//@property (nonatomic, weak) UIView *seprator;

@end

@implementation WBStatusCell{
    UIColor *highlightColor;
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
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    highlightColor = [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1];
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //取消点击高亮状态
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
//        CGFloat viewWidth = cellWidth - (PADDING<<1);
//        //头像
//        UIImageView *icon = [[UIImageView alloc] init];
//        [self.contentView addSubview:icon];
//        self.icon = icon;
//        self.icon.frame = CGRectMake(PADDING, PADDING, ICONWIDTH, ICONWIDTH);
//        self.icon.layer.cornerRadius = ICONWIDTH>>1;
//        self.icon.clipsToBounds = YES;
//        
//        //名字
//        UILabel *name = [[UILabel alloc] init];
//        name.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
//        [self.contentView addSubview:name];
//        self.name = name;
//        self.name.frame = CGRectMake(ICONWIDTH + PADDING *2, PADDING, viewWidth-ICONWIDTH-PADDING *2, 20);
//        UILabel *from = [[UILabel alloc] init];
//        from.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5];
//        [self.contentView addSubview:from];
//        self.from = from;
//        self.from.frame = CGRectMake(self.name.frame.origin.x, CGRectGetMaxY(self.name.frame) +PADDING, viewWidth-ICONWIDTH-PADDING *2,ICONWIDTH -self.name.frame.size.height-PADDING);
//        //内容
//        STalkTextView *text = [[STalkTextView alloc] init];
//        text.editable = NO;
//        text.scrollEnabled = NO;
//        text.delegate = self;
//        [self.contentView addSubview:text];
//        self.statusText = text;
//        
//        STalkTextView *retweetText = [[STalkTextView alloc] init];
//        retweetText.editable = NO;
//        retweetText.scrollEnabled = NO;
//        retweetText.delegate =self;
//        self.retweetText = retweetText;
//        [self.contentView addSubview:retweetText];
//        
//        
//        UIScrollView *pictureHolder = [[UIScrollView alloc]init];
//        self.pictureHolder = pictureHolder;
//        [self.contentView addSubview:pictureHolder];
//        pictureHolder.scrollsToTop = NO;
//        pictureHolder.showsHorizontalScrollIndicator = NO;
//        pictureHolder.showsVerticalScrollIndicator = NO;
//        pictureHolder.tag = NSIntegerMax;
//        pictureHolder.hidden = YES;
//        [self.contentView addSubview:pictureHolder];
//        
//    }
//    
//    return self;
//}
//重写init方法构建cell内容
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    highlightColor = [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1];
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
- (void)setStatusInfo:(StatusInfo *)statusInfo{
    _statusInfo = statusInfo;
    self.icon.imageURL =[NSURL URLWithString:_statusInfo.status.user.avatarLarge];
    
    self.name.text =_statusInfo.status.user.screenName;

    
    self.from.text = [NSString stringWithFormat:@"%@ 来自%@", [_statusInfo.status.createdAt substringToIndex:11], [ self sourceWithString:_statusInfo.status.source]];
    self.statusText.numberOfLines = 0;
    self.statusText.beforeAddLinkBlock = nil;
    NSMutableAttributedString *attributedStr = _statusInfo.statusAttributedText;
    self.statusText.frame = _statusInfo.textFrame;
    self.statusText.dataDetectorTypes = MLDataDetectorTypeAll;
    
    [self.statusText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        [_cellDelegate cellLinkIsClicked:link];
    }];
    self.statusText.attributedText = attributedStr;
    if(_statusInfo.status.retweetedStatus){
        NSMutableAttributedString *attributedStr = _statusInfo.retweetAttributedText;
        self.retweetText.numberOfLines = 0;
        self.retweetText.attributedText = attributedStr;
        self.retweetText.frame = _statusInfo.retweetStatusTextFrame;
        self.retweetText.dataDetectorTypes = MLDataDetectorTypeAll;
        [self.retweetText setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            [_cellDelegate cellLinkIsClicked:link];
        }];
    }
    
    NSArray *urls;
    FGLTStatus *status;
    if (_statusInfo.status.retweetedStatus) {
        status = _statusInfo.status.retweetedStatus;
        urls = _statusInfo.status.retweetedStatus.thumbnailPic;
    } else {
        status = _statusInfo.status;
        urls = _statusInfo.status.thumbnailPic;
    }
    if (urls.count>0) {
        self.pictureHolder.hidden = NO;
        self.pictureHolder.frame = _statusInfo.pictureFrame;
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

//- (NSMutableAttributedString *)replaceEmotion:(NSMutableAttributedString *)coloredString{
//
//    NSUInteger lengthDetail = 0;
//    NSRange newRange;
//    NSString *bundleName = @"emotionResource.bundle";
//    
//    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,coloredString.string.length)];
//    for(NSTextCheckingResult* match in matches) {
//        newRange = NSMakeRange(match.range.location - lengthDetail, match.range.length);
//        NSString *emotionstr = [coloredString.string substringWithRange:newRange];
//        STalkTextAttachment *attachment = [[STalkTextAttachment alloc] init];
//        attachment.image = [UIImage imageNamed:[bundleName stringByAppendingPathComponent:emotionstr]];
//        NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
//        NSUInteger prelength = coloredString.length;
//        [coloredString replaceCharactersInRange:newRange withAttributedString:attachStr];
//        lengthDetail += prelength - coloredString.length;
//    }
//    
//    return coloredString;
//}
//
//- (NSMutableAttributedString *)addLink:(NSMutableAttributedString *)coloredString  pattern:(NSString *)pattern scheme:(NSString *)scheme {
//    NSString* string = coloredString.string;
//    NSRange range = NSMakeRange(0,[string length]);
//    
//    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
//    for(NSTextCheckingResult* match in matches) {
//
//        NSString *str = [string substringWithRange:match.range];
//        NSString *urlstr = [NSString stringWithFormat:@"%@%@", scheme, str];
//        [coloredString addAttribute:NSLinkAttributeName value:urlstr range:match.range];
//        [coloredString addAttribute:(NSString*)NSForegroundColorAttributeName value:highlightColor range:match.range];
//    }
//    
//    return coloredString;
//}

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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    NSString *string = textView.attributedText.string;
    NSString *str = [string substringWithRange:characterRange];
    NSLog(@"%@",str);
    NSLog(@"%@", URL);
    return NO;
}

//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);
//

@end
