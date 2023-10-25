//
//  OWLMusicRoomPKWinnerModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据 - 赢家数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomPKWinnerModel : OWLBGMModuleBaseModel

/// 账号ID
@property (nonatomic, assign) NSInteger dsb_accountID;
/// 连胜次数
@property (nonatomic, assign) NSInteger dsb_winTime;

@end

NS_ASSUME_NONNULL_END
