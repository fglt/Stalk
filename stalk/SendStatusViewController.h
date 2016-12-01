//
//  SendStatusViewController.h
//  stalk
//
//  Created by Coding on 22/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatus;

typedef NS_ENUM(NSInteger, SendMessageType){
    SendMessageTypeStatus = 0,
    SendMessageTypeRepost,
    SendMessageTypeComment
};

@interface SendStatusViewController : UIViewController
@property (nonatomic) SendMessageType messageType;
@property (nonatomic, strong) WBStatus *status;
@end
