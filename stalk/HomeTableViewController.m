//
//  HomeTableViewController.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "HomeTableViewController.h"
#import "WBStatusCell.h"
#import "StatusDataSource.h"
#import "SendStatusViewController.h"
#import "WBStatusCellDelegateIMP.h"

@interface HomeTableViewController ()
@property (nonatomic, strong) StatusDataSource *dataSource;
@property (nonatomic, strong) WBStatusCellDelegateIMP *cellDelegate;
@end

@implementation HomeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _cellDelegate = [WBStatusCellDelegateIMP new];
    _cellDelegate.controller = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    [self.tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"ALLStatusesCellID"];
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"ALLStatusesCellID" block:^(id cell, id statusLayout) {
        [(WBStatusCell *)cell configWithLayout:statusLayout delegate:_cellDelegate];
    }];
    self.tableView.dataSource = _dataSource;
    [self setRefresh];

    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [self activityIndicatorView];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [self.dataSource loadFrendsStatusWithCompletion:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
        });
    }];
}

//- (void)fpsConfigure{
//
//    _fpsLabel = [YYFPSLabel new];
//    [_fpsLabel sizeToFit];
//    _fpsLabel.bottom = self.view.height - 100;
//    _fpsLabel.left = 12;
//    _fpsLabel.alpha = 0;
//    [self.navigationController.navigationBar addSubview:_fpsLabel];
//    _fpsLabel.center = (CGPoint){self.navigationController.navigationBar.bounds.size.width/2,self.navigationController.navigationBar.bounds.size.height/2};
//
//}

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

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (_fpsLabel.alpha == 0) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            _fpsLabel.alpha = 1;
//        } completion:NULL];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//        if (_fpsLabel.alpha != 0) {
//            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                _fpsLabel.alpha = 0;
//            } completion:NULL];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (_fpsLabel.alpha != 0) {
//        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            _fpsLabel.alpha = 0;
//        } completion:NULL];
//    }
//}
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    if (_fpsLabel.alpha == 0) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            _fpsLabel.alpha = 1;
//        } completion:^(BOOL finished) {
//        }];
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [_dataSource cellHeightAtIndex:indexPath.row];
}

- (IBAction)sendStatus:(UIBarButtonItem *)sender {
    SendStatusViewController *sendController = [SendStatusViewController new];
    sendController.messageType = SendMessageTypeStatus;
    [self.navigationController pushViewController:sendController animated:YES];
}

- (IBAction)account:(id)sender {
    [self screenshot];
}

- (void)screenshot
{

    UIView *view = UIApplication.sharedApplication.keyWindow;
    UIView *tabbar = self.tabBarController.tabBar;
    
    UIGraphicsBeginImageContextWithOptions(tabbar.size, 1,0);
    
    [tabbar.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tabbarImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContextWithOptions(view.size, 1,0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [tabbarImage drawAtPoint:CGPointMake(0, view.height-tabbarImage.size.height)];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",dir);
}
@end
