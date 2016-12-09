//
//  UserViewController.h
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboUser;

@interface UserViewController : UITableViewController
@property (nonatomic, strong) WeiboUser *user;

@end
