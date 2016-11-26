//
//  PhotoBrowerViewController.h
//  stalk
//
//  Created by Coding on 26/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"

@interface PhotoBrowerViewController : UIViewController
@property (nonatomic, strong) YYPhotoGroupView *groupView;
@property (nonatomic, strong) UIView *fromView;
@end
