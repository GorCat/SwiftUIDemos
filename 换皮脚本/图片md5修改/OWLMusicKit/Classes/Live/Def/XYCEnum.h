//
//  XYCEnum.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#ifndef XYCEnum_h
#define XYCEnum_h

#pragma mark - 外部使用
/// 文本信息类型
typedef NS_ENUM(NSInteger, XYLOutDataSourceTextInfoType) {
    // ----- 用户信息 -----
    XYLOutDataSourceTextInfoType_Nickname = 0,
    XYLOutDataSourceTextInfoType_DisplayAccountID,
    XYLOutDataSourceTextInfoType_Gender,
    XYLOutDataSourceTextInfoType_Avatar,
    XYLOutDataSourceTextInfoType_Session,
    
    // ----- 配置信息 -----
    /// 弹幕标签地址 globalParam.defaultEventLabel.imageUrl
    XYLOutDataSourceTextInfoType_TagUrl,
    /// 弹幕标签标题 globalParam.defaultEventLabel.title
    XYLOutDataSourceTextInfoType_TagTitle,
    /// pk进度条URL globalParam.videoChatRoomConfig.pkScoreFlagUrl
    XYLOutDataSourceTextInfoType_PKFlagUrl,
    /// 当前语言[目前只能传两个值 en/ar 传别的也行 但没用]
    XYLOutDataSourceTextInfoType_CurrentLanguage,
};

/// 数字信息类型
typedef NS_ENUM(NSInteger, XYLOutDataSourceNumInfoType) {
    // ----- 用户信息 -----
    XYLOutDataSourceNumInfoType_AccountID = 0,
    XYLOutDataSourceNumInfoType_Coins,
    
    // ----- 配置信息 -----
    /// 弹幕标签高度  globalParam.defaultEventLabel.imageHeight
    XYLOutDataSourceNumInfoType_TagHeight,
    /// 弹幕标签宽度  globalParam.defaultEventLabel.imageWidth
    XYLOutDataSourceNumInfoType_TagWidth,
    /// 弹幕标签剩余时长 globalParam.defaultEventLabel.expirationTime
    XYLOutDataSourceNumInfoType_TagExpirationTime,
    /// 1金币实验转盘弹出时间配置 (是实验组：appconfig中的turntablePromptTime。不是实验组：0)
    XYLOutDataSourceNumInfoType_TurntablePromptTime,
};

/// 浮点信息类型
typedef NS_ENUM(NSInteger, XYLOutDataSourceFloatInfoType) {
    /// 用户充值总额（必须为浮点数）
    XYLOutDataSourceFloatInfoType_RechargeAmount = 0,
};

/// 数组信息类型（自行转成字典数组。数组里是一个个字典奥！！然后sdk内部再解析成数组）
typedef NS_ENUM(NSInteger, XYLOutDataSourceArrayInfoType) {
    /// 支付信息 globalParam.payConfigs（内部显示充值优惠弹窗使用）
    XYLOutDataSourceArrayInfoType_PayConfigs = 0,
};

/// 字典信息类型
typedef NS_ENUM(NSInteger, XYLOutDataSourceDicInfoType) {
    // ----- 用户信息 -----
    /// 直播间banner列表  globalParam.videoChatRoomConfig.videoChatRoomBannerInfoList
    XYLOutDataSourceDicInfoType_BannerList = 0,
    /// 直播间礼物列表 globalParam.videoChatRoomConfig.videoChatRoomGiftConfigs
    XYLOutDataSourceDicInfoType_GiftList,
    /// 用户整个信息 一整个account模型（传的时候把非服务端返回的字段最好删了，就那些本地自己加的属性。这个是要字典转json发给主播端那边的）
    XYLOutDataSourceDicInfoType_AccountInfo,
    /// 当前游戏信息（传语聊房的）
    XYLOutDataSourceDicInfoType_CurrentGameInfo,
};

