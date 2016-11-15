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
#import "UIImageView+WebCache.h"

@interface StatusTableViewCell ()

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *from;
@property (nonatomic, weak) UILabel *statusText;
@property (nonatomic, weak) UIScrollView *pictureHolder;
@property (nonatomic, weak) UILabel *retweetLabel;

//@property (nonatomic, weak) UIView *seprator;

@end

@implementation StatusTableViewCell

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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //取消点击高亮状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        UIImageView *icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        
        //名字
        UILabel *name = [[UILabel alloc] init];
        name.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
        [self.contentView addSubview:name];
        self.name = name;
        
        UILabel *from = [[UILabel alloc] init];
        from.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT-5];
        [self.contentView addSubview:from];
        self.from = from;
        //内容
        UILabel *text = [[UILabel alloc] init];
        text.numberOfLines = 0;
        text.font =[UIFont systemFontOfSize:SIZE_FONT_CONTENT];
        [self.contentView addSubview:text];
        self.statusText = text;
        
        UILabel *retweetLabel = [[UILabel alloc] init];
        retweetLabel.font = [UIFont systemFontOfSize:SIZE_FONT_CONTENT-1];
        retweetLabel.numberOfLines = 0;
        self.retweetLabel = retweetLabel;
        [self.contentView addSubview:retweetLabel];
        
        
        UIScrollView *pictureHolder = [[UIScrollView alloc]init];
        self.pictureHolder = pictureHolder;
        [self.contentView addSubview:pictureHolder];
        pictureHolder.scrollsToTop = NO;
        pictureHolder.showsHorizontalScrollIndicator = NO;
        pictureHolder.showsVerticalScrollIndicator = NO;
        pictureHolder.tag = NSIntegerMax;
        pictureHolder.hidden = YES;
        [self.contentView addSubview:pictureHolder];
        
        //        UIView *seprator = [[UIView alloc]init];
        //        seprator.backgroundColor = [UIColor darkGrayColor];
        //        self.seprator = seprator;
        //        [self.contentView addSubview:self.seprator];
        
    }
    
    return self;
}

//重写set方法，模型传递
- (void)setStatusInfo:(StatusInfo *)statusInfo{
    _statusInfo = statusInfo;
    CGFloat cellWidth = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat viewWidth = cellWidth - (PADDING<<1);
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_statusInfo.status.user.profileImageUrl]];
    self.icon.frame = CGRectMake(PADDING, PADDING, ICONWIDTH, ICONWIDTH);
    
    self.name.text =_statusInfo.status.user.screenName;
    self.name.frame = CGRectMake(ICONWIDTH + PADDING *2, PADDING, viewWidth-ICONWIDTH-PADDING *2, 20);;
    
    self.from.text = [NSString stringWithFormat:@"%@ 来自%@", [_statusInfo.status.createdAt substringToIndex:11], [ self sourceWithString:_statusInfo.status.source]];
    //    NSLog(@"%@", _statusInfo.status.source);
    self.from.frame = CGRectMake(ICONWIDTH + PADDING *2, CGRectGetMaxY(self.name.frame) +PADDING, viewWidth-ICONWIDTH-PADDING *2,ICONWIDTH -  CGRectGetMaxY(self.name.frame));
    
    self.statusText.text = _statusInfo.status.text;
    self.statusText.frame = _statusInfo.textFrame;
    
    
    
    if(_statusInfo.status.retweetedStatus){
        self.retweetLabel.text = _statusInfo.status.retweetedStatus.text;
        self.retweetLabel.frame = _statusInfo.retweetStatusTextFrame;
    }
    
    NSArray *urls;
    if (_statusInfo.status.retweetedStatus) {
        urls = _statusInfo.status.retweetedStatus.thumbnailPic;
    } else {
        urls = _statusInfo.status.thumbnailPic;
    }
    if (urls.count>0) {
        self.pictureHolder.hidden = NO;
        self.pictureHolder.frame = _statusInfo.pictureFrame;
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
                [thumbView sd_setImageWithURL:[NSURL URLWithString:urls[i]]];
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

- (void)setFrame:(CGRect)frame {
    CGFloat width = MIN( [UIScreen mainScreen].bounds.size.width, MAX_SIZE_WIDTH);
    CGFloat startX = ( [UIScreen mainScreen].bounds.size.width-width)/2;
    frame.origin.x += startX;
    frame.size.width -= 2 * startX;
    
    [super setFrame:frame];
    
}

- (NSString *) sourceWithString:(NSString *)source{
    int i=0;
    for(; i<source.length; i++){
        if([source characterAtIndex:i] == '>')
            break;
    }
    return [source substringWithRange:NSMakeRange(i+1, source.length-4 -i-1 )];
}
@end