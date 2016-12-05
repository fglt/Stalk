//
//  UserDetailView.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBUser;
@class UserDetailView;

@interface UserDetailView : UIView
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *locatioin;
@property (strong, nonatomic) UILabel *descriptions;

- (void)layoutWithUser:(WBUser *)user;

@end

@interface UserHeaderView : UIView
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UserDetailView *userView;
- (void)layoutWithUser:(WBUser *)user;
@end
