//
//  EmotionHelper.m
//  stalk
//
//  Created by Coding on 16/11/2016.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "EmotionHelper.h"
#import "WBHttpRequest+WeiboEmotion.h"
#import "AppDelegate.h"
#import "Emotion.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

static EmotionHelper *sharedEmotionHelper;
@implementation EmotionHelper
+ (instancetype)sharedEmotionHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEmotionHelper = [[EmotionHelper alloc]init];
        
        NSString *bundleName = @"emotionResource.bundle";
        
//        NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *faceEmotionPath = [dir stringByAppendingPathComponent:@"faceEmotion.plist"];
//        NSString *aniEmotionPath = [dir stringByAppendingPathComponent:@"aniEmotion.plist"];
//        NSString *cartoonEmotionPath = [dir stringByAppendingPathComponent:@"cartoonEmotion.plist"];
//        NSFileManager *manager = [ NSFileManager defaultManager];
//        BOOL  fileExits = [manager fileExistsAtPath:faceEmotionPath];
//        if(fileExits){
//            sharedEmotionHelper.faceEmotionsArray = [NSMutableArray arrayWithContentsOfFile:faceEmotionPath];
//            sharedEmotionHelper.aniEmotionsArray = [NSMutableArray arrayWithContentsOfFile:aniEmotionPath];
//            sharedEmotionHelper.cartoonEmotionsArray = [NSMutableArray arrayWithContentsOfFile:cartoonEmotionPath];
//        }else{
//            NSString *expressionDir = [dir stringByAppendingPathComponent:@"ClippedExpression"];
//            NSLog(@"%@", expressionDir);
//            sharedEmotionHelper.faceEmotionsArray = [NSMutableArray array];
//            sharedEmotionHelper.aniEmotionsArray = [NSMutableArray array];
//            sharedEmotionHelper.cartoonEmotionsArray = [NSMutableArray array];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//            [WBHttpRequest requestForEmotionwithAccessToken:appDelegate.wbAuthorizeResponse.accessToken type:@"face" andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//                for(NSDictionary *dict in result){
//                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dict[@"url"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        NSString *phrase = dict[@"phrase"];
//                        NSString *newImagePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", dict[@"phrase"]]];
//                        BOOL sucess = [UIImagePNGRepresentation(image) writeToFile:newImagePath atomically:YES];
//                        NSLog(@"%d",sucess);
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:dict[@"url"]];
//                    }];
//                    [sharedEmotionHelper.faceEmotionsArray addObject:dict];
//                }
//            [sharedEmotionHelper.faceEmotionsArray writeToFile:faceEmotionPath atomically:YES];
//
//            }];
//            [WBHttpRequest requestForEmotionwithAccessToken:appDelegate.wbAuthorizeResponse.accessToken type:@"ani" andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//                for(NSDictionary *dict in result){
//                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dict[@"url"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        NSString *phrase = dict[@"phrase"];
//                        NSString *newImagePath = [expressionDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",dict[@"phrase"]]];
//                        [UIImagePNGRepresentation(image) writeToFile:newImagePath atomically:YES];
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:dict[@"url"]];
//                    }];
//
//                    [sharedEmotionHelper.aniEmotionsArray addObject:dict];
//                }
//                [sharedEmotionHelper.faceEmotionsArray writeToFile:aniEmotionPath atomically:YES];
//            }];
//            [WBHttpRequest requestForEmotionwithAccessToken:appDelegate.wbAuthorizeResponse.accessToken type:@"cartoon" andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//                
//                for(NSDictionary *dict in result){
//                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dict[@"url"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        NSString *phrase = dict[@"phrase"];
//                        NSString *newImagePath = [expressionDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",dict[@"phrase"]]];
//                        [UIImagePNGRepresentation(image) writeToFile:newImagePath atomically:YES];
//                        [[SDImageCache sharedImageCache] storeImage:image forKey:dict[@"url"]];
//                    }];
//
//                    [sharedEmotionHelper.cartoonEmotionsArray addObject:dict];
//                }
//                [sharedEmotionHelper.faceEmotionsArray writeToFile:cartoonEmotionPath atomically:YES];
//            }];
//        }
    });
    
    return sharedEmotionHelper;
}

- (Emotion *)emotionWithValue:(NSString *)value{
    for(NSDictionary *emotion in _faceEmotionsArray){
        if([emotion[@"phrase"] isEqualToString:value]){
            return [Emotion emotionFromDict:emotion];
        }
    }
    for(NSDictionary *emotion in _aniEmotionsArray){
        if([emotion[@"phrase"] isEqualToString:value]){
            return [Emotion emotionFromDict:emotion];
        }
    }
    for(NSDictionary *emotion in _cartoonEmotionsArray){
        if([emotion[@"phrase"] isEqualToString:value]){
            return [Emotion emotionFromDict:emotion];
        }
    }
    return nil;
}
@end
