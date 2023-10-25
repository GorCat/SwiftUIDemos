//
//  OWLBGMModuleUserModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleUserModel : OWLBGMModuleBaseModel

/// 账号ID
@property (nonatomic, assign) NSInteger dsb_accountId;
/// 展示id
@property (nonatomic, copy) NSString *dsb_displayAccountId;
/// 头像
@property (nonatomic, copy) NSString *dsb_avatar;
/// 昵称
@property (nonatomic, copy) NSString *dsb_nickName;
/// 个人描述
@property (nonatomic, copy) NSString *dsb_mood;
/// 年龄
@property (nonatomic, assign) NSInteger dsb_age;
/// 粉丝
@property (nonatomic, assign) NSInteger dsb_followers;
/// 关注
@property (nonatomic, assign) NSInteger dsb_followings;
/// 礼物消耗
@property (nonatomic, assign) NSInteger dsb_giftCost;
/// 是否关注对方
@property (nonatomic, assign) BOOL dsb_isFollow;
/// 性别
@property (nonatomic, copy) NSString *dsb_gender;
/// 活动标签
@property (nonatomic, strong) NSArray <NSString *> *dsb_lables;
/// 默认活动标签
@property (nonatomic, copy) NSString *dsb_defaultEventLabel;
/// 是否是Svip
@property (nonatomic, assign) BOOL dsb_isSvip;
/// 黑名单状态
@property (nonatomic, assign) XYLModuleBlackListStatusType dsb_blockType;
/// 用户等级
@property (nonatomic, assign) NSInteger dsb_level;

@end

NS_ASSUME_NONNULL_END
