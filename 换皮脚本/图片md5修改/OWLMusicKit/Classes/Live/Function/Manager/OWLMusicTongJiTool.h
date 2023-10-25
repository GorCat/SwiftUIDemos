//
//  OWLMusicTongJiTool.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicTongJiTool : NSObject

#pragma mark - Thinking
/// 不带额外参数的埋点事件
+ (void)xyf_thinkingWithName:(NSString *)eventName;

/// 带from的埋点事件
+ (void)xyf_thinkingFromWithName:(NSString *)eventName;

/// 时间事件埋点
+ (void)xyf_thinkingWithTimeEventName:(NSString *)eventName;

/// 点击小窗关闭房间
+ (void)xyf_thinkingMiniCloseRoom;

/// 点击小窗回到房间
+ (void)xyf_thinkingMiniReturnRoom;

/// 带走通话事件
+ (void)xyf_thinkingStartCall;

/// 送礼点击事件
+ (void)xyf_thinkingSengGift:(OWLMusicGiftInfoModel *)model isPrivate:(BOOL)isPrivate isFast:(BOOL)isFast;

/// 成功进入某直播间
+ (void)xyf_thinkingEnterRoomSuccess:(OWLMusicRoomDetailModel *)detailModel fromWay:(XYLOutDataSourceEnterRoomType)fromWay;

/// 进入到离开单个直播的时间(该事件为计时事件/秒)
+ (void)xyf_thinkingTimeForOneLive:(OWLMusicRoomTotalModel *)totalModel;

/// 进入PK到退出PK的时长（秒）处于双人直播画面
+ (void)xyf_thinkingTimeForOnePK:(OWLMusicRoomTotalModel *)totalModel;

/// 游戏按钮点击
+ (void)xyf_thinkingClickGameIconWithGameID:(NSInteger)gameID;

/// 点击banner事件
+ (void)xyf_thinkingClickBannerWithName:(NSString *)name;

/// 1金币转盘点击事件
+ (void)xyf_thinkingClickOneCoinButton;

/// 礼物分类点击
+ (void)xyf_thinkingGiftThemeClick:(NSString *)themeName;

/// 礼物面板内礼物icon点击
+ (void)xyf_thinkingGiftPopupGiftClick:(OWLMusicGiftInfoModel *)model;

#pragma mark - Firebase
/// 金币减少
/*
 sendGift:送礼（送礼接口调成功）
 live-private:直播间带走
 activity:活动扣费
 */
+ (void)xyf_firebaseSpendCoin:(NSInteger)coins spendWay:(NSString *)spendWay;

#pragma mark - 埋点公共参数
+ (NSMutableDictionary *)xyf_addBasicInfo;

@end


#pragma mark - 直播间特有事件
/// 成功进入某个直播间(未开播房间也需触发统计)(每次进入)
static NSString * const XYLThinkingEventEnterRoomSuccess = @"enter_liveroom_success";
/// 进入到离开单个直播的时间(该事件为计时事件/秒)
static NSString * const XYLThinkingEventTimeForOneLive = @"time_for_one_live";
/// 进入PK到退出PK的时长（秒）处于双人直播画面
static NSString * const XYLThinkingEventTimeForOnePK = @"time_for_one_pk";
/// 点击主播头像(主持人)
static NSString * const XYLThinkingEventClickHostAvatar = @"click_host_avatar_in_live";
/// 点击直播间带走(房间右下角)
static NSString * const XYLThinkingEventClickPrivateButton = @"click_private_button_in_live";
/// pk点击送礼排行（双方都算）
static NSString * const XYLThinkingEventClickPKRankList = @"click_gift_rank_in_pk";
/// 点击弹幕区自动操作按钮-syahi
static NSString * const XYLThinkingEventClickMsgAutoSayHi = @"click_auto_say_hi_in_live";
/// 点击弹幕区自动操作按钮-关注
static NSString * const XYLThinkingEventClickMsgAutoFollow = @"click_auto_follow_in_live";
/// 点击弹幕区自动操作按钮-送礼
static NSString * const XYLThinkingEventClickMsgAutoSendGift = @"click_auto_send_gift_in_live";


#pragma mark - 直播间语聊房通用事件
/// 点击小窗关闭房间
static NSString * const XYLThinkingEventCloseRoomByMinimize = @"click_close_room_by_minimize";
/// 点击小窗回到房间
static NSString * const XYLThinkingEventReturnRoomByMinimize = @"click_return_room_by_minimize";
/// 点击送礼按钮
static NSString * const XYLThinkingEventClickGiftsButton = @"click_gifts_button";
/// 点击弹幕输入区域展开键盘
static NSString * const XYLThinkingEventShowKeyboard = @"click_input_open_keyboard";
/// 点击发送弹幕
static NSString * const XYLThinkingEventClickSendMsg = @"click_send_barrage_button";
/// 点击关闭按钮
static NSString * const XYLThinkingEventClickCloseButton = @"click_close_button";
/// 进入纯净模式
static NSString * const XYLThinkingEventEnterPureMode = @"enter_pure_mode";
/// 点击观众列表
static NSString * const XYLThinkingEventClickAudienceList = @"click_audience_list";
/// 点击小banner
static NSString * const XYLThinkingEventClickBanner = @"click_banner";
/// 点击房间目标
static NSString * const XYLThinkingEventClickQuota = @"click_quota";

/// ================ 新增 ================
/// 发言按钮点击✅ 和 click_input_open_keyboard 一样。点击弹出键盘
static NSString * const XYLThinkingEventClickBarrage = @"barrage_button_click";
/// 更多按钮点击✅
static NSString * const XYLThinkingEventClickMore = @"more_button_click";
/// 游戏大厅按钮点击✅
static NSString * const XYLThinkingEventClickGame = @"game_button_click";
/// 游戏按钮点击✅
static NSString * const XYLThinkingEventClickGameIcon = @"game_icon_button_click";
/// 游戏悬浮球点击（外部埋点）
static NSString * const XYLThinkingEventClickGameBall = @"game_ball_click";
/// 快捷送礼按钮点击✅点击连击都要
static NSString * const XYLThinkingEventClickFastGift = @"fast_gift_button_click";
/// 充值按钮点击✅
static NSString * const XYLThinkingEventClickRecharge = @"recharge_button_click";

#pragma mark - 礼物
/// 送礼
static NSString * const XYLThinkingEventSendGiftSuccess = @"send_gift_success";
/// 礼物面板曝光
static NSString * const XYLThinkingEventGiftPopupView = @"gift_popup_view";
/// 礼物分类点击
static NSString * const XYLThinkingEventGiftThemeClick = @"gift_theme_click";
/// 礼物面板内礼物icon点击
static NSString * const XYLThinkingEventGiftPopupGiftClick = @"gift_popup_gift_click";
/// 礼物面板充值按钮点击
static NSString * const XYLThinkingEventGiftPopupRechargeClick = @"gift_popup_recharge_click";

#pragma mark - 通话
/// 通话事件
static NSString * const XYLThinkingEventStartCall = @"start_call";

#pragma mark - 铁粉
/// 点击购买按钮
static NSString * const XYLThinkingEventClickBuyFreeMsg = @"click_buy_freemsg";
/// 点击免费私信
static NSString * const XYLThinkingEventClickGetFreeMsg = @"click_get_freemsg";

#pragma mark - 1金币优惠转盘
/// 点击抽奖按钮
static NSString * const XYLThinkingEventClickOneCoinButton = @"one_coin_button_click";
/// 抽奖弹窗曝光
static NSString * const XYLThinkingEventShowOneCoinPage = @"one_coin_page_view";

NS_ASSUME_NONNULL_END
