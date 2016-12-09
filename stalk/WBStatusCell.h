//
//  StatusTableViewCell.h
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBStatus.h"
#import "WBStatusLayout.h"
#import "STalkTextView.h"
@class WBStatusCell;
@class MLLink;
@class MLLinkLabel;
@class MLLabel;
@class WBMessageCell;

#define CellPadding 10;

@protocol WBStatusCellDelegate <NSObject>
@optional
- (void)cell:(WBStatusCell *)cell didClickLink:(MLLink *)link;
- (void)cellDidClick:(WBStatusCell *)cell;
- (void)cellDidClickRetweet:(WBStatusCell *)cell;
- (void)cellDidClickUser:(WBStatusCell *)cell;
- (void)cell:(WBStatusCell *)cell didClickImageAt:(NSUInteger)index;
- (void)cellDidClickRepost:(WBStatusCell *)cell;
- (void)cellDidClickComment:(WBStatusCell *)cell;
- (void)cellDidClickLike:(WBStatusCell *)cell;

@end

@protocol WBMessageCellDelegate <NSObject>
@optional
- (void)cell:(WBMessageCell *)cell didClickLink:(MLLink *)link;
- (void)cellDidClick:(WBMessageCell *)cell;
- (void)cellDidClickUser:(WBMessageCell *)cell;
@end

@interface WeiboUserView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *from;
- (void)setWithLayout:(WeiboUserLayout *)layout;
@end

@interface WBToolbarView : UIView
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) UILabel *repostLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, weak) WBStatusCell *cell;
- (void)setWithLayout:(WBToolbarLayout *)layout;
@end

@interface WBStatusView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WeiboUserView *userView;
@property (nonatomic, strong) MLLinkLabel *statusText;
@property (nonatomic, strong) UIView *pictureHolder;
@property (nonatomic, strong) UIView *retweetPictureHolder;
@property (nonatomic, strong) MLLinkLabel *retweetText;
@property (nonatomic, strong) UIView *retweetContentView;

- (void)setWithLayout:(WBStatusLayout *)layout;
@property (nonatomic, weak) WBStatusCell *statusCell;
@end


@interface WBStatusCell : UITableViewCell
@property (nonatomic, strong) WBStatusView *statusView;
@property (nonatomic, strong) WBToolbarView *toolbar;
@property (nonatomic, weak) WBStatusLayout *layout;
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end

@interface WBStatusCell (config)
- (void)configWithLayout:(WBStatusLayout *)layout delegate:(id<WBStatusCellDelegate>) delegate;
@end

@interface WBMessageCell : UITableViewCell
@property (nonatomic, strong) WeiboUserView *userView;
@property (nonatomic, strong) MLLinkLabel *messageLabel;
@property (nonatomic, strong) WBMessageLayout *layout;
@property (nonatomic, weak) id<WBMessageCellDelegate> delegate;
@end

@interface WBMessageCell (config)
- (void)configWithLayout:(WBMessageLayout *)layout delegate:(id<WBMessageCellDelegate>) delegate;
@end
