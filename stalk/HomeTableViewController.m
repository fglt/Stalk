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
#import "YYPhotoGroupView.h"
#import "PhotoBrowerViewController.h"

@interface HomeTableViewController ()<WBStatusCellDelegate,SFSafariViewControllerDelegate>
@property (nonatomic, strong) StatusDataSource *dataSource;
@end

@implementation HomeTableViewController{
    NSMutableArray *needLoadArr;
    BOOL scrollToToping;
    YYFPSLabel *_fpsLabel;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clear247.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    CGAffineTransform transform = [coordinator targetTransform];
//    CGAffineTransform invertedRotation = CGAffineTransformInvert(transform);
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
////        blackview.transform = CGAffineTransformConcat(blackview.transform, invertedRotation);
////        blackview.center = blackview.superview.center;
////        if(picBrower){
//           // picBrower.transform = CGAffineTransformConcat(picBrower.transform, invertedRotation);
//        //picBrower.frame = picBrower.superview.bounds;
//       // picBrower.center = picBrower.superview.center;
//       // picBrower.contentView.transform =CGAffineTransformConcat(picBrower.contentView.transform, transform);
//        //[picBrower.contentView layoutSubviews];
//          //  [picBrower dismiss];
//
//           // CGFloat width = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//            //picBrower.frame = CGRectMake(0, 0, width, width);
////            picBrower.center = picBrower.superview.center;
// //           NSLog(@"%@self:@",NSStringFromCGRect(picBrower.frame));
// //           NSLog(@"%@super:@",NSStringFromCGRect(picBrower.superview.bounds));
////        }
//        //        NSLog(@"%@",NSStringFromCGPoint(CGPointApplyAffineTransform(center, transform) ));
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
////        [picBrower setNeedsLayout];
//    }];
//}

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

- (void)cell:(WBStatusCell *)cell didClickImageAt:(NSUInteger)index{
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    
    WBStatus *status = cell.layout.status;

    NSArray *picviews;
    if(status.retweetedStatus){
        status = cell.layout.status.retweetedStatus;
        picviews = cell.statusView.retweetPictureHolder.subviews;
    }else{
        picviews = cell.statusView.pictureHolder.subviews;
    }

    for (NSUInteger i = 0, max = picviews.count; i < max; i++) {
        UIView *imgView = picviews[i];

        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = status.pictures[i].original.url;
        [[YYWebImageManager sharedManager] requestImageWithURL:item.largeImageURL options:YYWebImageOptionAvoidSetImage progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            item.largeImageSize = image.size;
        }];
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
        
    }
    
//    blackview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    blackview.backgroundColor = [UIColor redColor];
 //   [self.tabBarController.view  addSubview:blackview];
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [photoGroupView presentFromImageView:fromView coContainer:self.tabBarController.view animated:YES completion:nil];
    PhotoBrowerViewController *brower = [[PhotoBrowerViewController alloc]init];
    brower.groupView = photoGroupView;
    brower.fromView = fromView;
    [self.navigationController pushViewController:brower animated:NO];
}

- (void)cell:(WBStatusCell *)cell didClickLink:(MLLink *)link
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
                        userViewController.hidesBottomBarWhenPushed = YES;
                        userViewController.title = user.screenName;
                        [self.navigationController pushViewController:userViewController animated:YES];
                    }
                });
            }];
            break;
        }
//        case MLLinkTypeHashtag:{
//            NSString *topic = [link.linkValue substringWithRange:NSMakeRange(1, link.linkValue.length-1)];
//            TopicController *controller = [[TopicController alloc]init];
//            controller.topic = topic;
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
        default:
            break;
    }
}

- (void)cellDidClick:(WBStatusCell *)cell;{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    detailViewController.layout = cell.layout;
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)cellDidClickRetweet:(WBStatusCell *)cell;{
    StatusDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusDetailViewController"];
    WBStatus *status = cell.layout.status.retweetedStatus;
    detailViewController.layout = [[WBStatusLayout alloc] initWithStatus:status];
    detailViewController.title = @"微博正文";
    [self.navigationController pushViewController:detailViewController animated:YES];

}
- (void)cellDidClickUser:(WBStatusCell *)cell{
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
