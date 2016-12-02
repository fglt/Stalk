//
//  UserDetailView.m
//  stalk
//
//  Created by Coding on 02/12/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UserDetailView.h"
#import "WBUser.h"
#import "WBStatusLayout.h"

@implementation UserDetailView

- (instancetype)init{
    self = [super init];
    _iconView = [UIImageView new];
    _name = UILabel.new;
    _locatioin = UILabel.new;
    _descriptions = UILabel.new;
    
    [self addSubview:_iconView];
    [self addSubview:_name];
    [self addSubview:_locatioin];
    [self addSubview:_descriptions];
    return self;
}

- (void)configureWithWBUser:(WBUser *)user{
    
    _iconView.imageURL =[NSURL URLWithString:user.avatarLarge];
    _name.font = [UIFont systemFontOfSize:15];
    _name.text =user.screenName;
    CGSize nameSize = [_name.text boundingRectWithSize:CGSizeMake(1000,2000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_name.font} context:nil].size;
    
   
    
    _locatioin.text = user.location;
    _descriptions.text = user.desc;
}
@end
