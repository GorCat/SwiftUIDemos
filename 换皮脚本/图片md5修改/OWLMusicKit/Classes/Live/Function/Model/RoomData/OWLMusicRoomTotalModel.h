//
//  OWLMusicRoomTotalModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

/**
 * @功能描述：直播间房间模型 - 总模型
 * @创建时间：2023.2.17
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"
#import "OWLMusicRoomTempModel.h"
#import "OWLMusicRoomDetailModel.h"
@class OWLMusicBroadcastModel;

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomTotalModel : OWLBGMModuleBaseModel

#pragma mark - Setter
/// 房间的基本信息：留用快速预览及供加入房间
@property (nonatomic, strong) OWLMusicRoomTempModel *xyp_tempModel;
/// 完整房间数据
@property (nonatomic, strong) OWLMusicRoomDetailModel * _Nullable xyp_detailModel;
/// 在数组中的下标（注：此下标不维护！不要在其他地方使用，仅用于遍历时，赋值该模型在对应列表的哪个位置，返回值的时候使用！！！！）
@property (nonatomic, assign) NSInteger xyp_indexInList;
/// 是否加入房间异常（仅对当前房间有效 划走之后状态会重置）
@property (nonatomic, assign) BOOL xyp_isUnnormalJoin;

#pragma mark - Getter
/// 是否是UGC房间
@property (nonatomic, assign) BOOL xyp_isUGCRoom;

/// 根据房间详情模型创建一个房间模型
+ (OWLMusicRoomTotalModel *)xyf_configModelWithDetail:(OWLMusicRoomDetailModel *)detailModel;

/// 根据pk模型生成一个房间模型（在跳转到对方页面时使用）
+ (OWLMusicRoomTotalModel *)xyf_configModelWithPkPlayerModel:(OWLMusicRoomPKPlayerModel *)pkModel;

/// 根据广播模型生成一个房间模型（在跳转到对方页面时使用）
+ (OWLMusicRoomTotalModel *)xyf_configModelWithBroadcastModel:(OWLMusicBroadcastModel *)broadcastModel;

/// 更新房间ID
- (void)xyf_updateRoomID:(NSInteger)roomID;

/// 更新封面
- (void)xyf_updateCover:(NSString *)cover;

/// 获取房主ID
- (NSInteger)xyf_getOwnerID;

/// 房间ID
- (NSInteger)xyf_getRoomID;

/// 声网ID
- (NSString *)xyf_getRTCRoomID;

@end

NS_ASSUME_NONNULL_END
