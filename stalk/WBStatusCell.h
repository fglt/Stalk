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

#define CellPadding 10;

@protocol WBStatusCellDelegate <NSObject>
@optional
- (void)cell:(WBStatusCell *)cell didClickLink:(MLLink *)link;
- (void)cellDidClick:(WBStatusCell *)cell;
- (void)cellDidClickRetweet:(WBStatusCell *)cell;
- (void)cellDidClickUser:(WBStatusCell *)cell;
- (void)cell:(WBStatusCell *)cell didClickImageAt:(NSUInteger)index;
@end

@interface WBStatusView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *from;
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
@property (nonatomic, weak) WBStatusLayout *layout;
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end
