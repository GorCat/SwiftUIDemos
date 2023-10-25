//
//  OWLMusicMemberModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - 房间用户模型
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicMemberModel : OWLBGMModuleBaseModel

/// 账号ID
@property (nonatomic, assign) NSInteger xyp_accountId;
/// 展示id
@property (nonatomic, copy) NSString *xyp_displayAccountId;
/// 用户类型
@property (nonatomic, assign) XYLModuleMemberType xyp_roleType;
/// 头像
@property (nonatomic, copy) NSString *xyp_avatar;
/// 昵称
@property (nonatomic, copy) NSString *xyp_nickName;
/// 礼物消耗（用户）
@property (nonatomic, assign) NSInteger xyp_giftCost;
/// 点赞数（主播）
@property (nonatomic, assign) NSInteger xyp_commentUp;
/// 年龄
@property (nonatomic, assign) NSInteger xyp_age;
/// 性别
@property (nonatomic, copy) NSString *xyp_gender;
/// 用户等级
@property (nonatomic, assign) NSInteger xyp_level;
/// 是否是VIP
@property (nonatomic, assign) BOOL xyp_isVip;
/// 是否是SVIP
@property (nonatomic, assign) BOOL xyp_isSVip;
/// 是否是神秘人
@property (nonatomic, assign) BOOL xyp_isMysteriousMan;
/// 是否是主持人
@property (nonatomic, assign) BOOL xyp_isAdmin;

@end

NS_ASSUME_NONNULL_END
