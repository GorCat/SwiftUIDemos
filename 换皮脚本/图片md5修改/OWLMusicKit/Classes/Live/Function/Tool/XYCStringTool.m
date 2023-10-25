//
//  XYCStringTool.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/17.
//

#import "XYCStringTool.h"

@implementation XYCStringTool

#pragma mark 禁言相关
/// 是否被禁言
+ (NSString *)xyf_userMute:(BOOL)isMute {
    return isMute ? kXYLLocalString(@"You have been muted.") : kXYLLocalString(@"You have been unmuted.");
}

#pragma mark PK相关
/// 用户逃跑
+ (NSString *)xyf_userQuitPKWithIsOther:(BOOL)isOther {
    if (isOther) {
        return kXYLLocalString(@"The other user quit. Congrats, your team wins this round!");
    } else {
        return kXYLLocalString(@"The user quit and lost this round!");
    }
    
}

/// 主播逃跑
+ (NSString *)xyf_hostQuitPKWithIsOther:(BOOL)isOther {
    if (isOther) {
        return kXYLLocalString(@"The other host quit. Congrats, your team wins this round!");
    } else {
        return kXYLLocalString(@"The host quit and lost this round!");
    }
}

#pragma mark 广播相关
+ (NSString *)xyf_operateBroadcast:(BOOL)isClose {
    if (isClose) {
        return kXYLLocalString(@"Broadcast is OFF. You won't receive top-placed notification of gifts from other rooms.");
    } else {
        return kXYLLocalString(@"Broadcast is ON. You will receive top-placed notification of gifts from other rooms.");
    }
}

@end
