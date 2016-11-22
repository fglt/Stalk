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

#define CellPadding 10;

@protocol WBStatusCellDelegate <NSObject>
@optional
- (void)cellLinkIsClicked:(WBStatusCell *)cell :(MLLink *)link;
- (void)cellStatusIsClicked:(WBStatusCell *)cell;
- (void)cellRetweetIsClicked:(WBStatusCell *)cell;
- (void)cellUserIsClicked:(WBStatusCell *)cell;
@end

@interface WBStatusView : UIView
- (void)setWithLayout:(WBStatusLayout *)layout;
@property (nonatomic, weak) WBStatusCell *statusCell;
@end

@interface WBStatusCell : UITableViewCell
@property (nonatomic, strong) WBStatusView *statusView;
@property (nonatomic, weak) WBStatusLayout *layout;
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;
@end
