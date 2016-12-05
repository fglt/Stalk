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
#import "WBStatusHelper.h"


@implementation UserDetailView

- (instancetype)init
{
    self = [super init];
    if(!self) return nil;
    _iconView = UIImageView.new;
    _iconView.size = CGSizeMake(80, 80);
    _name = UILabel.new;
    _name.numberOfLines = 1;
    _locatioin = UILabel.new;
    _locatioin.numberOfLines = 1;
    _descriptions = UILabel.new;
    _descriptions.numberOfLines = 0;
    
    [self addSubview:_iconView];
    [self addSubview:_name];
    [self addSubview:_locatioin];
    [self addSubview:_descriptions];
    return self;
}

- (void)layoutWithUser:(WBUser *)user{
    self.width = CellContentWidth;
    [_iconView setImageWithURL:[NSURL URLWithString:user.avatarLarge]
               placeholder:nil
                   options:kNilOptions
                   manager:[WBStatusHelper avatarImageManager]
                  progress:nil
                 transform:nil
                completion:nil];
    _name.font = [UIFont systemFontOfSize:15];
    _name.text = user.screenName;
    _name.frame = CGRectMake(0, _iconView.bottom +10, self.width, _name.font.lineHeight);
    
    _descriptions.font = [UIFont systemFontOfSize:15];
    CGSize descSize = [ user.desc boundingRectWithSize:CGSizeMake(self.width,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_descriptions.font} context:nil].size;
    
    _locatioin.font = [UIFont systemFontOfSize:15];
    _locatioin.top = _name.bottom +10;
    _locatioin.text = user.location;
    _locatioin.width = self.width;
    _locatioin.height = _locatioin.font.lineHeight;
    
    _descriptions.width = self.width;
    _descriptions.height = descSize.height;
    _descriptions.text = user.desc;
    _descriptions.top = _locatioin.bottom +20;
    
    self.height = CGRectGetMaxY(_descriptions.frame);
}
@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _coverView = [UIImageView new];
    _userView = [UserDetailView new];
    [self addSubview:_coverView];
    [self addSubview:_userView];
    
    return self;
}

- (void)layoutWithUser:(WBUser *)user{
    if(self.width ==0){
        self.width = [UIScreen mainScreen].bounds.size.width;
    }
    _coverView.top = -64;
    _coverView.width = self.width;
    _coverView.height = 254;
    if(user.coverImage){
        _coverView.imageURL = [NSURL URLWithString:user.coverImage];
    }else{
        _coverView.imageURL = [NSURL URLWithString:user.coverImagePhone];
    }
    [_userView layoutWithUser:user];
    _userView.left = (self.width - _userView.width)/2;
    _userView.top = _coverView.bottom - 50;
    self.height = CGRectGetMaxY(_userView.frame);
}

@end
