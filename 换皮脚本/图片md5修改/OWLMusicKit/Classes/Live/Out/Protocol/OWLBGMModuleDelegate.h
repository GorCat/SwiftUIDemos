//
//  OWLBGMModuleDelegate.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间代理
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 携带用户信息的事件类型
typedef NS_ENUM(NSInteger, OWLMusicEventWithUserInfoType) {
    /// 进入私聊
    OWLMusicEventWithUserInfoType_EnterTextChat   = 0,
    /// 进入个人详情
    OWLMusicEventWithUserInfoType_EnterDetailInfo = 1,
    
};

@protocol OWLBGMModuleDelegate <NSObject>


/// 携带用户信息的事件类型（挑了一些基本的信息 传出来给外面跳页面的时候用。如果为空的话 不会传nil出去 会传空字符串。）
/// - Parameters:
///   - type: 事件类型
///   - accountID: 账号ID
///   - nickname: 昵称
///   - avatar: 头像
///   - displayID: 展示ID
///   - isAnchor: 是否是主播号
- (void)xyf_outsideModuleEventWithUserInfoType:(OWLMusicEventWithUserInfoType)type
                                     accountID:(NSInteger)accountID
                                      nickname:(NSString *)nickname
                                        avatar:(NSString *)avatar
                                     displayID:(NSString *)displayID
                                      isAnchor:(BOOL)isAnchor;


/// 请求接口
/// 1.接口请求需要用到大家统一处理错误码的逻辑（比如session过期 比如挤号之类的逻辑，这些逻辑是需要保留的）
/// 2.在请求接口底层的成功/错误的顶部提示弹窗逻辑 及 loading逻辑需要去掉
/// - Parameters:
///   - requestModel: 请求的模型参数
///   - completionHandler: 请求回调
- (void)xyf_liveModuleRequstApi:(OWLMusicRequestApiModel *)requestModel completionHandler:(nullable void (^)(NSDictionary * _Nullable responseDic,  NSError * _Nullable error))completionHandler;


/// 关注/取关主播（外部不需要判断是否在直播间中，直接调用就行了。）
/// - Parameters:
///   - anchorID: 主播ID
///   - isFollow: 是否是关注
///   - completion: 完成回调 followState 最终关注状态
/// 累了。每次都要解释为什么要单独开一个关注/取关主播。
/// 因为！！！在直播间外面关注/取关主播，直播间也是需要同步刷新UI的！！！ 所以最好外面写一个统一的方法，然后调直播间方法xyf_followAnchor更新。如果外面打算在十几个关注的地方调方法更新，那我道歉，确实没考虑过这种情况。
/*
 接口调成功 或者 接口掉失败但是错误码为-53：followState = isFollow（传给你们的isFollow状态 说明状态改成功了）
 其余情况 followState = !isFollow(传给你们的isFollow状态取反 说明没改成功）
 */
- (void)xyf_userFollowAnchor:(NSInteger)anchorID isFollow:(BOOL)isFollow completion:(void(^)(BOOL followState))completion;

/// 拉黑/取消拉黑主播（外部需要封装一个拉黑方法！！！类似于关注、取关那样）
/// - Parameters:
///   - anchorID: 主播ID
///   - isBlock: 是否是拉黑
///   - completion: 完成回调（不管成功失败都要回调）
- (void)xyf_userBlockAnchor:(NSInteger)anchorID isBlock:(BOOL)isBlock completion:(void(^)(void))completion;

/// 弹充值弹窗（购买啊 埋点的逻辑 都在外面各自的主包中实现，这边只负责弹弹窗）
/// - Parameter superView: 弹窗的父视图
- (void)xyf_outsideModuleShowRechargeView:(UIView *)superView;


/// 显示/消失loading（中间的那种loading）
- (void)xyf_outsideModuleLoading:(BOOL)isShow;


/// 显示顶部弹窗(内部已经放在主线程回调给你们的 放心食用(*^▽^*))
- (void)xyf_outsideModuleShowTopAlert:(XYLOutDataSourceTopAlertType)type text:(NSString *)text;


/// 更新用户剩余金币
- (void)xyf_outsideModuleUpdateUserLeftCoin:(NSInteger)leftCoin;


/// 更新用户标签
- (void)xyf_outsideModuleUpdateUserMedal:(OWLMusicEventLabelModel *)medalModel;


/// 刷新首页live模块列表（产品需求：刷新的时候需要直接回到顶部）
- (void)xyf_outsideModuleReloadHomeList;


/// 进入充值页面
- (void)xyf_outsideModuleEnterRechargeVC;


