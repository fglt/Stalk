//
//  PhotoBrowerViewController.m
//  stalk
//
//  Created by Coding on 26/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PhotoBrowerViewController.h"

@interface PhotoBrowerViewController ()
@property (nonatomic) BOOL navgationIsHide;
@property (nonatomic) BOOL tabIsHide;
@end

@implementation PhotoBrowerViewController

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _navgationIsHide = self.navigationController.navigationBar.hidden;
    _tabIsHide = self.tabBarController.tabBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [_groupView presentFromImageView:_fromView coContainer:self.view animated:YES completion:^{
        self.navigationController.navigationBar.hidden = _navgationIsHide;
        self.tabBarController.tabBar.hidden = _tabIsHide;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
