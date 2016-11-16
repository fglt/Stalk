//
//  StatusTableViewCell.h
//  stalk
//
//  Created by Coding on 12/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGLTStatus.h"
#import "StatusInfo.h"
#import "STalkTextView.h"

@interface StatusTableViewCell : UITableViewCell
@property (nonatomic, weak) StatusInfo *statusInfo;
@end
