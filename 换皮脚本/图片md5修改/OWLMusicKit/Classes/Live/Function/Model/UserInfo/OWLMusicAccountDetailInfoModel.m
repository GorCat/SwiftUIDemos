//
//  OWLMusicAccountDetailInfoModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

#import "OWLMusicAccountDetailInfoModel.h"

@implementation OWLMusicAccountDetailInfoModel

#pragma mark - 初始化
/// 根据主播模型转换成详情模型
+ (OWLMusicAccountDetailInfoModel *)xyf_configModelWithAnchor:(OWLBGMModuleAnchorModel *)model {
    OWLMusicAccountDetailInfoModel *config = [[OWLMusicAccountDetailInfoModel alloc] init];
    config.xyp_accountId = model.dsb_accountId;
    config.xyp_displayAccountId = model.dsb_displayAccountId;
    config.xyp_avatar = model.dsb_avatar;
    config.xyp_nickName = model.dsb_nickName;
    config.xyp_mood = model.dsb_mood;
    config.xyp_age = model.dsb_age;
    config.xyp_followers = model.dsb_followers;
    config.xyp_followings = model.dsb_followings;
    config.xyp_isFollow = model.dsb_isFollow;
    config.xyp_gender = model.dsb_gender;
    config.xyp_lables = model.dsb_lables;
    config.xyp_defaultEventLabel = model.dsb_defaultEventLabel;
    config.xyp_blockType = model.dsb_blockType;
    config.xyp_isAnchor = YES;
    
    config.xyp_commentUp = model.dsb_commentUp;
    config.xyp_commentDown = model.dsb_commentDown;
    config.xyp_flag = model.dsb_flag;
    return config;
}

/// 根据用户模型转换成详情模型
+ (OWLMusicAccountDetailInfoModel *)xyf_configModelWithUser:(OWLBGMModuleUserModel *)model {
    OWLMusicAccountDetailInfoModel *config = [[OWLMusicAccountDetailInfoModel alloc] init];
    config.xyp_accountId = model.dsb_accountId;
    config.xyp_displayAccountId = model.dsb_displayAccountId;
    config.xyp_avatar = model.dsb_avatar;
    config.xyp_nickName = model.dsb_nickName;
    config.xyp_mood = model.dsb_mood;
    config.xyp_age = model.dsb_age;
    config.xyp_followers = model.dsb_followers;
    config.xyp_followings = model.dsb_followings;
    config.xyp_isFollow = model.dsb_isFollow;
    config.xyp_gender = model.dsb_gender;
    config.xyp_lables = model.dsb_lables;
    config.xyp_defaultEventLabel = model.dsb_defaultEventLabel;
    config.xyp_blockType = model.dsb_blockType;
    config.xyp_isAnchor = NO;
    
    config.xyp_giftCost = model.dsb_giftCost;
    config.xyp_level = model.dsb_level;
    config.xyp_isSvip = model.dsb_isSvip;
    return config;
}

@end