/// 布尔类型信息
typedef NS_ENUM(NSInteger, XYLOutDataSourceBoolInfoType) {
    /// 是否开启在直播间开启私聊功能（都传yes 等做到绿号相关功能问各自组长怎么传）
    XYLOutDataSourceBoolInfoType_isOpenPrivateChat = 0,
    /// 是否已经显示引导弹窗（和语聊房通用）
    XYLOutDataSourceBoolInfoType_hasShowGuideState,
    /// 是否是绿色账号（默认传NO 等做到绿号相关功能问各自组长怎么传）
    XYLOutDataSourceBoolInfoType_isGreenAccount,
    /// 当前语言是否为阿语
    XYLOutDataSourceBoolInfoType_isRTL,
    /// 是否仅包含主包（有🐴＋的包传NO 没🐴+的包传YES）
    XYLOutDataSourceBoolInfoType_isJustMain,
    /// 是否是svip
    XYLOutDataSourceBoolInfoType_isSVIP,
    /// 是否有特权（房间内部消息使用。当用户的privileges 包含4【进场动效】就是有特权 [user.privileges containsObject:@(4)]）
    XYLOutDataSourceBoolInfoType_isPrivilege,
    /// 是否关闭广播（和语聊房通用。默认为NO：不关闭广播。YES：关闭广播）
    XYLOutDataSourceBoolInfoType_isCloseBroadcast,
    /// 是否开启转盘 globalParam.videoChatRoomConfig.isTurntableFeatureOn
    XYLOutDataSourceBoolInfoType_isOpenTurntable,
    /// 是否开启铁粉测试（询问组长自己的包是否开启铁粉测试。有铁粉功能的包：根据服务端返回的来，无铁粉功能：传NO）
    XYLOutDataSourceBoolInfoType_isOpenFanClub,
    /// 是否显示过铁粉引导 (有铁粉功能的 正常传值。无铁粉功能的直接传NO)
    XYLOutDataSourceBoolInfoType_isShowFanGuide,
    /// 是否展示进场特效。问各自组长是否需要展示。不展示：传NO。要展示传：effectConfig.open（getconfig接口 解密之后）
    XYLOutDataSourceBoolInfoType_isShowEntryEffect,
    /// 是否使用主包svg文件。YES：用主包传进来的路径播放svg; NO:sdk内部用url播放
    XYLOutDataSourceBoolInfoType_isUseMainSVGPath,
    /// 是否存在画中画功能（需要画中画的包：传服务端配置的值。不需要的包：传NO）
    XYLOutDataSourceBoolInfoType_hasPIPFunction,
    /// 是否开启应用内悬浮窗功能（和语聊房、主包通用。默认为YES开启悬浮窗，NO关闭悬浮窗）
    XYLOutDataSourceBoolInfoType_isOpenWindowInApp,
    /// 是否开启应用外画中画功能（和语聊房、主包通用。默认为YES开启画中画，NO:关闭画中画）
    XYLOutDataSourceBoolInfoType_isOpenWindowOutApp,
    /// 是否开启一金币转盘测试功能（有测试功能：传服务端的值。无此功能：传NO）1.6.0
    XYLOutDataSourceBoolInfoType_hasOneCoinTest,
    /// 本次进程中是否在语聊房/直播间弹过一金币转盘（为本次进程的值，存单例里面就行，别存本地）1.6.0
    XYLOutDataSourceBoolInfoType_hasAutoShowOneCoin,
    /// 是否已经成功转过一金币转盘 1.6.0
    XYLOutDataSourceBoolInfoType_hasOpenOneCoinSuccess,
};

/// 弹窗显示类型
typedef NS_ENUM(NSInteger, XYLOutDataSourceTopAlertType) {
    // ----- 用户信息 -----
    /// 通知类型
    XYLOutDataSourceTopAlertType_Notification = 0,
    /// 成功
    XYLOutDataSourceTopAlertType_Success,
    /// 失败
    XYLOutDataSourceTopAlertType_Fail,
};

/// 网络类型（目前先按照这个区分，以后或许可能会新增类型）
typedef NS_ENUM(NSInteger, XYLOutDataSourceNetworkStateType) {
    // ----- 用户信息 -----
    /// 无网络
    XYLOutDataSourceNetworkStateType_NoConnection = 0,
    /// 有网
    XYLOutDataSourceNetworkStateType_HaveNetwork,
};

