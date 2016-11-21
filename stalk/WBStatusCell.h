//
//  StatusTableViewCell.h
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGLTStatus.h"
#import "WBStatusLayout.h"
#import "STalkTextView.h"
@class StatusTableViewCell;
@class MLLink;

@protocol StatusTableViewCellDelegate <NSObject>

- (void)cellLinkIsClicked:(MLLink *)link;

@end

@interface WBStatusCell : UITableViewCell
@property (nonatomic, weak) WBStatusLayout *layout;
@property (nonatomic, weak) id<StatusTableViewCellDelegate> cellDelegate;
@end
