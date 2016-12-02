//
//  SendStatusViewController.m
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "SendStatusViewController.h"
#import "AppDelegate.h"
#import "WBRequestQueue.h"
#import "WBStatus.h"


@interface SendStatusViewController ()
@property (strong, nonatomic) UITextView *statusTextView;

@end

@implementation SendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];

    [self.navigationItem setRightBarButtonItem:sendButton] ;
    self.navigationController.navigationBarHidden = NO;
    _statusTextView = [UITextView new];
    _statusTextView.frame = self.view.bounds;
    _statusTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_statusTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)send{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    switch (_messageType) {
        case SendMessageTypeStatus:{
            [WBHttpRequest requestForShareAStatus:_statusTextView.text contatinsAPicture:nil orPictureUrl:nil withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                NSLog(@"%@", result);
            }];
        }
            break;
        case SendMessageTypeRepost:{
            [WBHttpRequest requestForRepostAStatus:[NSString stringWithFormat:@"%lld",_status.lid] repostText:_statusTextView.text withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                NSLog(@"%@", result);
            }];
        }
        case SendMessageTypeComment:{
            
        }
            break;
        default:
            break;
    }
}

- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
