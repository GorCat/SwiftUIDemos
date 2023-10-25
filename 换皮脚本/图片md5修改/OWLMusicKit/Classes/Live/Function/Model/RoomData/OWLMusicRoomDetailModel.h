//
//  OWLMusicRoomDetailModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLBGMModuleBaseModel.h"
#import "OWLMusicMessageModel.h"
#import "OWLMusicRoomGoalModel.h"
#import "OWLMusicRoomPKDataModel.h"
#import "OWLMusicMemberModel.h"
#import "OWLMusicGiftConfigModel.h"
#import "OWLMusicFanInfoModel.h"
#import "OWLMusicGameInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomDetailModel : OWLBGMModuleBaseModel

/// 房间号
@property (nonatomic, assign) NSInteger dsb_roomID;
/// 房间标题
@property (nonatomic, copy) NSString *dsb_title;
/// 房间封面
@property (nonatomic, copy) NSString *dsb_cover;
/// 房间类型
@property (nonatomic, assign) NSInteger dsb_roomType;
/// 声网房间号
@property (nonatomic, copy) NSString *dsb_rtcRoomID;
/// 主持人Id
@property (nonatomic, assign) NSInteger dsb_ownerAccountID;
/// 主持人展示Id
@property (nonatomic, copy) NSString *dsb_ownerDisplayAccountID;
/// 主持人名字
@property (nonatomic, copy) NSString *dsb_ownerNickname;
/// 主持人头像
@property (nonatomic, copy) NSString *dsb_ownerAvatar;
/// 主持人心情
@property (nonatomic, copy) NSString *dsb_ownerMood;
/// 主持人麦克风状态（1：正常，2：关麦）
@property (nonatomic, assign) NSInteger dsb_micState;
/// 主持人开始的粉丝数
@property (nonatomic, assign) NSInteger dsb_ownerFansStart;
/// 主持人结束的粉丝数
@property (nonatomic, assign) NSInteger dsb_ownerFansEnd;
/// 主持人收到的礼物数
@property (nonatomic, assign) NSInteger dsb_ownerReceiveGift;
/// 主持人金币收入
@property (nonatomic, assign) NSInteger dsb_ownerIncome;
/// 当前人数
@property (nonatomic, assign) NSInteger dsb_currentPeopleNum;
/// 最大人数
@property (nonatomic, assign) NSInteger dsb_maxPeopleNum;
/// 私聊次数
@property (nonatomic, assign) NSInteger dsb_privateChatNum;
/// 私聊开关（1：开启，2：关闭）
@property (nonatomic, assign) XYLModulePrivateChatStatusType dsb_privateChatState;
/// 私聊礼物Id
@property (nonatomic, assign) NSInteger dsb_privateChatGiftID;
/// 是否关注主播
@property (nonatomic, assign) BOOL dsb_isFollowedOwner;
/// 直播已开始秒数
@property (nonatomic, assign) NSInteger dsb_roomDuration;
/// 房间状态（1：未开播，2：直播中，3：主持人私聊挂起，4：结束，5：PK匹配中，6：PK中，7：PK下一场等待中，8：PK惩罚中，9：挂起）
@property (nonatomic, assign) XYLModuleRoomStateType dsb_roomState;
/// 房间成员列表
@property (nonatomic, strong) NSArray <OWLMusicMemberModel *> *dsb_memberList;
/// UGC房间成员列表
@property (nonatomic, strong) NSArray <OWLMusicMemberModel *> *dsb_ugcMemberList;
/// pk邀请开关（1：开启，2：关闭）
@property (nonatomic, assign) NSInteger dsb_pkInviteState;
/// PK数据
@property (nonatomic, strong) OWLMusicRoomPKDataModel *__nullable dsb_pkData;
/// 房间目标
@property (nonatomic, strong) OWLMusicRoomGoalModel *dsb_roomGoal;
/// 礼物配置
@property (nonatomic, strong) NSArray <OWLMusicGiftConfigModel *> *dsb_giftList;
/// 是否是UGC房间
@property (nonatomic, assign) BOOL dsb_isUGCRoom;
/// 转盘开关（1：开启，2：关闭）
@property (nonatomic, assign) NSInteger dsb_circlePanState;
/// 转盘条目
@property (nonatomic, strong) NSArray <NSString *> *dsb_circlePanItems;
/// 转盘标题
@property (nonatomic, copy) NSString *dsb_circlePanTitle;
/// 主持人呼叫价格
@property (nonatomic, assign) NSInteger dsb_ownerCallPrice;
/// 最近弹幕列表
@property (nonatomic, strong) NSArray <OWLMusicMessageModel *> *dsb_lastMessages;
/// 快捷礼物
@property (nonatomic, strong) OWLMusicGiftInfoModel *dsb_quickGift;
/// 铁粉信息
@property (nonatomic, strong) OWLMusicFanInfoModel *dsb_fanInfo;
/// 游戏信息
@property (nonatomic, strong) OWLMusicGameInfoModel *dsb_gameConfig;

/// 是否是PK状态
- (BOOL)xyf_isPKState;

/// 是否是活跃状态
- (BOOL)xyf_beActive;

/// 是否开启私聊
- (BOOL)xyf_isOpenPrivate;

@end

NS_ASSUME_NONNULL_END
