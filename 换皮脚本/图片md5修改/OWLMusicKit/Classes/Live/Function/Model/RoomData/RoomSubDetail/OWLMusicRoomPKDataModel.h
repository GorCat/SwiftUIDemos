//
//  OWLMusicRoomPKDataModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"
#import "OWLMusicRoomPKPlayerModel.h"
#import "OWLMusicRoomPKPointModel.h"
#import "OWLMusicRoomPKWinnerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomPKDataModel : OWLBGMModuleBaseModel

/// 主队玩家数据
@property (nonatomic, strong) OWLMusicRoomPKPlayerModel *dsb_ownerPlayer;
/// 客队玩家数据
@property (nonatomic, strong) OWLMusicRoomPKPlayerModel *dsb_otherPlayer;
/// 主队得分数据
@property (nonatomic, strong) OWLMusicRoomPKPointModel *dsb_ownerPoint;
/// 客队得分数据
@property (nonatomic, strong) OWLMusicRoomPKPointModel *dsb_otherPoint;
/// PK开始时间（从UTC+0时区 2017-01-01 00:00:00 开始到现在的秒数）
@property (nonatomic, assign) NSInteger dsb_startTime;
/// PK最大持续时长（秒）
@property (nonatomic, assign) NSInteger dsb_maxTime;
/// PK剩余时间（秒）
@property (nonatomic, assign) NSInteger dsb_leftTime;
/// 赢家数据
@property (nonatomic, strong) OWLMusicRoomPKWinnerModel *dsb_winAnchorData;

@end

NS_ASSUME_NONNULL_END
