//
//  WBPicture.h
//  stalk
//
//  Created by Coding on 23/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 图片标记
typedef NS_ENUM(NSUInteger, WBPictureBadgeType) {
    WBPictureBadgeTypeNone = 0, ///< 正常图片
    WBPictureBadgeTypeLong,     ///< 长图
    WBPictureBadgeTypeGIF,      ///< GIF
};

/**
 一个图片的元数据
 */
@interface WBPictureMetadata : NSObject
@property (nonatomic, strong) NSURL *url; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, strong) NSString *type; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1
@property (nonatomic, assign) WBPictureBadgeType badgeType;

+ (instancetype)metadataWithDict:(NSDictionary *)dict;
@end


/**
 图片
 */
@interface WBPicture : NSObject
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, assign) int photoTag;
@property (nonatomic, assign) BOOL keepSize; ///< YES:固定为方形 NO:原始宽高比
@property (nonatomic, strong) WBPictureMetadata *thumbnail;  ///< w:180
@property (nonatomic, strong) WBPictureMetadata *bmiddle;    ///< w:360 (列表中的缩略图)
@property (nonatomic, strong) WBPictureMetadata *original;   ///<

@end

