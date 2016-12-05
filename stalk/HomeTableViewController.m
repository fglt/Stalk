//
//  HomeTableViewController.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "HomeTableViewController.h"
#import "WBUser.h"
#import "WBStatus.h"
#import "AppDelegate.h"
#import "WBStatusCell.h"
#import "WBStatusLayout.h"
#import "WBHttpRequest+STalk.h"
#import "StatusDetailViewController.h"
#import "MLLinkLabel.h"
#import "WBHttpRequest+STalk.h"
#import "UserViewController.h"
#import <SafariServices/SafariServices.h>
#import "WBRequestQueue.h"
#import "NSObject+runtime.h"
#import "YYFPSLabel.h"
#import "StatusDataSource.h"
#import "TopicController.h"
#import "PhotoBrowerViewController.h"
#import "WBStatusHelper.h"
#import "PhotoBrowerView.h"
#import "SendStatusViewController.h"
#import "WBStatusCellDelegateIMP.h"
#import "UINavigationBar+Awesome.h"

@interface HomeTableViewController ()
@property (nonatomic, strong) StatusDataSource *dataSource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;
@end

@implementation HomeTableViewController{
    YYFPSLabel *_fpsLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _cellDelegate = [WBStatusCellDelegateIMP new];
    _cellDelegate.controller = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    [self.tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"ALLStatusesCellID"];
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"ALLStatusesCellID" block:^(id cell, id statusLayout) {
        WBStatusCell *wbcell = (WBStatusCell *)cell;
        wbcell.layout = (WBStatusLayout *) statusLayout;
        wbcell.delegate = _cellDelegate;
    }];
    self.tableView.dataSource = _dataSource;
    [self setRefresh];

    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - 100;
    _fpsLabel.left = 12;
    _fpsLabel.alpha = 0;
    [self.navigationController.navigationBar addSubview:_fpsLabel];
    _fpsLabel.center = (CGPoint){self.navigationController.navigationBar.bounds.size.width/2,self.navigationController.navigationBar.bounds.size.height/2};
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [self activityIndicatorView];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [self.dataSource loadDataWithCompletion:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
        });
    }];
}

- (UIActivityIndicatorView *)activityIndicatorView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.size = CGSizeMake(50, 50);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    
    indicator.layer.cornerRadius = 6;
    return indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRefresh{
    UIRefreshControl *rc = [ [UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
}

- (void)refreshData{
    if(self.refreshControl.isRefreshing){
        [_dataSource updateStatusesWithCompletion:^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [_dataSource objectAtIndex :indexPath.row].height + CellPadding;
}

- (IBAction)sendStatus:(UIBarButtonItem *)sender {
    SendStatusViewController *sendController = [SendStatusViewController new];
    sendController.messageType = SendMessageTypeStatus;
    [self.navigationController pushViewController:sendController animated:YES];
}

@end
