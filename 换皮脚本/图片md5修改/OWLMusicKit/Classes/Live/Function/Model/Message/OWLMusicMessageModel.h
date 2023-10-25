//
//  OWLMusicMessageModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#import "OWLBGMModuleBaseModel.h"
@class OWLMusicMessageModel, OWLMusicRoomDetailModel, OWLMusicGiftInfoModel, OWLMusicEnterPrivateChatModel;

/// Live直播间弹幕类型
typedef NS_ENUM(NSUInteger, OWLMusicMessageType) {
    /// 系统提示
    OWLMusicMessageType_SystemTip         = 1,
    /// 加入直播间
    OWLMusicMessageType_JoinRoom          = 2,
    /// 文本消息
    OWLMusicMessageType_TextMessage       = 3,
    /// 礼物
    OWLMusicMessageType_SendGift          = 4,
    /// 被禁言
    OWLMusicMessageType_MuteUser          = 5,
    /// 被取消禁言
    OWLMusicMessageType_CancelMuteUser    = 6,
    /// 刷新房间信息
    OWLMusicMessageType_UpdateRoomInfo    = 7,
    /// 用户带走主播
    OWLMusicMessageType_UserTakeAnchor    = 8,
    /// PK匹配成功
    OWLMusicMessageType_MatchPKSuccess    = 9,
    /// PK结束
    OWLMusicMessageType_FinishPK          = 10,
    /// PK分数更新
    OWLMusicMessageType_UpdatePKGoals     = 11,
    /// PK时间到 携带pkwinner
    OWLMusicMessageType_PKTimeUp          = 12,
    /// PK再来一次
    OWLMusicMessageType_PKAgain           = 13,
    /// PK逃跑(对方逃跑)
    OWLMusicMessageType_PKRunAway         = 14,
    /// 私聊按钮开关
    OWLMusicMessageType_PrivateOpenState  = 15,
    /// 刷新观众列表
    OWLMusicMessageType_UpdateMemberList  = 16,
    /// 通知对面视频开关
    OWLMusicMessageType_OppsiteVideo      = 17,
    /// 通知更新转盘信息以及转盘结果
    OWLMusicMessageType_TurntableInfo     = 18,
    /// 禁言列表
    OWLMusicMessageType_MutedMembersInfo  = 19,
};

/// live直播间用户类型
typedef NS_ENUM(NSUInteger, OWLMusicMessageUserType) {
    /// 主播
    OWLMusicMessageUserType_Anchor        = 0,
    /// 用户
    OWLMusicMessageUserType_User          = 1,
};

/// 系统提示文案样式
typedef NS_ENUM(NSUInteger, OWLMusicMessageSystemType) {
    OWLMusicMessageSystemType_Hint = 0,
    OWLMusicMessageSystemType_PkEnd = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicMessageModel : OWLBGMModuleBaseModel

/// 0：hint；1：pkEnd
@property (nonatomic, assign) OWLMusicMessageSystemType dsb_systemType;
/// 弹幕类型
@property (nonatomic, assign) OWLMusicMessageType dsb_msgType;
/// 用户类型
@property (nonatomic, assign) OWLMusicMessageUserType dsb_userType;
/// 是否VIP
@property (nonatomic, assign) BOOL dsb_isVipUser;
/// 是否SVIP
@property (nonatomic, assign) BOOL dsb_isSVipUser;
/// 特权
@property (nonatomic, assign) BOOL dsb_isPrivilegeUser;
/// 用户ID（AccountId）
@property (nonatomic, assign) NSInteger dsb_accountID;
/// 昵称
@property (nonatomic, copy) NSString *dsb_nickname;
/// 头像
@property (nonatomic, copy) NSString *dsb_avatar;
/// 内容（jsonString）
@property (nonatomic, copy) NSString *dsb_text;
/// 礼物ID
@property (nonatomic, assign) NSInteger dsb_giftID;
/// combo数
@property (nonatomic, assign) NSInteger dsb_giftCombo;
/// 是否是盲盒
@property (nonatomic, assign) NSInteger dsb_isblindGift;
/// 弹幕标签地址
@property (nonatomic, copy) NSString *dsb_tagUrl;
/// 标签高
@property (nonatomic, assign) CGFloat dsb_tagHeight;
/// 标签宽
@property (nonatomic, assign) CGFloat dsb_tagWidth;

#pragma mark - 方法
/// 是否需要显示到消息列表上
- (BOOL)xyf_isShowInMessageList;

#pragma mark - 初始化
/// 1.系统提示消息
+ (OWLMusicMessageModel *)xyf_getSystemTipMsg;

/// 1.1PK结束消息
+ (OWLMusicMessageModel *)xyf_pkEndTipMsg;

/// 2.加入直播间消息
+ (OWLMusicMessageModel *)xyf_getJoinRoomMsg;

/// 3.文本消息
+ (OWLMusicMessageModel *)xyf_getTextMessage:(NSString *)text;

/// 4.礼物消息
+ (OWLMusicMessageModel *)xyf_getSendGiftMsg:(OWLMusicGiftInfoModel *)gift giftNum:(NSInteger)giftNum;

/// 7.房间消息
+ (OWLMusicMessageModel *)xyf_getUpdateInfoMsg:(OWLMusicRoomDetailModel *)room;

/// 8.带走消息
+ (OWLMusicMessageModel *)xyf_getTakeAnchorMsg:(OWLMusicGiftInfoModel *)gift
                                privateVideoDict:(NSDictionary *)privateVideoDict;

/// 16.刷新观众列表
+ (OWLMusicMessageModel *)xyf_getUpdateMemberListMsg:(NSArray *)memberList;

/// 19.禁言列表
+ (OWLMusicMessageModel *)xyf_getMutedMembersInfoMsg:(NSArray *)muteList;

@end

NS_ASSUME_NONNULL_END
