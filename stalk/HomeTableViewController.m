//
//  HomeTableViewController.m
//  stalk
//
//  Created by Coding on 11/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "HomeTableViewController.h"
#import "FGLTUser.h"
#import "FGLTStatus.h"
#import "AppDelegate.h"
#import "WBStatusCell.h"
#import "StatusInfo.h"
#import "WBHttpRequest+FGLTWeiboStatus.h"
#import "StatusDetailViewController.h"
#import "MLLinkLabel.h"
#import "WBHttpRequest+WBUser.h"
#import "UserViewController.h"
#import <SafariServices/SafariServices.h>
#import "WBRequestQueue.h"
#import "NSObject+runtime.h"
#import "YYFPSLabel.h"

@interface HomeTableViewController ()<StatusTableViewCellDelegate,SFSafariViewControllerDelegate>
@property (nonatomic, strong) NSArray *statuesList;
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
    NSLog(@"%@",self.view.class);
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - 100;
    _fpsLabel.left = 12;
    _fpsLabel.alpha = 0;
    [self.navigationController.navigationBar addSubview:_fpsLabel];
    _fpsLabel.center = (CGPoint){self.navigationController.navigationBar.bounds.size.width/2,self.navigationController.navigationBar.bounds.size.height/2};
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.size = CGSizeMake(50, 50);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *dict = @{@"count":[NSString stringWithFormat:@"%d",100]};
    [WBHttpRequest requestForStatusesOfPath:@"friends_timeline" withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:dict queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSDictionary *dict = [result objectForKey:@"statuses"];
        
        self.statuesList = [StatusInfo statusInfosWithStatuses:[FGLTStatus statuesWithDict:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [self.tableView reloadData];
        });
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    for(StatusInfo *statusInfo in self.statuesList){
//        [statusInfo resetFrame];
//    }
//    [self.tableView reloadData];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statuesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WBStatusCell * cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ALLStatusesCellID"];
    cell.statusInfo = _statuesList[indexPath.row];
    cell.cellDelegate =self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusInfo *info = _statuesList[indexPath.row];
    return info.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    StatusInfo *info = [self.statuesList objectAtIndex:selectedIndex];;
    detailViewController.statusInfo = info;
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)cellLinkIsClicked:(MLLink *)link
{
    if (link.linkType==MLLinkTypeURL) {
        NSURL *url = [NSURL URLWithString:link.linkValue];
        SFSafariViewController *controller = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:YES];
        [self presentViewController:controller animated:YES completion:nil];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.linkValue] options:@{} completionHandler:nil];
        return;
    }else if (link.linkType == MLLinkTypeUserHandle) {
        
        NSString *screenName = [link.linkValue substringFromIndex:1];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [WBHttpRequest requestForUserWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken screen_name:screenName queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            FGLTUser *user = [FGLTUser userWithDict:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!user){
                    
                    //[self.navigationController popViewControllerAnimated:YES];
                    NSString *title = @"提示";
                    NSString *message = [NSString stringWithFormat:@"用户%@不存在", link.linkValue];
                    NSMutableAttributedString *attmess = [[NSMutableAttributedString alloc]initWithString:message];
                    [attmess addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(2, link.linkValue.length)];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                    if ([alert existVar:@"attributedMessage"]) {
                        [alert setValue:attmess forKey:@"attributedMessage"];
                    }
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:yesAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
      
                }else{
                    UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
                    userViewController.user = user;
                    userViewController.title = user.screenName;
                    [self.navigationController pushViewController:userViewController animated:YES];
                    //self.user = user;
                    //self.title = user.screenName;
                }
            });
        }];

        
      
       //[self.navigationController pushViewController:userViewController animated:YES];

        return;
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
