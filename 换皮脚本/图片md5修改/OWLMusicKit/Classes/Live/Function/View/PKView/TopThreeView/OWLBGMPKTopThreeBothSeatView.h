//
//  OWLBGMPKTopThreeBothSeatView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK控制层 - 两边前三名座位
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLMusicPKBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKTopThreeBothSeatView : OWLMusicPKBaseView

/// PK数据
@property (nonatomic, strong) OWLMusicRoomPKDataModel *__nullable xyp_pkData;

@end

NS_ASSUME_NONNULL_END
