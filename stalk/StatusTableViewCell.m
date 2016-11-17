//
//  StatusTableViewCell.m
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIView+Additions.h"
#import "UIScreen+Additions.h"
#import "NSString+Additions.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "FGLTStatus.h"
#import "FGLTUser.h"
#import "StatusInfo.h"
#import "STalkTextAttachment.h"
#import "Emotion.h"
#import "AppDelegate.h"
#import "EmotionHelper.h"

#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAccount @"account"
#define kRegexHighlightViewTypeTopic @"topic"
#define kRegexHighlightViewTypeEmoji @"emoji"

#define URLRegular @"(http|https)://(t.cn/|weibo.com/|m.weibo.cn/)+(([a-zA-Z0-9/])*)"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"


@interface StatusTableViewCell ()<UITextViewDelegate>

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *from;
@property (nonatomic, weak) STalkTextView *statusText;
@property (nonatomic, weak) UIScrollView *pictureHolder;
@property (nonatomic, weak) STalkTextView *retweetText;
@property (nonatomic, strong) EmotionHelper *emotionHelper;
//@property (nonatomic, weak) UIView *seprator;

@end

@implementation StatusTableViewCell{
    UIColor *highlightColor;
}

+ (instancetype)cellWIthTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    //先在缓存池中取
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //缓存池中没有再创建，并添加标识，cell移出屏幕时放入缓存池以复用
    if (cell == nil) {
        cell = [[StatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

//重写init方法构建cell内容
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    _emotionHelper = [EmotionHelper sharedEmotionHelper];
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
        STalkTextView *text = [[STalkTextView alloc] init];
        text.editable = NO;
        text.scrollEnabled = NO;
        text.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
        text.delegate = self;
        [self.contentView addSubview:text];
        self.statusText = text;
        
        STalkTextView *retweetText = [[STalkTextView alloc] init];
        retweetText.editable = NO;
        retweetText.scrollEnabled = NO;
        retweetText.font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT-1];
        retweetText.delegate =self;
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

    [self.icon sd_setImageWithURL:[NSURL URLWithString:_statusInfo.status.user.avatarLarge]];
    
    self.name.text =_statusInfo.status.user.screenName;

    
    self.from.text = [NSString stringWithFormat:@"%@ 来自%@", [_statusInfo.status.createdAt substringToIndex:11], [ self sourceWithString:_statusInfo.status.source]];

    UIFont *font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.minimumLineHeight = font.pointSize;
    style.maximumLineHeight = font.pointSize;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = 5;
    style.lineHeightMultiple = 0.0;
    NSDictionary* attributes =@{NSFontAttributeName:font};
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_statusInfo.status.text attributes:attributes];

    attributedStr = [self addLink:attributedStr pattern:URLRegular scheme:@""];
    attributedStr = [self addLink:attributedStr pattern:AccountRegular scheme:@"account://"];
    attributedStr = [self addLink:attributedStr pattern:TopicRegular scheme:@"topic://"];
    attributedStr = [self replaceEmotion:attributedStr];
    self.statusText.attributedText = attributedStr;
    self.statusText.frame = _statusInfo.textFrame;
    if(_statusInfo.status.retweetedStatus){
        UIFont *font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT-1];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        style.minimumLineHeight = font.pointSize;
        style.maximumLineHeight = font.pointSize;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.lineSpacing = 5;

        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_statusInfo.status.retweetedStatus.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SIZE_FONT_CONTENT-1]}];
        
        attributedStr = [self addLink:attributedStr pattern:URLRegular scheme:@""];
        attributedStr = [self addLink:attributedStr pattern:AccountRegular scheme:@"account://"];
        attributedStr = [self addLink:attributedStr pattern:TopicRegular scheme:@"topic://"];
        self.retweetText.attributedText = attributedStr;
        self.retweetText.frame = _statusInfo.retweetStatusTextFrame;
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

                [thumbView sd_setImageWithURL:url];
            } else {
                thumbView.hidden = YES;
            }
        }
        float cw = (SIZE_GAP_IMG+SIZE_IMAGE)*urls.count;
        if (self.pictureHolder.contentSize.width!=cw) {
            self.pictureHolder.contentSize = CGSizeMake(cw, 0);
        }
    }
    
    //    self.seprator.frame = _statusInfo.sepratorLineFrame;
    
}

- (NSMutableAttributedString *)replaceEmotion:(NSMutableAttributedString *)coloredString{

    NSUInteger lengthDetail = 0;
    NSRange newRange;
    NSString *bundleName = @"emotionResource.bundle";
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,coloredString.string.length)];
    for(NSTextCheckingResult* match in matches) {
        newRange = NSMakeRange(match.range.location - lengthDetail, match.range.length);
        NSString *emotionstr = [coloredString.string substringWithRange:newRange];
        STalkTextAttachment *attachment = [[STalkTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:[bundleName stringByAppendingPathComponent:emotionstr]];
//        Emotion *emotion = [_emotionHelper emotionWithValue:emotionstr];
//        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:emotion.url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            if(image){
//                attachment.image = image;
//            }
//        }];
        //UIFont *font = [UIFont systemFontOfSize:19];
        //attachment.bounds = CGRectMake(0, -font.pointSize*0.2, font.pointSize, font.pointSize);
        NSAttributedString * attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSUInteger prelength = coloredString.length;
        [coloredString replaceCharactersInRange:newRange withAttributedString:attachStr];
        lengthDetail += prelength - coloredString.length;
    }
    
    return coloredString;
}

- (NSMutableAttributedString *)addLink:(NSMutableAttributedString *)coloredString  pattern:(NSString *)pattern scheme:(NSString *)scheme {
    NSString* string = coloredString.string;
    NSRange range = NSMakeRange(0,[string length]);
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
    for(NSTextCheckingResult* match in matches) {

        NSString *str = [string substringWithRange:match.range];
        NSString *urlstr = [NSString stringWithFormat:@"%@%@", scheme, str];
        [coloredString addAttribute:NSLinkAttributeName value:urlstr range:match.range];
        [coloredString addAttribute:(NSString*)NSForegroundColorAttributeName value:highlightColor range:match.range];
    }
    
    return coloredString;
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
