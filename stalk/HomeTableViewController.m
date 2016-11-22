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

@interface HomeTableViewController ()<WBStatusCellDelegate,SFSafariViewControllerDelegate>
@property (nonatomic, strong) StatusDataSource *dataSource;
@end

@implementation HomeTableViewController{
    NSMutableArray *needLoadArr;
    BOOL scrollToToping;
    YYFPSLabel *_fpsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.delegate = self;
    [self.tableView registerClass:[WBStatusCell class] forCellReuseIdentifier:@"ALLStatusesCellID"];
    _dataSource = [[StatusDataSource alloc]initWithCellIdentifer:@"ALLStatusesCellID" block:^(id cell, id statusLayout) {
        WBStatusCell *wbcell = (WBStatusCell *)cell;
        wbcell.layout = (WBStatusLayout *) statusLayout;
        wbcell.delegate = self;
    }];
    self.tableView.dataSource = _dataSource;

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
    [self.dataSource loadDataWithCompletionHandler:^(NSError *error) {
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

#pragma mark - cellDelegate
- (void)cellLinkIsClicked:(WBStatusCell *)cell :(MLLink *)link
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (link.linkType) {
        case MLLinkTypeURL:{
            SFSafariViewController *controller = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:link.linkValue] entersReaderIfAvailable:YES];
            [self presentViewController:controller animated:YES completion:nil];
            break;
        }
        case MLLinkTypeUserHandle:{
            NSString *screenName = [link.linkValue substringFromIndex:1];
            
            [WBHttpRequest requestForUserWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken screen_name:screenName queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                WBUser *user = [WBUser userWithDict:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!user){
                        NSString *title = @"提示";
                        NSString *message = [NSString stringWithFormat:@"用户%@不存在", link.linkValue];
                        NSMutableAttributedString *attmess = [[NSMutableAttributedString alloc]initWithString:message];
                        [attmess addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2, link.linkValue.length)];
                        
                        UIAlertController *alert = [self alertControllerWithTitle:title message:attmess];
                        [self presentViewController:alert animated:YES completion:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                        
                    }else{
                        UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
                        userViewController.user = user;
                        userViewController.title = user.screenName;
                        [self.navigationController pushViewController:userViewController animated:YES];
                    }
                });
            }];
            break;
        }
        case MLLinkTypeHashtag:{
            NSString *topic = [link.linkValue substringWithRange:NSMakeRange(1, link.linkValue.length-1)];
            TopicController *controller = [[TopicController alloc]init];
            controller.topic = topic;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)cellStatusIsClicked:(WBStatusCell *)cell{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    detailViewController.layout = cell.layout;
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)cellRetweetIsClicked:(WBStatusCell *)cell{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    WBStatus *status = cell.layout.status.retweetedStatus;
    detailViewController.layout = [[WBStatusLayout alloc] initWithStatus:status];
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];

}
- (void)cellUserIsClicked:(WBStatusCell *)cell{
    UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    userViewController.user =  cell.layout.status.user;
    [self.navigationController pushViewController:userViewController animated:YES];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendStatus:(UIBarButtonItem *)sender {
}


- (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSAttributedString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message.string preferredStyle:UIAlertControllerStyleAlert];
    
    if ([alert existVar:@"attributedMessage"]) {
        [alert setValue:message forKey:@"attributedMessage"];
    }
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:yesAction];
    return alert;
}
@end