/// 数数埋点类型
typedef NS_ENUM(NSUInteger, XYLOutDataSourceThinkingEventType) {
    /// 事件
    XYLOutDataSourceThinkingEventType_Event,
    /// 时间
    XYLOutDataSourceThinkingEventType_Time,
};

/// firebase埋点类型（搜索Firebase精细化打点表格）
typedef NS_ENUM(NSUInteger, XYLOutDataSourceFirebaseEventType) {
    /// 用户支出虚拟货币 事件：kFIREventSpendVirtualCurrency  携带参数：way - @"消耗方式" ; value - @(消耗金币数量)
    XYLOutDataSourceFirebaseEventType_SpendCurrency,
};

/// 进入类型
typedef NS_ENUM(NSUInteger, XYLOutDataSourceEnterRoomType) {
    /// 未知类型（如果不是以下的类型 就传Unknown，内部就不做埋点）
    XYLOutDataSourceEnterRoomType_Unknown,
    /// 首页
    XYLOutDataSourceEnterRoomType_HomeList,
    /// 滑动房间（外部不用）
    XYLOutDataSourceEnterRoomType_Scroll,
    /// 资料页
    XYLOutDataSourceEnterRoomType_Detail,
    /// 头像
    XYLOutDataSourceEnterRoomType_Avatar,
    /// 礼物广播
    XYLOutDataSourceEnterRoomType_Broadcast,
};

/// App需要用到的权限枚举
typedef NS_ENUM(NSUInteger, XYLSystemAuthType) {
    XYLSystemAuthTypePhotoLibrary,      //相册
    XYLSystemAuthTypeCamera,            //相机
    XYLSystemAuthTypeAudio,             //麦克风
};

/// 需要改变的bool类型
typedef NS_ENUM(NSUInteger, XYLNeedChangeBoolInfoType) {
    /// 是否关闭广播（YES: 关闭广播 NO: 开启广播）
    XYLNeedChangeBoolInfoType_isCloseBroadcast,
    /// 是否显示过滑动引导（直接赋值YES就行）
    XYLNeedChangeBoolInfoType_hasShowGuideState,
    /// 是否显示过铁粉引导（和语聊房状态通用 直接赋值YES就行）⚠️ XYLOutDataSourceBoolInfoType_isOpenFanClub = yes的包的才处理！
    XYLNeedChangeBoolInfoType_hasShowFanGuide,
    /// 是否开启应用内悬浮窗（YES：开启 NO：关闭）
    XYLNeedChangeBoolInfoType_isOpenWindowInApp,
    /// 是否开启应用外画中画（YES：开启 NO：关闭）
    XYLNeedChangeBoolInfoType_isOpenWindowOutApp,
    /// 本次进程中是否在语聊房/直播间弹过一金币转盘 （有一金币转盘的包才处理。和语聊房状态通用 把XYLOutDataSourceBoolInfoType_hasAutoShowOneCoin对应的值改为yes。）
    XYLNeedChangeBoolInfoType_hasAutoShowOneCoin,
};

/// 支付类型
typedef NS_ENUM(NSUInteger, XYLOutDataSourcePayType) {
    /// 内购买金币
    XYLOutDataSourcePayType_PGCoins,
    /// 内购买铁粉
    XYLOutDataSourcePayType_PGFan
};

/// 性别类型（据说以后有中性 或者 保密啥的，所以这边用枚举值）
typedef NS_ENUM(NSUInteger, XYLOutDataSourceGenderType) {
    /// 女性
    XYLOutDataSourceGenderType_Female,
    /// 男性
    XYLOutDataSourceGenderType_Male,
};

#pragma mark - 内部使用
#pragma mark 服务端返回的数据
/// 房间类型
typedef NS_ENUM(NSInteger, XYLModuleRoomStateType) {
    /// 未开播
    XYLModuleRoomStateType_NoStart          = 1,
    /// 直播中
    XYLModuleRoomStateType_Living           = 2,
    /// 主持人私聊挂起
    XYLModuleRoomStateType_PrivateChat      = 3,
    /// 结束
    XYLModuleRoomStateType_Finish           = 4,
    /// PK匹配中
    XYLModuleRoomStateType_PKMatching       = 5,
    /// PK中
    XYLModuleRoomStateType_PKing            = 6,
    /// PK下一场等待中
    XYLModuleRoomStateType_WaitNextPKing    = 7,
    /// PK惩罚中
    XYLModuleRoomStateType_PKPunishing      = 8,
    /// 挂起
    XYLModuleRoomStateType_Waiting          = 9,
};

