//
//  OWLMusicRoomPKPlayerModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/21.
//

/**
 * @功能描述：直播间房间详情模型 - PK数据 - 玩家数据
 * @创建时间：2023.2.21
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomPKPlayerModel : OWLBGMModuleBaseModel

/// 直播房间Id
@property (nonatomic, assign) NSInteger dsb_roomID;
/// 直播间房间封面 
@property (nonatomic, strong) NSString *dsb_cover;
/// 房间状态（1：未开播 2：直播中 3：主持人私聊挂起 4：结束 5：PK匹配中 6：PK中 7：PK下一场等待中 8：惩罚中）
@property (nonatomic, assign) XYLModuleRoomStateType dsb_roomStatus;
/// 声网房间号
@property (nonatomic, strong) NSString *dsb_rtcRoomID;
/// 账号ID
@property (nonatomic, assign) NSInteger dsb_accountID;
/// 昵称
@property (nonatomic, strong) NSString *dsb_nickname;
/// 头像
@property (nonatomic, strong) NSString *dsb_avatar;
/// 连胜次数
@property (nonatomic, assign) NSInteger dsb_wins;

@end

NS_ASSUME_NONNULL_END
