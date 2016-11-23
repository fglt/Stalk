//
//  StatusDetailViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "WBStatusCell.h"

@interface StatusDetailViewController ()
@property (nonatomic, strong) WBStatusView *statusView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation StatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusView  = [WBStatusView new];
    [_statusView setWithLayout:_layout];
    CGPoint origin = CGPointMake(([UIScreen mainScreen].bounds.size.width - CELL_WIDTH)/2, CGRectGetMaxY(self.navigationController.navigationBar.frame));
    CGSize size = CGSizeMake(CELL_WIDTH, _layout.height);
    _contentView = [[UIView alloc] initWithFrame:(CGRect){origin, size}];
    [_contentView addSubview:_statusView];
    [self.view addSubview:_contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
