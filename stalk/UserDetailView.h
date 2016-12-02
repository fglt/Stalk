//
//  UserDetailView.h
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBUser;
@interface UserDetailView : UIView
@property (strong, nonatomic)  UIImageView *iconView;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *locatioin;
@property (strong, nonatomic)  UILabel *descriptions;
@property (strong, nonatomic)  UIButton *followButton;


- (void)configureWithWBUser:(WBUser *)user;
@end
