//
//  UserViewController.m
//  stalk
//
//  Created by Coding on 18/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserViewController.h"
#import "WBUser.h"
#import "WBRequestQueue.h"
#import "AppDelegate.h"
#import "WBHttpRequest+STalk.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *descriptions;

@end

@implementation UserViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clear.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clear247.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _screenName.text = _user.screenName;
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width/2;
    _iconImage.clipsToBounds =YES;
    _iconImage.imageURL = [NSURL URLWithString:_user.avatarLarge];
    _location.text = _user.location;
    _descriptions.text = _user.desc;
}

- (UIImage *)clearImage{
    NSArray *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [dir[0] stringByAppendingPathComponent:@"clear.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);

    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:(CGRect){0,0,20, 20}];
    
    [[UIColor clearColor] set];
    [bpath fill];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(snap) writeToFile:path atomically:YES];
    return snap;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setUser:(WBUser *)user{
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
//        WBUser *user = [WBUser userWithDict:result];
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
