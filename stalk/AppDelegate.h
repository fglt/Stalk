//
//  AppDelegate.h
//  stalk
//
//  Created by Coding on 10/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiBoDelegate <NSObject>

//登录的代理
-(void)weiboLoginByResponse:(WBBaseResponse *)response;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak  , nonatomic) id<WeiBoDelegate> weiBoDelegate;
@property (nonatomic, strong) WBAuthorizeResponse *wbAuthorizeResponse;
//@property (nonatomic, strong) EmotionHelper *emotionHelper;
@end

