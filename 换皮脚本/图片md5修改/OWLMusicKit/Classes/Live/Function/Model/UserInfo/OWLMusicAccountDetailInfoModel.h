//
//  OWLMusicAccountDetailInfoModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间用户信息弹窗的模型
 * @创建时间：2023.2.21
 * @创建人：许琰
 * @备注：此模型为本地的模型。由user模型和anchor模型转成信息弹窗的视图模型
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicAccountDetailInfoModel : NSObject

#pragma mark - Public
/// 账号ID
@property (nonatomic, assign) NSInteger xyp_accountId;
/// 展示id
@property (nonatomic, copy) NSString *xyp_displayAccountId;
/// 头像
@property (nonatomic, copy) NSString *xyp_avatar;
/// 昵称
@property (nonatomic, copy) NSString *xyp_nickName;
/// 个人描述
@property (nonatomic, copy) NSString *xyp_mood;
/// 年龄
@property (nonatomic, assign) NSInteger xyp_age;
/// 粉丝
@property (nonatomic, assign) NSInteger xyp_followers;
/// 关注
@property (nonatomic, assign) NSInteger xyp_followings;
/// 是否关注对方
@property (nonatomic, assign) BOOL xyp_isFollow;
/// 性别
@property (nonatomic, copy) NSString *xyp_gender;
/// 活动标签
@property (nonatomic, strong) NSArray <NSString *> *xyp_lables;
/// 默认活动标签
@property (nonatomic, copy) NSString *xyp_defaultEventLabel;
/// 黑名单状态
@property (nonatomic, assign) XYLModuleBlackListStatusType xyp_blockType;
/// 是否是主播
@property (nonatomic, assign) BOOL xyp_isAnchor;

#pragma mark - User
/// 礼物消耗
@property (nonatomic, assign) NSInteger xyp_giftCost;
/// 用户等级
@property (nonatomic, assign) NSInteger xyp_level;
/// 是否是Svip
@property (nonatomic, assign) BOOL xyp_isSvip;

#pragma mark - Anchor
/// 点赞数
@property (nonatomic, assign) NSInteger xyp_commentUp;
/// 点踩数
@property (nonatomic, assign) NSInteger xyp_commentDown;
/// 主播标签
@property (nonatomic, assign) NSInteger xyp_flag;

#pragma mark - 初始化
/// 根据主播模型转换成详情模型
+ (OWLMusicAccountDetailInfoModel *)xyf_configModelWithAnchor:(OWLBGMModuleAnchorModel *)model;

/// 根据用户模型转换成详情模型
+ (OWLMusicAccountDetailInfoModel *)xyf_configModelWithUser:(OWLBGMModuleUserModel *)model;

@end

NS_ASSUME_NONNULL_END
