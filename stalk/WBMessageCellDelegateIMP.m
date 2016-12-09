//
//  WBMessageCellDelegateIMP.m
//  stalk
//
//  Created by Coding on 09/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "WBMessageCellDelegateIMP.h"
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
#import "TopicController.h"
#import "WBStatusHelper.h"
#import "PhotoBrowerView.h"
#import "SendStatusViewController.h"
#import "AppDelegate.h"

@interface WBMessageCellDelegateIMP()<SFSafariViewControllerDelegate>

@end

@implementation WBMessageCellDelegateIMP

- (void)cell:(WBMessageCell *)cell didClickLink:(MLLink *)link{
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
                WeiboUser *user = [WeiboUser userWithDictionary:result];
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

- (void)cellDidClick:(WBMessageCell *)cell{
    
}

- (void)cellDidClickUser:(WBMessageCell *)cell{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    userViewController.user =  cell.layout.message.user;
    userViewController.hidesBottomBarWhenPushed = YES;
    [self.controller.navigationController pushViewController:userViewController animated:YES];
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
