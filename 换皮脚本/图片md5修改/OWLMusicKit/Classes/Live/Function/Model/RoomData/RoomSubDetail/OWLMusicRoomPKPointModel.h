//
//  OWLMusicRoomPKPointModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据 - 得分数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomPKPointModel : OWLBGMModuleBaseModel

/// 主持人Id
@property (nonatomic, assign) NSInteger dsb_accountID;
/// 积分
@property (nonatomic, assign) NSInteger dsb_points;
/// 前三守护用户头像
@property (nonatomic, strong) NSArray *dsb_topThreeAvatars;

@end

NS_ASSUME_NONNULL_END
