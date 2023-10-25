//
//  OWLMusicRoomTempModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

/**
 * @功能描述：直播间房间模型 - 房间的基本信息：留用快速预览及供加入房间
 * @创建时间：2023.2.17
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomTempModel : OWLBGMModuleBaseModel

/// 房间id
@property (nonatomic, assign) NSInteger xyp_roomId;
/// 声网房间号
@property (nonatomic, copy) NSString *xyp_agoraRoomId;
/// 主播ID
@property (nonatomic, assign) NSInteger xyp_anchorID;
/// 房间封面
@property (nonatomic, copy) NSString *xyp_cover;
/// 主播昵称
@property (nonatomic, copy) NSString *xyp_nickname;
/// 进入方式
@property (nonatomic, assign) XYLOutDataSourceEnterRoomType xyp_enterType;

@end

NS_ASSUME_NONNULL_END
