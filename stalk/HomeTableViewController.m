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
#import "WBStatusLayout.h"
#import "WBHttpRequest+FGLTWeiboStatus.h"
#import "StatusDetailViewController.h"
#import "MLLinkLabel.h"
#import "WBHttpRequest+WBUser.h"
#import "UserViewController.h"
#import <SafariServices/SafariServices.h>
#import "WBRequestQueue.h"
#import "NSObject+runtime.h"
#import "YYFPSLabel.h"

@interface HomeTableViewController ()<WBStatusCellDelegate,SFSafariViewControllerDelegate>
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
        
        self.statuesList = [WBStatusLayout statusLayoutsWithStatuses:[FGLTStatus statuesWithDict:dict]];
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
//    for(WBStatusLayout *layout in self.statuesList){
//        [layout resetFrame];
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
    cell.layout = _statuesList[indexPath.row];
    cell.delegate =self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WBStatusLayout *info = _statuesList[indexPath.row];
    return info.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
//    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
//    WBStatusLayout *info = [self.statuesList objectAtIndex:selectedIndex];;
//    detailViewController.layout = info;
//    detailViewController.title = @"微博正文";
//    [self.navigationController pushViewController:detailViewController animated:YES];
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

- (void)cellLinkIsClicked:(WBStatusCell *)cell :(MLLink *)link
{
    cell.userInteractionEnabled = NO;
    if (link.linkType==MLLinkTypeURL) {
        NSURL *url = [NSURL URLWithString:link.linkValue];
        SFSafariViewController *controller = [[SFSafariViewController alloc]initWithURL:url entersReaderIfAvailable:YES];
        [self presentViewController:controller animated:YES completion:nil];
        cell.userInteractionEnabled = YES;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.linkValue] options:@{} completionHandler:nil];
        return;
    }else if (link.linkType == MLLinkTypeUserHandle) {
        
        NSString *screenName = [link.linkValue substringFromIndex:1];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [WBHttpRequest requestForUserWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken screen_name:screenName queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            FGLTUser *user = [FGLTUser userWithDict:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.userInteractionEnabled = YES;
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

        
       //[self.navigationController pushViewController:userViewController animated:YES];

        return;
    }
}

- (void)cellStatusIsClicked:(WBStatusCell *)cell{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    WBStatusLayout *layout = [self.statuesList objectAtIndex:selectedIndex];;
    detailViewController.layout = layout;
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)cellRetweetIsClicked:(WBStatusCell *)cell{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    WBStatusLayout *layout = [self.statuesList objectAtIndex:selectedIndex];;
    detailViewController.layout = layout;
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];

}
- (void)cellUserIsClicked:(WBStatusCell *)cell{
    UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    userViewController.user =  cell.layout.status.user;
    userViewController.title = userViewController.user.screenName;
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
