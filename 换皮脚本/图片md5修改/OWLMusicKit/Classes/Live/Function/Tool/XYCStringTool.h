//
//  XYCStringTool.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCStringTool : NSObject

#pragma mark 禁言相关
/// 是否被禁言
+ (NSString *)xyf_userMute:(BOOL)isMute;

#pragma mark PK相关
/// 用户逃跑
+ (NSString *)xyf_userQuitPKWithIsOther:(BOOL)isOther;

/// 主播逃跑
+ (NSString *)xyf_hostQuitPKWithIsOther:(BOOL)isOther;

#pragma mark 广播相关
+ (NSString *)xyf_operateBroadcast:(BOOL)isClose;


@end

NS_ASSUME_NONNULL_END