/// 进入视频私聊页面（传给你们的是进入私聊的字典，用进入视频私聊房间的模型去解析。参考文档“app操作推送码” 操作码2 子操作码8。也可以搜索一下“initialPrice”）
/// 📢注意：直播间 & 私聊：840*480  24fps。直播间内部会改分辨率和帧数，虽然私聊和直播间是一样的参数，但是语聊房的参数不一样，外面的包在进入私聊模块的时候要注意设置。
/// 📢特别注意：！！进私聊的时候 需要把rtc的代理抢回去
- (void)xyf_outsideModuleEnterPrivateVideoChat:(NSDictionary *)dic;


/// 上传图片（错误提示 成功提示 都要在你们的方法中实现）
/// - Parameters:
///   - image: 图片对象
///   - isNeedJH: 是否需要鉴黄 yes：需要鉴黄 no：不需要鉴黄
///   - completion: 完成回调 （不管成功失败都要给回调哈 内部需要消loading）
- (void)xyf_outsideModuleUploadImage:(UIImage *)image isNeedJH:(BOOL)isNeedJH completion:(void(^)(BOOL success, NSString *photoUrl))completion;


/// 敏感词处理（需要返回处理之后的文案）敏感词的获取：config接口 -> 解密 -> filterWordsUrl -> 对应的json地址 -> 拿敏感词 -> 存本地。
/// - Parameter text: 需要被处理的原文案 如果外面的包不需要做敏感词判断的话 就return text
/// 以后主包都会要有敏感词替换的需求，各自的主包总是要封一个方法的，所以给你们传需要处理的文案，替换好了之后再传过来。别再问为什么直播间内部不处理了 = =
- (NSString *)xyf_outsideModuleFilterWord:(NSString *)text;


/// 显示禁止录屏的弹窗  （需要外部监听录屏通知 自行dismiss）
- (void)xyf_outsideModuleShowNoScreenView;


/// 提醒充值Svip（跳转SVIP之前 需要先调直播间最小化方法）
- (void)xyf_outsideModuleRemindRechargeSVIP;


/// 内购充值（外部直接调pg的内购方法。埋点等逻辑也在外面处理）
/// - Parameters:
///   - model: 内购产品模型
///   - configModel: 内购总模型
///   - otherInfo: 其他信息
///   - completion: 完成回调。不管成功失败都要给回调。小票接口调成功才算成功
- (void)xyf_outsideModulePay:(OWLMusicProductModel *)model
                 configModel:(OWLMusicPayModel *)configModel
                   otherInfo:(OWLMusicPayOtherInfoModel *)otherInfo
                  completion:(void(^)(BOOL success))completion;


/// 进入语聊房
/// - Parameter roomID: 房间ID
- (void)xyf_outsideModuleJoinChatRoom:(NSInteger)roomID;


/// 更改本地布尔值状态
/// - Parameters:
///   - state: bool值状态
///   - type: 更改类型
- (void)xyf_outsideModuleChangeLocalBoolState:(BOOL)state type:(XYLNeedChangeBoolInfoType)type;

/// 需要主包更新金币（主包调接口刷新金币 然后再通知直播间）1.5新增
- (void)xyf_needUpdateUserCoins;

@optional
/// 数数统计
/// - Parameters:
///   - type: 类型
///   - eventName: 事件名称
///   - dic: 信息（直接一整个丢进去）
- (void)xyf_outsideModuleThinkingType:(XYLOutDataSourceThinkingEventType)type eventName:(NSString *)eventName dic:(NSDictionary * __nullable)dic;


/// Firebase统计
/// - Parameters:
///   - type: 类型
///   - dic: 信息（需要重新拼装信息，具体看枚举的注释）
- (void)xyf_outsideModuleFirebaseType:(XYLOutDataSourceFirebaseEventType)type dic:(NSDictionary * __nullable)dic;


- (void)xyf_outsideModuleViewWillAppear;

- (void)xyf_outsideModuleViewWillDisappear;

/// 直播间销毁
- (void)xyf_outsideModuleDestroy;

/// 关闭游戏的方法(语聊房SDK的方法) 1.5新增
- (void)xyf_outsideModuleChatRoomCloseGame;

/// 打开游戏的方法(语聊房SDK的方法) 1.5新增
- (void)xyf_outsideModuleChatRoomShowGame;

/// 点击游戏悬浮球埋点：由主包判断是在什么模块 参考数数统计表格 1.5新增
/// 事件名：game_ball_click
/// 参数：from(点击位置) - live，multibeam，private，other   gameid(游戏id) - 传给你们的游戏id
- (void)xyf_outsideModuleTongjiGameBallClick:(NSInteger)gameId;

/// 打开1金币转盘弹窗（需要外面埋点 抽奖弹窗曝光one_coin_page_view） 1.6.0
- (void)xyf_outsideModuleOpenOneCoinTurntable;

@end

NS_ASSUME_NONNULL_END
