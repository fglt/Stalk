//
//  WBStatusCellDelegateIMP.m
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBStatusCellDelegateIMP.h"
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
#import "AppDelegate.h"

@interface WBStatusCellDelegateIMP()<SFSafariViewControllerDelegate>

@end
@implementation WBStatusCellDelegateIMP

- (instancetype)initWithController:(UIViewController *)controller{
    self = [super init];
    _controller = controller;
    return self;
}

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
        item.fromView = imgView;
        item.largeImageURL = [WBStatusHelper defaultURLForImageURL:status.pictures[i].original.url];
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    //    PhotoBrowerViewController *brower = [[PhotoBrowerViewController alloc]init];
    //    brower.fromView = fromView;
    //    brower.groupItems = items;
    //    [brower show];
    
    PhotoBrowerView *brower = [[PhotoBrowerView alloc] initWithItems:items];
    brower.fromView = fromView;
    [brower showWithAnimate:YES];
}

- (void)cell:(WBStatusCell *)cell didClickLink:(MLLink *)link
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (link.linkType) {
        case MLLinkTypeURL:{
            SFSafariViewController *controller = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:link.linkValue] entersReaderIfAvailable:YES];
            controller.delegate = self;
            [self.controller presentViewController:controller animated:YES completion:nil];
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
                        [self.controller presentViewController:alert animated:YES completion:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self.controller dismissViewControllerAnimated:YES completion:nil];
                        });
                        
                    }else{
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
                        userViewController.user = user;
                        userViewController.hidesBottomBarWhenPushed = YES;
                        [self.controller.navigationController pushViewController:userViewController animated:YES];
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
    StatusDetailViewController *detailViewController = [[StatusDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailViewController.layout = cell.layout;
    detailViewController.title = @"微博正文";
    [self.controller.navigationController pushViewController:detailViewController animated:YES];
}

- (void)cellDidClickRetweet:(WBStatusCell *)cell;{
    StatusDetailViewController *detailViewController = [[StatusDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    WBStatus *status = cell.layout.status.retweetedStatus;
    detailViewController.layout = [[WBStatusLayout alloc] initWithStatus:status];
    detailViewController.title = @"微博正文";
    [self.controller.navigationController pushViewController:detailViewController animated:YES];
    
}
- (void)cellDidClickUser:(WBStatusCell *)cell{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    userViewController.user =  cell.layout.status.user;
    [self.controller.navigationController pushViewController:userViewController animated:YES];
}

- (void)cellDidClickRepost:(WBStatusCell *)cell{
    SendStatusViewController *sendController = [SendStatusViewController new];
    sendController.messageType = SendMessageTypeRepost;
    sendController.status = cell.layout.status;
    [self.controller.navigationController pushViewController:sendController animated:YES];
}

- (void)cellDidClickComment:(WBStatusCell *)cell{
    SendStatusViewController *sendController = [SendStatusViewController new];
    sendController.messageType = SendMessageTypeComment;
    sendController.status = cell.layout.status;
    [self.controller.navigationController pushViewController:sendController animated:YES];
}

- (void)cellDidClickLike:(WBStatusCell *)cell{
    
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

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
