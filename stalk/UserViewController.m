//
//  UserViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserViewController.h"
#import "FGLTUser.h"
#import "WBRequestQueue.h"
#import "AppDelegate.h"
#import "WBHttpRequest+WBUser.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *descriptions;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _screenName.text = _user.screenName;
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width/2;
    _iconImage.clipsToBounds =YES;
    _iconImage.imageURL = [NSURL URLWithString:_user.avatarLarge];
    _location.text = _user.location;
    _descriptions.text = _user.desc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setUser:(FGLTUser *)user{
//    _user = user;
//    self.title = user.screenName;
////    _screenName.text = _user.screenName;
////    _iconImage.layer.cornerRadius = _iconImage.frame.size.width/2;
////    _iconImage.clipsToBounds =YES;
////    _iconImage.imageURL = [NSURL URLWithString:_user.avatarLarge];
////    _location.text = _user.location;
////    _descriptions.text = _user.desc;
//    
//}

//- (void)setUserName:(NSString *)screenName{
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [WBHttpRequest requestForUserWithAccessToken:appDelegate.wbAuthorizeResponse.accessToken screen_name:screenName queue:[WBRequestQueue queueForWBRequest] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//        FGLTUser *user = [FGLTUser userWithDict:result];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(!user){
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                self.user = user;
//                self.title = user.screenName;
//            }
//        });
//    }];
//
//}

@end
