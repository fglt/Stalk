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
@property (nonatomic, strong) UITableView *commentView;
@end

@implementation StatusDetailViewController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGPoint origin = CGPointMake((size.width - CELL_WIDTH)/2, 0);
        _statusView.origin =origin;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (instancetype)init{
    self = [super init];
    _statusView  = [WBStatusView new];
    _commentView = [UITableView new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [_statusView setWithLayout:_layout];
    CGPoint origin = CGPointMake(([UIScreen mainScreen].bounds.size.width - CELL_WIDTH)/2, 0);
    CGSize size = CGSizeMake(CELL_WIDTH, _layout.statusViewHeight);
    _statusView.frame =(CGRect){origin, size};
    
    _commentView.frame = CGRectMake(origin.x, CGRectGetMaxY(_statusView.frame) +PADDING, CELL_WIDTH, self.view.height - _statusView.height);
    
    [self.view addSubview:_statusView];
    [self.view addSubview:_commentView];
    
    
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