/// 房间成员类型
typedef NS_ENUM(NSInteger, XYLModuleMemberType) {
    /// 用户
    XYLModuleMemberType_User    = 1,
    /// 主播
    XYLModuleMemberType_Anchor  = 2
};

/// 拉黑状态
typedef NS_ENUM(NSInteger, XYLModuleBlackListStatusType) {
    /// 不在黑名单
    XYLModuleBlackListStatusType_NoBlock        = 1,
    /// 对方在自己的黑名单
    XYLModuleBlackListStatusType_BlockOther     = 2,
    /// 自己在对方的黑名单
    XYLModuleBlackListStatusType_OtherBlockMe   = 3,
    /// 相互拉黑
    XYLModuleBlackListStatusType_BlockEachOther = 4,
};

/// 房间私聊开关
typedef NS_ENUM(NSInteger, XYLModulePrivateChatStatusType) {
    /// 开启
    XYLModulePrivateChatStatusType_Open     = 1,
    /// 关闭
    XYLModulePrivateChatStatusType_Close    = 2,
};

/// 房间销毁原因
typedef NS_ENUM(NSInteger, XYLModuleDestoryReasonType) {
    // ----- 用户信息 -----
    /// 正常关闭
    XYLModuleDestoryReasonType_NormalClose  = 1,
    /// 被举报
    XYLModuleDestoryReasonType_ReportRoom   = 2,
};

#pragma mark 本地自定义的数据
typedef NS_ENUM(NSInteger, XYLModuleEventType) {
    /// 清除所有数据
    XYLModuleEventType_ClearAllData         = 1,
    /// 加入房间
    XYLModuleEventType_JoinRoom,
    /// PK匹配成功
    XYLModuleEventType_PKMatchSuccess,
    /// PK倒计时结束
    XYLModuleEventType_PKTimeEnd,
    /// 更新私聊按钮状态
    XYLModuleEventType_UpdatePrivateChat,
    /// 目标更新
    XYLModuleEventType_UpdateGoal,
    /// 更新标签
    XYLModuleEventType_UpdateUserMedal,
    /// 更新优惠按钮
    XYLModuleEventType_UpdateDiscountButton,
    /// 更新转盘信息
    XYLModuleEventType_UpdateRandomTable,
    /// 更新转盘显示隐藏
    XYLModuleEventType_UpdateRandomTableIsShow,
    /// 显示进场动画
    XYLModuleEventType_ShowEnterPagEffect,
    /// 更新底部充值按钮
    XYLModuleEventType_UpdateBottomRechargeButton,
    /// 更新轮播信息按钮
    XYLModuleEventType_UpdateCycleInfoView,
};

/// 单人视频大小类型
typedef NS_ENUM(NSInteger, XYLModuleSingleVideoSizeType) {
    /// 全屏单人
    XYLModuleSingleVideoSizeType_FullSingle = 1,
    /// 全屏PK
    XYLModuleSingleVideoSizeType_FullPK     = 2,
    /// 小窗状态
    XYLModuleSingleVideoSizeType_FloatState = 3
};

/// 单人视频主播类型
typedef NS_ENUM(NSInteger, XYLModuleSingleVideoAnchorType) {
    /// 己方主播
    XYLModuleSingleVideoAnchorType_Mine     = 1,
    /// 对面主播
    XYLModuleSingleVideoAnchorType_Other    = 2,
};

/// 轮播信息
typedef NS_ENUM(NSInteger, XYLModuleCycleInfoType) {
    /// 充值优惠
    XYLModuleCycleInfoType_PayDiscount     = 1,
    /// 1金币转盘
    XYLModuleCycleInfoType_OneCoinTest,
};

#endif /* XYCEnum_h */
