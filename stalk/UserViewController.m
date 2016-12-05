//
//  UserViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserViewController.h"
#import "WBUser.h"
#import "WBRequestQueue.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"
#import "UserDetailView.h"
#import "UINavigationBar+Awesome.h"
#import "constant.h"

@interface UserViewController ()
@property (strong, nonatomic) UserHeaderView *headerView;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _headerView = [UserHeaderView new];
    _headerView.width = self.view.width;
    self.tableView.tableHeaderView = _headerView;
    [_headerView layoutWithUser:_user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
