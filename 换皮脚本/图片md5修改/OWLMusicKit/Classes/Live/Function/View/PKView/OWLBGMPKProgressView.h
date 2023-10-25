//
//  OWLBGMPKProgressView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK - PK进度条视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLMusicPKBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMPKProgressView : OWLMusicPKBaseView

/// PK数据
@property (nonatomic, strong) OWLMusicRoomPKDataModel *__nullable xyp_pkData;

@end

NS_ASSUME_NONNULL_END
