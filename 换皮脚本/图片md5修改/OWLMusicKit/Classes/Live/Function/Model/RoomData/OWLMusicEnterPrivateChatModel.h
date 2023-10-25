//
//  OWLMusicEnterPrivateChatModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/7.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicEnterPrivateChatModel : OWLBGMModuleBaseModel

/// 角色类型（1：用户 2：主播）
@property (nonatomic, assign) NSUInteger dsb_roleType;
/// 房间Id
@property (nonatomic, assign) NSUInteger dsb_roomID;
/// 用户账号Id
@property (nonatomic, assign) NSUInteger dsb_userAccountID;
/// 主播账号Id
@property (nonatomic, assign) NSUInteger dsb_anchorAccountID;
/// 剩余金币
@property (nonatomic, assign) NSUInteger dsb_leftCoins;
/// 用户昵称
@property (nonatomic, copy) NSString *dsb_userName;
/// 主播昵称
@property (nonatomic, copy) NSString *dsb_anchorName;
/// 开始计时的时间戳 （从UTC+0时区 2017-01-01 00:00:00 开始到现在的秒数）
@property (nonatomic, assign) NSUInteger dsb_callTime;
/// 计费单价
@property (nonatomic, assign) NSUInteger dsb_initialPrice;
/// 主播头像
@property (nonatomic, copy) NSString *dsb_anchorAvatar;
/// 是否已关注她
@property (nonatomic, assign) BOOL dsb_isFollow;
/// 主播年龄
@property (nonatomic, assign) NSUInteger dsb_anchorAge;
/// 主播性别
@property (nonatomic, copy) NSString *dsb_anchorSex;
/// 带走价格
@property (nonatomic, assign) NSUInteger dsb_takePrice;
/// 用户头像
@property (nonatomic, copy) NSString *dsb_userAvatar;

@end

NS_ASSUME_NONNULL_END
