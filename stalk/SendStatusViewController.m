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


@interface SendStatusViewController ()
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@end

@implementation SendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendStatus:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WBHttpRequest requestForShareAStatus:_statusTextView.text contatinsAPicture:nil orPictureUrl:nil withAccessToken:appDelegate.wbAuthorizeResponse.accessToken andOtherProperties:nil queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSLog(@"%@", result);
    }];
}

@end
