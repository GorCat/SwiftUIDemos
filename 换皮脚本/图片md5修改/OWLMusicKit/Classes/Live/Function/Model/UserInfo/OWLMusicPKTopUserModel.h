//// OWLMusicPKTopUserModel.h
// qianDuoDuo
//
// 
//


#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicPKTopUserModel : OWLBGMModuleBaseModel

/// 账号ID
@property (nonatomic, assign) NSInteger dsb_userID;
/// 头像
@property (nonatomic, copy) NSString *dsb_userAvatar;
/// 昵称
@property (nonatomic, copy) NSString *dsb_nickname;
/// 是否是vip
@property (nonatomic, assign) BOOL dsb_isVipUser;
/// 是否是svip
@property (nonatomic, assign) BOOL dsb_isSVipUser;
/// 分数
@property (nonatomic, assign) NSInteger dsb_userGoals;
/// 用户年龄
@property (nonatomic, assign) BOOL dsb_userAge;

@end

NS_ASSUME_NONNULL_END
